part of affogato.apis;

class AffogatoVFSAPI extends AffogatoAPIComponent {
  final Stream<VFSDocumentChangedEvent> documentChangedStream =
      AffogatoEvents.vfsDocumentChangedEventsController.stream;
  final Stream<VFSDocumentRequestChangeEvent> documentRequestChangeStream =
      AffogatoEvents.vfsDocumentRequestChangeEventsController.stream;
  final Stream<VFSStructureChangedEvent> structureChangedStream =
      AffogatoEvents.vfsStructureChangedEventsController.stream;

  AffogatoVFSAPI();

  @override
  void init() {}

  /// Applies the specified changes to the specified document in [event].
  void documentRequestChange(VFSDocumentRequestChangeEvent event) {
    AffogatoEvents.vfsDocumentRequestChangeEventsController.add(event);
  }

  /// This gets ahold of an entity in the VFS, so that actions can be performed on it.
  /// If the type of the entity is known in advance, then passing [isDir] accordingly will
  /// help filter results faster.
  /// The [stepCallback], if specified, will be called on each item that is accessed during the recursive
  /// search process, and the supplied [AffogatoVFSEntity] argument will be the current item of the search. This
  /// is useful for performing side actions during search, such as collecing the paths of parent entities.
  /// However, this method stops once the target entity is found. To exhaustively iterate over all subdirs and files,
  /// use [traverseBFS] instead.
  AffogatoVFSEntity? accessEntity<T>(
    String id, {
    bool? isDir,
    void Function(AffogatoVFSEntity)? stepCallback,
    void Function(AffogatoVFSEntity?)? action,
  }) {
    // only use the cache if the caller has not provided any callbacks to be executed
    if (stepCallback == null &&
        action == null &&
        api.workspace.workspaceConfigs.vfs.cache.containsKey(id)) {
      return api.workspace.workspaceConfigs.vfs.cache[id]!;
    }
    final res = api.workspace.workspaceConfigs.vfs.root.findById(
      id,
      isDir: isDir,
      stepCallback: stepCallback,
      action: action,
    );
    if (res != null) {
      return api.workspace.workspaceConfigs.vfs.cache[id] = res;
    } else {
      return null;
    }
  }

  String? pathToEntity(String id) {
    final List<String> path = [];
    if (accessEntity(
          id,
          stepCallback: (item) => path.add(item.name),
        ) !=
        null) {
      return path.reversed.join('/');
    } else {
      return null;
    }
  }

  bool traverseBFS(
    void Function(AffogatoVFSEntity) stepCallback, {
    String? startDirId,
  }) {
    final AffogatoVFSEntity? entity;
    if (startDirId != null) {
      entity = accessEntity(startDirId, isDir: true);
      if (entity == null) {
        return false;
      }
    } else {
      entity = api.workspace.workspaceConfigs.vfs.root;
    }
    final List<AffogatoVFSEntity> fileQueue = entity.files;
    final List<AffogatoVFSEntity> dirQueue = entity.subdirs;
    void iterateOverFiles() {
      for (final file in fileQueue) {
        stepCallback(file);
      }
      fileQueue.clear();
    }

    void iterateOverDirs() {
      final List<AffogatoVFSEntity> newDirQueue = [];
      for (final dir in dirQueue) {
        fileQueue.addAll(dir.files);
        newDirQueue.addAll(dir.subdirs);
        stepCallback(dir);
      }
      dirQueue
        ..clear()
        ..addAll(newDirQueue);
    }

    // Iterate until there are no more subdirectories
    while (dirQueue.isNotEmpty) {
      // Clear the queue of files from the parent directory/directories
      if (fileQueue.isNotEmpty) {
        iterateOverFiles();
      }
      // Expand the subdirectories, adding to each queue the items for the next iteration
      iterateOverDirs();
    }
    // Call this one last time to clear the files expanded from the last subdir
    iterateOverFiles();
    return true;
  }

  bool updateFile(String id, String newContent) {
    final AffogatoVFSEntity? file = accessEntity(id, isDir: false);
    if (file != null) {
      file.document!.contentVersions.add(newContent);
      return true;
    }
    return false;
  }

  /// The method caller is responsible for ensuring that the [AffogatoVFSEntity.entityId] field of the
  /// provided [entity] does not have any collisions. This method checks to ensure that there are no conflicting
  /// names of files/directories in the specified location, [dir], before inserting the entity.
  bool createEntity(AffogatoVFSEntity entity, {String? dirId}) {
    final AffogatoVFSEntity? dir = dirId != null
        ? accessEntity(dirId)
        : api.workspace.workspaceConfigs.vfs.root;
    if (dir == null) return false;

    if ((entity.isDirectory ? dir.subdirs : dir.files)
        .every((item) => item.name != entity.name)) {
      (entity.isDirectory ? dir.subdirs : dir.files).add(entity);
      return true;
    }
    return false;
  }

  bool deleteEntity(String entityId) {
    AffogatoVFSEntity parentDir = api.workspace.workspaceConfigs.vfs.root;
    final AffogatoVFSEntity? result = accessEntity(
      entityId,
      isDir: false,
      stepCallback: (currentItem) {
        if (currentItem.isDirectory) parentDir = currentItem;
      },
    );
    if (result == null) return false;

    api.workspace.workspaceConfigs.vfs.bin[entityId] = result;
    // Remember not to call [accessEntity] or other methods that depend on the cache
    // after it has been updated.
    api.workspace.workspaceConfigs.vfs.cache.remove(entityId);
    if (!result.isDirectory) {
      parentDir.files.remove(result);
    } else {
      parentDir.subdirs.remove(result);
      traverseBFS(
        startDirId: result.entityId,
        (e) {
          api.workspace.workspaceConfigs.vfs.bin[e.entityId] = e;
          api.workspace.workspaceConfigs.vfs.cache.remove(e.entityId);
        },
      );
    }
    return true;
  }

  /// A similar implementation to [deleteEntity], except that the entity cache is not updated
  /// and the directory specified by [newDirId] gets updated to contain the entity specified by [entityId].
  bool moveEntity({
    required String entityId,
    required String newDirId,
  }) {
    AffogatoVFSEntity? parentDir;
    final AffogatoVFSEntity? result = accessEntity(
      entityId,
      stepCallback: (currentItem) {
        if (parentDir == null &&
            currentItem.isDirectory &&
            currentItem.entityId != entityId) {
          parentDir = currentItem;
        }
      },
    );
    final AffogatoVFSEntity? target = accessEntity(newDirId, isDir: true);
    if (result == null || target == null) return false;

    if (!result.isDirectory) {
      parentDir!.files.remove(result);
      target.files.add(result);
    } else {
      parentDir!.subdirs.remove(result);
      target.subdirs.add(result);
    }

    return true;
  }

  String dumpTree() => api.workspace.workspaceConfigs.vfs.root.dumpTree(0);

  @override
  int get hashCode =>
      jsonEncode(api.workspace.workspaceConfigs.vfs.toJson()).hashCode;

  @override
  bool operator ==(Object other) =>
      other is AffogatoVFS &&
      other.toJson() == api.workspace.workspaceConfigs.vfs.toJson();
}

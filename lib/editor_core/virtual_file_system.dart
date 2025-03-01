part of affogato.editor;

class AffogatoVFS {
  final AffogatoVFSEntity root;
  final Map<String, AffogatoVFSEntity> cache = {};
  final Map<String, AffogatoVFSEntity> bin = {};

  // maybe also implement a cache to map entityIds to their filepaths

  AffogatoVFS({
    required this.root,
  });

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
  }) {
    // only use the cache if the caller has not provided a `stepCallback` to be executed
    if (stepCallback == null && cache.containsKey(id)) return cache[id]!;
    final res = root.findById(
      id,
      isDir: isDir,
      stepCallback: stepCallback,
    );
    if (res != null) {
      return cache[id] = res;
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
      return path.join('/');
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
      entity = root;
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
    final AffogatoVFSEntity? dir = dirId != null ? accessEntity(dirId) : root;
    if (dir == null) return false;

    if ((entity.isDirectory ? dir.subdirs : dir.files)
        .every((item) => item.name != entity.name)) {
      (entity.isDirectory ? dir.subdirs : dir.files).add(entity);
      return true;
    }
    return false;
  }

  bool deleteEntity(String entityId) {
    AffogatoVFSEntity parentDir = root;
    final AffogatoVFSEntity? result = accessEntity(
      entityId,
      isDir: false,
      stepCallback: (currentItem) {
        if (currentItem.isDirectory) parentDir = currentItem;
      },
    );
    if (result == null) return false;

    bin[entityId] = result;
    // Remember not to call [accessEntity] or other methods that depend on the cache
    // after it has been updated.
    cache.remove(entityId);
    if (!result.isDirectory) {
      parentDir.files.remove(result);
    } else {
      parentDir.subdirs.remove(result);
      traverseBFS(
        startDirId: result.entityId,
        (e) {
          bin[e.entityId] = e;
          cache.remove(e.entityId);
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

  String dumpTree() => root.dumpTree(0);
}

class AffogatoVFSEntity {
  final String entityId;
  final String name;
  final bool isDirectory;

  /// Directory-only properties
  final List<AffogatoVFSEntity> subdirs;
  final List<AffogatoVFSEntity> files;

  /// File-only properties
  AffogatoDocument? document;

  AffogatoVFSEntity.file({
    required this.entityId,
    required AffogatoDocument doc,
  })  : isDirectory = false,
        subdirs = const [],
        files = const [],
        document = doc,
        name = doc.docName;

  AffogatoVFSEntity.dir({
    required this.entityId,
    required this.name,
    required this.files,
    required this.subdirs,
  })  : isDirectory = true,
        document = null;

  AffogatoVFSEntity? findById(
    String id, {
    bool? isDir,
    void Function(AffogatoVFSEntity)? stepCallback,
  }) {
    if (entityId == id) {
      if (stepCallback != null) stepCallback(this);
      return this;
    }

    if (isDirectory) {
      for (final file in files) {
        if (file.entityId == id) {
          if (stepCallback != null) stepCallback(this);
          return file;
        }
      }

      for (final subdir in subdirs) {
        final subdirSearchRes =
            subdir.findById(id, isDir: isDir, stepCallback: stepCallback);
        if (subdirSearchRes != null) {
          if (stepCallback != null) stepCallback(this);
          return subdirSearchRes;
        }
      }
    }

    return null;
  }

  String dumpTree(int indent) {
    final List<String> lines = [];

    if (isDirectory) {
      lines.add("${' ' * indent}|- $name/         ($entityId)");

      for (final subdir in subdirs) {
        lines.add(subdir.dumpTree(indent + 2));
      }
      for (final file in files) {
        lines.add(file.dumpTree(indent + 2));
      }
    } else {
      return "${' ' * indent}|- $name          ($entityId)";
    }

    return lines.join('\n');
  }
}

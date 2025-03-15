part of affogato.editor;

class AffogatoVFS {
  final AffogatoVFSEntity root;
  final Map<String, AffogatoVFSEntity> cache = {};
  final Map<String, AffogatoVFSEntity> bin = {};

  // maybe also implement a cache to map entityIds to their filepaths

  AffogatoVFS({
    required this.root,
  });

  Map<String, Object?> toJson() => {
        'root': root.toJson(),
        'cache': cache.map((key, entity) => MapEntry(key, entity.toJson())),
        'bin': bin.map((key, entity) => MapEntry(key, entity.toJson())),
      };
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
    void Function(AffogatoVFSEntity?)? action,
  }) {
    if (entityId == id) {
      stepCallback?.call(this);
      action?.call(this);
      return this;
    }

    if (isDirectory) {
      for (final file in files) {
        if (file.entityId == id) {
          stepCallback?.call(this);
          action?.call(file);
          return file;
        }
      }

      for (final subdir in subdirs) {
        final subdirSearchRes = subdir.findById(
          id,
          isDir: isDir,
          stepCallback: stepCallback,
          action: action,
        );
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

  Map<String, Object?> toJson() => {
        'entityId': entityId,
        'name': name,
        'isDirectory': isDirectory,
        'files': files.map((f) => f.toJson()),
        'subdirs': subdirs.map((s) => s.toJson()),
      };

  @override
  int get hashCode => entityId.hashCode;

  @override
  bool operator ==(Object other) =>
      other is AffogatoVFSEntity && other.toJson() == toJson();
}

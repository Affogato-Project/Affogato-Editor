part of affogato.editor;

class AffogatoFileManager {
  /// Stores all the [AffogatoDocument]s in the project, each one associated with an ID.
  final Map<String, AffogatoDocument> documentsRegistry = {};

  /// Stores all the document IDs, with each one associated to the directory path it is in
  final Map<String, List<String>> directoriesRegistry = {};

  bool hasBuiltIndex = false;

  AffogatoFileManager();

  /// Returns all the documents by ID in a directory and its subdirectories.
  /// The keys are the directory paths of each document's location. The IDs are the
  /// document IDs that correspond to entries in the [documentsRegistry]
  /// This implementation does the following:
  /// 1. Concatenate the current dir path with the parent dir to get the full path
  /// 2. Return the IDs of the documents in the current dir, assuming these IDs are already present in the [documentsRegistry]
  /// 3. Recursively call itself for each subdirectory, concatenating the results into one large Map
  ///
  /// Trying to squeeze a whole recursive function body into the return statement makes me feel alive.
  Map<String, List<String>> _expandDir(
    AffogatoDirectoryItem dir, [
    String? parentPath,
  ]) {
    return {
      '${parentPath != null ? parentPath : ""}${dir.dirPath}':
          dir.documents.map((d) => d.documentId).toList(),
      ...{
        for (final subdir in dir.directories)
          ..._expandDir(
              subdir, '${parentPath != null ? parentPath : ""}${dir.dirPath}'),
      }
    };
  }

  void buildIndex([AffogatoDirectoryItem? projDir]) {
    if (hasBuiltIndex) return;
    directoriesRegistry
      ..clear()
      ..addAll(_expandDir(projDir ?? const AffogatoDirectoryItem('./')));
    hasBuiltIndex = true;
  }

  bool existsDir(String path) => directoriesRegistry.containsKey(path);

  List<String> getSubdirectoriesInDir(String path) {
    if (existsDir(path)) {
      final int nestingLevel = path.split('/').length;
      return directoriesRegistry.keys
          .where((p) =>
              p.startsWith(path) &&
              p !=
                  path && // this prevents parent subdirectory itself from being shown
              p.split('/').length ==
                  nestingLevel +
                      1) // this prevents nested subdirectories from being shown
          .toList();
    } else {
      throw Exception("Directory with path '$path' not found");
    }
  }

  List<String> getDocsInDir(String path) {
    if (existsDir(path)) {
      return directoriesRegistry[path]!;
    } else {
      throw Exception("Directory with path '$path' not found");
    }
  }

  AffogatoDocument getDoc(String id) =>
      documentsRegistry[id] ??
      (throw Exception('Document with id $id not found'));

  void createDir(String name, [String? parent]) {
    parent ??= './';
    if (existsDir(parent)) {
      directoriesRegistry.addAll({'$parent$name': []});
    } else {
      throw Exception("Invalid path: '$parent' does not exist");
    }
  }

  void createDoc(AffogatoDocument document, {String? path}) {
    path ??= './';
    if (existsDir(path)) {
      final String docId = utils.generateId();
      directoriesRegistry[path]!.add(docId);
      documentsRegistry[docId] = document;
    } else {
      throw Exception(
          "Invalid path: '$path' does not exist, or is not a directory.");
    }
  }
}

sealed class AffogatoFileItem {
  const AffogatoFileItem();

  String get hash;
}

class AffogatoDocumentItem extends AffogatoFileItem {
  final String documentId;
  const AffogatoDocumentItem(this.documentId);

  @override
  String get hash => documentId;
}

class AffogatoDirectoryItem extends AffogatoFileItem {
  final String dirPath;
  final List<AffogatoDocumentItem> documents;
  final List<AffogatoDirectoryItem> directories;

  const AffogatoDirectoryItem(
    this.dirPath, {
    this.documents = const [],
    this.directories = const [],
  });

  @override
  String get hash => dirPath;
}

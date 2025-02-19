part of affogato.editor;

class LayoutConfigs {
  final double width;
  final double height;
  final double? x;
  final double? y;

  const LayoutConfigs({
    required this.width,
    required this.height,
    this.x,
    this.y,
  });
}

class AffogatoStylingConfigs {
  final double windowWidth;
  final double windowHeight;
  final double tabBarHeight;
  final double editorFontSize;
  final ThemeBundle<RenderToken, SyntaxHighlighter, Color, TextStyle>
      themeBundle;

  const AffogatoStylingConfigs({
    required this.windowHeight,
    required this.windowWidth,
    required this.tabBarHeight,
    required this.themeBundle,
    required this.editorFontSize,
  });
}

enum InstanceRendererType {
  /// Saves the [AffogatoInstanceState] of each opened editor. Uses slightly
  /// more memory but allows high-speed document switching. More suited for large
  /// documents which take time to parse and highlight.
  savedState,

  /// Runs the tokeniser-parser-resolver-painter pipeline every time the document
  /// is focused. Better suited for small to medium-sized documents.
  adHoc,
}

class AffogatoPerformanceConfigs {
  final InstanceRendererType rendererType;

  const AffogatoPerformanceConfigs({
    required this.rendererType,
  });
}

class AffogatoWorkspaceConfigs {
  bool hasBuiltDirStruct = false;

  /// A mapping of filepaths to [AffogatoDocument]s that the editor initially loads up
  /// into [dirStructure].
  final List<FileItem> initStructure;

  /// A mapping of pane IDs to the IDs of the [AffogatoDocument]s contained by that pane
  final Map<String, List<String>> paneDocumentData;

  /// Stores the live directory structure of the workspace as files are being edited,
  /// by mapping directory paths to the list of document IDs in that directory.
  final Map<String, List<String>> dirStructure = {};

  /// Stores all the [AffogatoDocument]s in the project, each one associated with an ID.
  final Map<String, AffogatoDocument> documentsRegistry = {};

  /// Stores the instance states for opened documents, each one associated with the
  /// corresponding document IDs.
  final Map<String, AffogatoInstanceState> statesRegistry = {};

  final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter, Color,
      TextStyle> themeBundle;

  final int tabSizeInSpaces;

  final LanguageBundle Function(String extension) languageBundleDetector;

  AffogatoWorkspaceConfigs({
    required this.initStructure,
    required this.paneDocumentData,
    required this.languageBundleDetector,
    required this.themeBundle,
    this.tabSizeInSpaces = 4,
  });

  void buildDirStructure() {
    // Should only be called once per instance.
    if (hasBuiltDirStruct) return;
    void iterateEntriesInDir(
      FileDirectoryItem dir, [
      String? parentDirPath,
    ]) {
      final List<String> documentIdsForDir = [];
      // iterate over the files in this dir
      for (final docEntry in dir.entries.whereType<FileDocumentItem>()) {
        final String docId = utils.generateId();
        documentsRegistry[docId] = docEntry.document;
        documentIdsForDir.add(docId);
      }
      final String dirPath = '${parentDirPath ?? ""}${dir.dirName}';
      dirStructure[dirPath] = documentIdsForDir;
      // iterate over the sub-directories in this dir
      for (final dirEntry in dir.entries.whereType<FileDirectoryItem>()) {
        iterateEntriesInDir(dirEntry, dirPath);
      }
    }

    iterateEntriesInDir(
      FileDirectoryItem(
        dirName: './',
        entries: initStructure,
      ),
    );
    hasBuiltDirStruct = true;
  }

  AffogatoDocument getDoc(String id) =>
      documentsRegistry[id] ??
      (throw Exception('Document with id $id not found'));

  List<String> getDir(String dirPath) =>
      dirStructure[dirPath] ??
      (throw Exception('Directory with id $dirPath not found'));

  List<FileItem> saveWorkspaceDir() {
    throw UnimplementedError();
  }
}

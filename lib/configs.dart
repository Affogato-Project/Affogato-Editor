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
  final String projectName;

  bool hasBuiltDirStruct = false;

  /// A mapping of pane IDs to the IDs of the [AffogatoDocument]s contained by that pane
  final Map<String, List<String>> paneDocumentData;

  /// Stores the instance states for opened documents, each one associated with the
  /// corresponding document IDs.
  final Map<String, AffogatoInstanceState> statesRegistry = {};

  final AffogatoFileManager fileManager = AffogatoFileManager();

  final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter, Color,
      TextStyle> themeBundle;

  final int tabSizeInSpaces;

  final LanguageBundle Function(String extension) languageBundleDetector;

  AffogatoWorkspaceConfigs({
    required this.projectName,
    required this.paneDocumentData,
    required this.languageBundleDetector,
    required this.themeBundle,
    this.tabSizeInSpaces = 4,
  });

  bool isDocumentShown(String documentId) => paneDocumentData.values
      .firstWhere(
        (pane) => pane.contains(documentId),
        orElse: () => const [],
      )
      .isNotEmpty;
}

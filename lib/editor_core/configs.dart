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
  final int tabSizeInSpaces;

  const AffogatoStylingConfigs({
    required this.windowHeight,
    required this.windowWidth,
    required this.tabBarHeight,
    required this.editorFontSize,
    this.tabSizeInSpaces = 4,
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

  final List<AffogatoExtension> extensions;

  /// A mapping of pane IDs to the IDs of the [AffogatoDocument]s contained by that pane
  final Map<String, List<String>> paneDocumentData;

  /// Stores the instance states for opened documents, each one associated with the
  /// corresponding document IDs.
  final Map<String, AffogatoInstanceState> statesRegistry = {};

  final AffogatoFileManager fileManager = AffogatoFileManager();

  final ThemeBundle<dynamic, Color, TextStyle, TextSpan> themeBundle;

  /// A mapping of [LanguageBundle]s to possible file extensions for each language
  /// Each entry will be checked first to find a suitable user-defined [LanguageBundle] for a given
  /// file extension, before the [LanguageBundle.fileAssociationContributions] that is provided by the
  /// creator of the language bundle is traversed.
  final Map<LanguageBundle, List<String>> languageBundles;

  final AffogatoStylingConfigs stylingConfigs;

  AffogatoWorkspaceConfigs({
    required this.projectName,
    required this.paneDocumentData,
    required this.themeBundle,
    required this.languageBundles,
    required this.stylingConfigs,
    required this.extensions,
  });

  bool isDocumentShown(String documentId) => paneDocumentData.values
      .firstWhere(
        (pane) => pane.contains(documentId),
        orElse: () => const [],
      )
      .isNotEmpty;

  LanguageBundle? detectLanguage(String extension) {
    for (final entry in languageBundles.entries) {
      if (entry.value.contains(extension) ||
          entry.key.fileAssociationContributions.contains(extension)) {
        return entry.key;
      }
    }
    return null;
  }
}

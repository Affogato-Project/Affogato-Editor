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
  final Color windowColor;
  final Color editorColor;
  final Color borderColor;

  const AffogatoStylingConfigs({
    required this.windowHeight,
    required this.windowWidth,
    required this.tabBarHeight,
    required this.windowColor,
    required this.editorColor,
    required this.borderColor,
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

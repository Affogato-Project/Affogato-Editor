part of affogato.editor;

class AffogatoTextSelectionControls extends TextSelectionControls {
  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    // TODO: implement buildHandle
    throw UnimplementedError();
  }

  @override
  Size getHandleSize(double textLineHeight) {
    // TODO: implement getHandleSize
    throw UnimplementedError();
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    // TODO: implement getHandleAnchor
    throw UnimplementedError();
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect rec,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    throw UnimplementedError();
  }
}

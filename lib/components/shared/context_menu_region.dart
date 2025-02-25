part of affogato.editor;

class ContextMenuRegion<T extends Record> extends StatefulWidget {
  final Widget Function(BuildContext, Offset) contextMenuBuilder;
  final Widget child;

  const ContextMenuRegion({
    required this.contextMenuBuilder,
    required this.child,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ContextMenuRegionState();
}

class ContextMenuRegionState extends State<ContextMenuRegion> {
  final ContextMenuController controller = ContextMenuController();
  Offset anchorPos = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => ContextMenuController.removeAny(),
      onSecondaryTapUp: (details) {
        anchorPos = details.globalPosition;
        controller.show(
          context: context,
          contextMenuBuilder: (ctx) => widget.contextMenuBuilder(
            ctx,
            anchorPos,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    controller.remove();
    super.dispose();
  }
}

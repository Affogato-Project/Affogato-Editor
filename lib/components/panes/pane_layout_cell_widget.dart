part of affogato.editor;

/// The widget responsible for laying out and sizing panes in the [AffogatoWindow],
/// based on the [AffogatoWorkspaceConfigs.panesLayout]. It also handles resizing and docking
/// of drag-and-drop for [PaneInstance]s.
class PaneLayoutCellWidget extends StatefulWidget {
  final AffogatoAPI api;
  final AffogatoPerformanceConfigs performanceConfigs;
  final String cellId;

  const PaneLayoutCellWidget({
    required this.api,
    required this.performanceConfigs,
    required this.cellId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PaneLayoutCellWidgetState();
}

class PaneLayoutCellWidgetState extends State<PaneLayoutCellWidget>
    with utils.StreamSubscriptionManager {
  late PaneList cellState;
  double delta = 0;

  loadData() {
    cellState = widget.api.window.panes.findCellById(widget.cellId);
  }

  @override
  void initState() {
    loadData();

    registerListener(
      widget.api.window.panes.cellRequestReloadStream
          .where((event) => event.cellId == widget.cellId),
      (_) {
        loadData();
        if (cellState is MultiplePaneList) {
          for (final child in (cellState as MultiplePaneList).value) {
            AffogatoEvents.windowPaneCellRequestReloadEventsController
                .add(WindowPaneCellRequestReloadEvent(child.id));
          }
        } else {}
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cellState is SinglePaneList) {
      return SizedBox(
        width: cellState.width,
        height: cellState.height,
        child: EditorPane(
          cellId: cellState.id,
          layoutConfigs: LayoutConfigs(
            width: cellState.width,
            height: cellState.height,
          ),
          api: widget.api,
        ),
      );
    } else if (cellState is HorizontalPaneList) {
      return SizedBox(
        width: cellState.width,
        height: cellState.height,
        child: Row(
          children: [
            for (final child in (cellState as HorizontalPaneList).value) ...[
              PaneLayoutCellWidget(
                cellId: child.id,
                api: widget.api,
                performanceConfigs: widget.performanceConfigs,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Draggable(
                  axis: Axis.horizontal,
                  onDragUpdate: (details) {
                    widget.api.window.panes.resizePane(
                      child.id,
                      parent: cellState as MultiplePaneList,
                      deltaRight: details.delta.dx,
                    );

                    setState(() {});
                  },
                  feedback: Container(
                    width: 2,
                    height: cellState.height,
                    color: widget.api.workspace.workspaceConfigs.themeBundle
                            .editorTheme.focusBorder ??
                        Colors.red,
                  ),
                  child: Container(
                    width: 1,
                    height: cellState.height,
                    color: widget.api.workspace.workspaceConfigs.themeBundle
                            .editorTheme.panelBorder ??
                        Colors.red,
                  ),
                ),
              ),
            ]
          ]..removeLast(),
        ),
      );
    } else if (cellState is VerticalPaneList) {
      return SizedBox(
        width: cellState.width,
        height: cellState.height,
        child: Column(
          children: [
            for (final child in (cellState as VerticalPaneList).value) ...[
              PaneLayoutCellWidget(
                cellId: child.id,
                api: widget.api,
                performanceConfigs: widget.performanceConfigs,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: Draggable(
                  axis: Axis.vertical,
                  onDragUpdate: (details) {
                    widget.api.window.panes.resizePane(
                      child.id,
                      parent: cellState as MultiplePaneList,
                      deltaBottom: details.delta.dy,
                    );

                    setState(() {});
                  },
                  feedback: Container(
                    height: 2,
                    width: cellState.width,
                    color: widget.api.workspace.workspaceConfigs.themeBundle
                            .editorTheme.focusBorder ??
                        Colors.red,
                  ),
                  child: Container(
                    height: 1,
                    width: cellState.width,
                    color: widget.api.workspace.workspaceConfigs.themeBundle
                            .editorTheme.panelBorder ??
                        Colors.red,
                  ),
                ),
              ),
            ]
          ],
        ),
      );
    } else {
      throw Exception('impossibel');
    }
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}

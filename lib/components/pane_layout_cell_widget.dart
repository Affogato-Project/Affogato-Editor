part of affogato.editor;

/// The widget responsible for laying out and sizing panes in the [AffogatoWindow],
/// based on the [AffogatoWorkspaceConfigs.paneManager.panesLayout]. It also handles resizing and docking
/// of drag-and-drop for [PaneInstance]s.
class PaneLayoutCellWidget extends StatefulWidget {
  final AffogatoAPI api;
  final AffogatoPerformanceConfigs performanceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;
  final String cellId;

  const PaneLayoutCellWidget({
    required this.api,
    required this.performanceConfigs,
    required this.windowKey,
    required this.cellId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PaneLayoutCellWidgetState();
}

class PaneLayoutCellWidgetState extends State<PaneLayoutCellWidget>
    with utils.StreamSubscriptionManager {
  late PaneList cellState;

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
        if (cellState is MultiplePaneList) {
          for (final child in (cellState as MultiplePaneList).value) {
            AffogatoEvents.windowPaneCellRequestReloadEventsController
                .add(WindowPaneCellRequestReloadEvent(child.id));
          }
        }
        setState(() {
          loadData();
        });
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
          paneId: (cellState as SinglePaneList).paneId,
          cellId: cellState.id,
          layoutConfigs: LayoutConfigs(
            width: cellState.width,
            height: cellState.height,
          ),
          api: widget.api,
          windowKey: widget.windowKey,
        ),
      );
    } else if (cellState is HorizontalPaneList) {
      return SizedBox(
        width: cellState.width,
        height: cellState.height,
        child: Row(
          children: [
            for (final child in (cellState as HorizontalPaneList).value)
              PaneLayoutCellWidget(
                cellId: child.id,
                api: widget.api,
                performanceConfigs: widget.performanceConfigs,
                windowKey: widget.windowKey,
              ),
          ],
        ),
      );
    } else if (cellState is VerticalPaneList) {
      return SizedBox(
        width: cellState.width,
        height: cellState.height,
        child: Column(
          children: [
            for (final child in (cellState as VerticalPaneList).value)
              PaneLayoutCellWidget(
                cellId: child.id,
                api: widget.api,
                performanceConfigs: widget.performanceConfigs,
                windowKey: widget.windowKey,
              ),
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

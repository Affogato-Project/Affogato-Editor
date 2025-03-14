part of affogato.editor;

/// The widget responsible for laying out and sizing panes in the [AffogatoWindow],
/// based on the [AffogatoWorkspaceConfigs.paneManager.panesLayout]. It also handles resizing and docking
/// of drag-and-drop for [PaneInstance]s.
class PaneLayoutCellWidget extends StatefulWidget {
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoAPI api;
  final AffogatoPerformanceConfigs performanceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;
  final String cellId;

  const PaneLayoutCellWidget({
    required this.workspaceConfigs,
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
    cellState = widget.workspaceConfigs.paneManager.findCellById(widget.cellId);
  }

  @override
  void initState() {
    loadData();
    registerListener(
      widget.api.window.panes.layoutChangedStream
          .where((event) => event.cellId == widget.cellId),
      (_) {
        setState(() {
          loadData();
        });
        if (cellState is MultiplePaneList) {
          for (final child in (cellState as MultiplePaneList).value) {
            AffogatoEvents.windowPaneLayoutChangedEventsController
                .add(WindowPaneLayoutChangedEvent(child.id));
          }
        }
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
          stylingConfigs: widget.workspaceConfigs.stylingConfigs,
          layoutConfigs: LayoutConfigs(
            width: cellState.width,
            height: cellState.height,
          ),
          api: widget.api,
          performanceConfigs: widget.performanceConfigs,
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
                workspaceConfigs: widget.workspaceConfigs,
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
                workspaceConfigs: widget.workspaceConfigs,
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

part of affogato.editor;

/// The widget responsible for laying out and sizing panes in the [AffogatoWindow],
/// based on the [AffogatoWorkspaceConfigs.paneManager.panesLayout]. It also handles resizing and docking
/// of drag-and-drop for [PaneInstance]s.
class PaneLayoutCellWidget extends StatefulWidget {
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoExtensionsEngine extensionsEngine;
  final AffogatoPerformanceConfigs performanceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;
  final String cellId;

  const PaneLayoutCellWidget({
    required this.workspaceConfigs,
    required this.extensionsEngine,
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
      AffogatoEvents.editorPaneLayoutChangedEvents.stream
          .where((event) => event.cellId == widget.cellId),
      (_) {
        setState(() {
          loadData();
        });
        if (cellState is MultiplePaneList) {
          for (final child in (cellState as MultiplePaneList).value) {
            AffogatoEvents.editorPaneLayoutChangedEvents
                .add(EditorPaneLayoutChangedEvent(child.id));
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
          key: ValueKey(
              '${(cellState as SinglePaneList).paneId}${widget.workspaceConfigs.panesData[(cellState as SinglePaneList).paneId]}'),
          paneId: (cellState as SinglePaneList).paneId,
          cellId: cellState.id,
          stylingConfigs: widget.workspaceConfigs.stylingConfigs,
          layoutConfigs: LayoutConfigs(
            width: cellState.width,
            height: cellState.height,
          ),
          extensionsEngine: widget.extensionsEngine,
          performanceConfigs: widget.performanceConfigs,
          workspaceConfigs: widget.workspaceConfigs,
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
                extensionsEngine: widget.extensionsEngine,
                performanceConfigs: widget.performanceConfigs,
                windowKey: widget.windowKey,
              ),
          ],
        ),
      );
    } else if (cellState is VerticalPaneList) {
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final double itemHeight = (cellState.height) /
              (cellState as HorizontalPaneList).value.length;
          return SizedBox(
            width: cellState.width,
            height: itemHeight,
            child: Column(
              children: [
                for (final child in (cellState as HorizontalPaneList).value)
                  PaneLayoutCellWidget(
                    cellId: child.id,
                    workspaceConfigs: widget.workspaceConfigs,
                    extensionsEngine: widget.extensionsEngine,
                    performanceConfigs: widget.performanceConfigs,
                    windowKey: widget.windowKey,
                  ),
              ],
            ),
          );
        },
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

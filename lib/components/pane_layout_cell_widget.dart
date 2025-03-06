part of affogato.editor;

/// The widget responsible for laying out and sizing panes in the [AffogatoWindow],
/// based on the [AffogatoWorkspaceConfigs.paneLayoutData]. It also handles resizing and docking
/// of drag-and-drop for [PaneInstance]s.
class PaneLayoutCellWidget extends StatefulWidget {
  final PaneLayoutCell cell;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoExtensionsEngine extensionsEngine;
  final AffogatoPerformanceConfigs performanceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;

  const PaneLayoutCellWidget({
    required this.cell,
    required this.workspaceConfigs,
    required this.extensionsEngine,
    required this.performanceConfigs,
    required this.windowKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PaneLayoutCellWidgetState();
}

class PaneLayoutCellWidgetState extends State<PaneLayoutCellWidget>
    with utils.StreamSubscriptionManager {
  late PaneLayoutCell cellState;

  loadData() {
    cellState = widget.cell;
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellState.width,
      height: cellState.height,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final Widget child;
    final bool needsLayoutBuilder =
        cellState.width == null || cellState.height == null;
    if (cellState.verticalChildren.isNotEmpty) {
      child = needsLayoutBuilder
          ? LayoutBuilder(
              builder: (ctx, constraints) => Column(
                children: layoutChildren(
                  axis: Axis.vertical,
                  cellState.verticalChildren,
                  availWidth: constraints.maxWidth,
                  availHeight: constraints.maxHeight,
                ),
              ),
            )
          : Column(
              children: layoutChildren(
                axis: Axis.vertical,

                cellState.verticalChildren,
                // these constraints will be ignored anyway
                availWidth: 0,
                availHeight: 0,
              ),
            );
    } else if (cellState.horizontalChildren.isNotEmpty) {
      // A Row is the default if both [verticalChildren] and [horizontalChildren] are empty
      child = needsLayoutBuilder
          ? LayoutBuilder(
              builder: (ctx, constraints) => Row(
                children: layoutChildren(
                  axis: Axis.horizontal,
                  cellState.horizontalChildren,
                  availWidth: constraints.maxWidth,
                  availHeight: constraints.maxHeight,
                ),
              ),
            )
          : Row(
              children: layoutChildren(
                axis: Axis.horizontal,
                cellState.horizontalChildren,
                // these constraints will be ignored anyway
                availWidth: 0,
                availHeight: 0,
              ),
            );
    } else {
      child = const Row(children: []);
    }

    return child;
  }

  List<Widget> layoutChildren(
    List<utils.Either<PaneLayoutCell, String>> children, {
    required Axis axis,
    required double availWidth,
    required double availHeight,
  }) {
    // First, we set the total available width and height
    availWidth = cellState.width ?? availWidth;
    availHeight = cellState.height ?? availHeight;

    // Then we compute how much leftover space there is after the children with an explicit
    // width/height are laid out. If the axis is horizontal, the height will be availHeight, and
    // if the axis is vertical, then the width will be availWidth.
    double usedWidth = axis == Axis.horizontal ? 0 : availWidth;
    double usedHeight = axis == Axis.vertical ? 0 : availWidth;
    int numUnconstrainedChildren = 0;
    for (final child in children) {
      if (axis == Axis.horizontal) {
        if (child.$1 != null && child.$1!.width != null) {
          usedWidth += child.$1!.width!;
        } else {
          numUnconstrainedChildren += 1;
        }
      } else {
        if (child.$1 != null && child.$1!.height != null) {
          usedHeight += child.$1!.height!;
        } else {
          numUnconstrainedChildren += 1;
        }
      }
    }

    final double widthPerUnconstrainedChild = axis == Axis.horizontal
        ? (availWidth - usedWidth) / numUnconstrainedChildren
        : availWidth;

    final double heightPerUnconstrainedChild = axis == Axis.vertical
        ? (availHeight - usedHeight) / numUnconstrainedChildren
        : availHeight;

    final List<Widget> results = [];
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      if (child.$1 != null) {
        results.add(
          PaneLayoutCellWidget(
            cell: child.$1!,
            workspaceConfigs: widget.workspaceConfigs,
            extensionsEngine: widget.extensionsEngine,
            performanceConfigs: widget.performanceConfigs,
            windowKey: widget.windowKey,
          ),
        );
      } else if (child.$2 != null) {
        results.add(
          SizedBox(
            width: cellState.width,
            height: cellState.height,
            child: EditorPane(
              key: ValueKey(
                  '${child.$2}${widget.workspaceConfigs.panesData[child.$2]}'),
              paneId: child.$2!,
              stylingConfigs: widget.workspaceConfigs.stylingConfigs,
              layoutConfigs: LayoutConfigs(
                width: cellState.width ?? widthPerUnconstrainedChild,
                height: cellState.height ?? heightPerUnconstrainedChild,
              ),
              extensionsEngine: widget.extensionsEngine,
              performanceConfigs: widget.performanceConfigs,
              workspaceConfigs: widget.workspaceConfigs,
              windowKey: widget.windowKey,
            ),
            // child: widget.workspaceConfigs.panesData[subcell.$2!],
          ),
        );
      }
    }
    return results;
  }
}

/**
 * 
 * 
 * child.$1 == null
        ? child.$2 == null
            ? const Text('Empty subcell')
            : SizedBox(
                width: cellState.width,
                height: cellState.height,
                child: EditorPane(
                  key: ValueKey(
                      '${child.$2}${widget.workspaceConfigs.panesData[child.$2]}'),
                  paneId: child.$2!,
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
                // child: widget.workspaceConfigs.panesData[subcell.$2!],
              )
        : PaneLayoutCellWidget(
            cell: child.$1!,
            workspaceConfigs: widget.workspaceConfigs,
            extensionsEngine: widget.extensionsEngine,
            performanceConfigs: widget.performanceConfigs,
            windowKey: widget.windowKey,
          )
 */
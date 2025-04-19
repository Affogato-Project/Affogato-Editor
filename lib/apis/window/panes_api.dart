part of affogato.apis;

class AffogatoPanesAPI extends AffogatoAPIComponent
    with utils.StreamSubscriptionManager {
  final Stream<WindowPaneCellLayoutChangedEvent> cellLayoutChangedStream =
      AffogatoEvents.windowPaneCellLayoutChangedEventsController.stream;
  final Stream<WindowPaneCellRequestReloadEvent> cellRequestReloadStream =
      AffogatoEvents.windowPaneCellRequestReloadEventsController.stream;
  final Stream<WindowPaneRequestReloadEvent> requestReloadStream =
      AffogatoEvents.windowPaneRequestReloadEventsController.stream;

  AffogatoPanesAPI();

  @override
  void init() {
    registerListener(
      cellLayoutChangedStream,
      (event) {
        // assume that all layout changes occur from the root,
        // and that we don't have to update the parent's constraints
        api.workspace.workspaceConfigs.panesLayout
          ..width = (api.workspace.workspaceConfigs.primaryBarMode !=
                      PrimaryBarMode.collapsed
                  ? api.workspace.workspaceConfigs.stylingConfigs.windowWidth -
                      (utils.AffogatoConstants.primaryBarExpandedWidth +
                          utils.AffogatoConstants.primaryBarClosedWidth)
                  : api.workspace.workspaceConfigs.stylingConfigs.windowWidth -
                      utils.AffogatoConstants.primaryBarClosedWidth) -
              3
          ..height =
              api.workspace.workspaceConfigs.stylingConfigs.windowHeight -
                  utils.AffogatoConstants.statusBarHeight;

        _recomputeChildConstraints(api.workspace.workspaceConfigs.panesLayout);

        AffogatoEvents.windowPaneCellRequestReloadEventsController
            .add(WindowPaneCellRequestReloadEvent(event.cellId));
      },
    );
  }

  /// Given the updated constraints of [target], recursively updates all children
  /// with the new constraints
  void _recomputeChildConstraints(PaneList target) {
    final double newChildHeight;
    final double newChildWidth;
    if (target is SinglePaneList) {
      return;
    } else if (target is VerticalPaneList) {
      newChildHeight =
          (target.height - (target.value.length - 1)) / target.value.length;
      newChildWidth = target.width;
    } else if (target is HorizontalPaneList) {
      newChildHeight = target.height;
      newChildWidth =
          (target.width - (target.value.length - 1)) / target.value.length;
    } else {
      throw Exception('impossible');
    }

    for (int i = 0; i < (target as MultiplePaneList).value.length; i++) {
      target.value[i]
        ..width = newChildWidth
        ..height = newChildHeight;
      _recomputeChildConstraints(target.value[i]);
    }
  }

  /// Traverse via BFS
  PaneList findCellById(String cellId) {
    if (api.workspace.workspaceConfigs.panesLayout.id == cellId) {
      return api.workspace.workspaceConfigs.panesLayout;
    }
    if (api.workspace.workspaceConfigs.panesLayout is MultiplePaneList) {
      final List<PaneList> queue =
          (api.workspace.workspaceConfigs.panesLayout as MultiplePaneList)
              .value
              .toList();

      do {
        for (final item in queue) {
          if (item.id == cellId) return item;
          queue.remove(item);
          if (item is MultiplePaneList) {
            queue.addAll(item.value);
          }
        }
      } while (queue.isNotEmpty);
    }
    throw Exception('$cellId not found');
  }

  List<PaneList> splitIntoTwoPanes({
    required String paneIdA,
    required String paneIdB,
    required double width,
    required double height,
    required Axis axis,
    String? cellIdA,
    String? cellIdB,
  }) {
    return <PaneList>[
      SinglePaneList(
        paneIdA,
        id: cellIdA,
        width: axis == Axis.horizontal ? (width - 1) / 2 : width,
        height: axis == Axis.horizontal ? height : (height - 1) / 2,
      ),
      SinglePaneList(
        paneIdB,
        id: cellIdB,
        width: axis == Axis.horizontal ? (width - 1) / 2 : width,
        height: axis == Axis.horizontal ? height : (height - 1) / 2,
      )
    ];
  }

/*   /// Removes the [SinglePaneList] that contains the given [paneId], and returns the
  /// paneId of the next pane to give focus to. Also emits and event to [AffogatoEvents.editorPaneLayoutChangedEvents]
  /// as a side effect.
  String removePaneById(String paneId) {
    // must have at least one pane
    if (panesLayout is SinglePaneList) {
      return (panesLayout as SinglePaneList).paneId;
    } else {
      final MultiplePaneList? parent =
          (panesLayout as MultiplePaneList).pathToPane(
        paneId,
        removeGivenPane: true,
      )?.lastOrNull;
      if (parent != null && parent.value.isNotEmpty) {
        for (final nextPane in parent.value) {
          if (nextPane)
        }
      } else {
        throw Exception("Could not find parent");
      }
    }
  } */

  void addPane({
    required Axis axis,
    required String anchorCellId,
    required String anchorPaneId,
    required String newPaneId,
    required bool insertPrev,
  }) {
    // handle the case where there is only one pane
    if (api.workspace.workspaceConfigs.panesLayout is SinglePaneList) {
      final anchorCell = findCellById(anchorCellId);
      final items = splitIntoTwoPanes(
        paneIdA: insertPrev ? newPaneId : anchorPaneId,
        paneIdB: insertPrev ? anchorPaneId : newPaneId,
        width: anchorCell.width,
        height: anchorCell.height,
        cellIdA: insertPrev
            ? null
            : utils
                .generateId(), // generate a new ID for the previous root (given by anchorCellId)
        cellIdB: insertPrev ? utils.generateId() : null,
        axis: axis,
      );
      // to replace the root, its ID must be provided to the newly inserted cell
      api.workspace.workspaceConfigs.panesLayout = axis == Axis.horizontal
          ? HorizontalPaneList(
              items,
              width: anchorCell.width,
              height: anchorCell.height,
              id: api.workspace.workspaceConfigs.panesLayout.id,
            )
          : VerticalPaneList(
              items,
              width: anchorCell.width,
              height: anchorCell.height,
              id: api.workspace.workspaceConfigs.panesLayout.id,
            );
      AffogatoEvents.windowPaneCellRequestReloadEventsController.add(
          WindowPaneCellRequestReloadEvent(
              api.workspace.workspaceConfigs.panesLayout.id));
    } else {
      // find the path to the anchor pane
      final path =
          (api.workspace.workspaceConfigs.panesLayout as MultiplePaneList)
              .pathToPane(anchorPaneId);
      // determine the parent of the anchor
      MultiplePaneList parentOfAnchor =
          path?.last ?? (throw Exception('Parent of anchor not found'));

      // determine the index of the anchor cell
      final int index = parentOfAnchor.value.indexWhere(
          (pane) => pane is SinglePaneList && pane.paneId == anchorPaneId);
      final PaneList anchorCell = parentOfAnchor.value[index];
      // resolve any axis conflicts
      final Axis childAxis =
          parentOfAnchor is VerticalPaneList ? Axis.vertical : Axis.horizontal;
      final bool axisIsConflicting = axis != childAxis;
      if (axisIsConflicting) {
        // create a new pane along the insertion axis, `axis`
        final items = splitIntoTwoPanes(
          paneIdA: insertPrev ? newPaneId : anchorPaneId,
          paneIdB: insertPrev ? anchorPaneId : newPaneId,
          width: anchorCell.width,
          height: anchorCell.height,
          axis: axis,
        );
        // update the parent to resolve the axis conflict
        parentOfAnchor.value[index] = axis == Axis.horizontal
            ? HorizontalPaneList(
                items,
                width: anchorCell.width,
                height: anchorCell.height,
                id: parentOfAnchor.value[index].id,
              )
            : VerticalPaneList(
                items,
                width: anchorCell.width,
                height: anchorCell.height,
                id: parentOfAnchor.value[index].id,
              );
      } else {
        final double newWidth = axis == Axis.horizontal
            ? parentOfAnchor.width / (parentOfAnchor.value.length + 1)
            : anchorCell.width;
        final double newHeight = axis == Axis.horizontal
            ? anchorCell.height
            : parentOfAnchor.height / (parentOfAnchor.value.length + 1);

        parentOfAnchor.value.insert(
          insertPrev ? index : index + 1,
          SinglePaneList(
            newPaneId,
            width: newWidth,
            height: newHeight,
          ),
        );
        for (int i = 0; i < parentOfAnchor.value.length; i++) {
          if (i != index) {
            axis == Axis.horizontal
                ? parentOfAnchor.value[i].width = newWidth
                : parentOfAnchor.value[i].height = newHeight;
          }
        }
      }
      AffogatoEvents.windowPaneCellRequestReloadEventsController
          .add(WindowPaneCellRequestReloadEvent(parentOfAnchor.id));
    }
  }

  void addPaneLeft({
    required String anchorCellId,
    required String anchorPaneId,
    required String newPaneId,
  }) =>
      addPane(
        axis: Axis.horizontal,
        anchorCellId: anchorCellId,
        anchorPaneId: anchorPaneId,
        newPaneId: newPaneId,
        insertPrev: true,
      );

  void addPaneRight({
    required String anchorCellId,
    required String anchorPaneId,
    required String newPaneId,
  }) =>
      addPane(
        axis: Axis.horizontal,
        anchorCellId: anchorCellId,
        anchorPaneId: anchorPaneId,
        newPaneId: newPaneId,
        insertPrev: false,
      );

  void addPaneBottom({
    required String anchorCellId,
    required String anchorPaneId,
    required String newPaneId,
  }) =>
      addPane(
        axis: Axis.vertical,
        anchorCellId: anchorCellId,
        anchorPaneId: anchorPaneId,
        newPaneId: newPaneId,
        insertPrev: false,
      );

  void addPaneTop({
    required String anchorCellId,
    required String anchorPaneId,
    required String newPaneId,
  }) =>
      addPane(
        axis: Axis.vertical,
        anchorCellId: anchorCellId,
        anchorPaneId: anchorPaneId,
        newPaneId: newPaneId,
        insertPrev: true,
      );

  /// This method is called when it is known for sure that removing a given pane
  /// will result in no more panes being left (which is an erroneous state) and therefore
  /// a default, empty pane given by [paneId] is requested to be added.
  void addDefaultPane(String paneId) {
    api.workspace.workspaceConfigs.panesLayout = SinglePaneList(
      paneId,
      width: (api.workspace.workspaceConfigs.primaryBarMode !=
                  PrimaryBarMode.collapsed
              ? api.workspace.workspaceConfigs.stylingConfigs.windowWidth -
                  (utils.AffogatoConstants.primaryBarExpandedWidth +
                      utils.AffogatoConstants.primaryBarClosedWidth)
              : api.workspace.workspaceConfigs.stylingConfigs.windowWidth -
                  utils.AffogatoConstants.primaryBarClosedWidth) -
          3,
      height: api.workspace.workspaceConfigs.stylingConfigs.windowHeight -
          utils.AffogatoConstants.statusBarHeight,
    );
  }

  void removePane() {}

  void resizePane(
    String paneId, {
    required MultiplePaneList parent,
    double? deltaLeft,
    double? deltaRight,
    double? deltaTop,
    double? deltaBottom,
  }) {
    for (int i = 0; i < parent.value.length; i++) {
      if (parent.value[i].id == paneId) {
        if (parent is VerticalPaneList) {
          if (deltaTop != null) {
            parent.value[i].height += deltaTop;
            parent.value[i - 1].height -= deltaTop;
          } else if (deltaBottom != null) {
            parent.value[i].height += deltaBottom;
            parent.value[i + 1].height -= deltaBottom;
          }
        } else if (parent is HorizontalPaneList) {
          if (deltaLeft != null) {
            parent.value[i].width += deltaLeft;
            parent.value[i - 1].width -= deltaLeft;
          } else if (deltaRight != null) {
            parent.value[i].width += deltaRight;
            parent.value[i + 1].width -= deltaRight;
          }
        }
      }
    }
  }
}

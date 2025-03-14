part of affogato.editor;

class PaneManager {
  PaneList panesLayout;

  PaneManager.fromData({
    required this.panesLayout,
  });

  PaneManager.empty({
    required SinglePaneList rootPane,
  }) : panesLayout = rootPane;

  /// Traverse via BFS
  PaneList findCellById(String cellId) {
    if (panesLayout.id == cellId) return panesLayout;
    if (panesLayout is MultiplePaneList) {
      final List<PaneList> queue =
          (panesLayout as MultiplePaneList).value.toList();

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
        width: axis == Axis.horizontal ? width / 2 : width,
        height: axis == Axis.horizontal ? height : height / 2,
      ),
      SinglePaneList(
        paneIdB,
        id: cellIdB,
        width: axis == Axis.horizontal ? width / 2 : width,
        height: axis == Axis.horizontal ? height : height / 2,
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
    if (panesLayout is SinglePaneList) {
      final anchorCell = findCellById(anchorCellId);
      final items = splitIntoTwoPanes(
        paneIdA: insertPrev ? newPaneId : anchorPaneId,
        paneIdB: insertPrev ? anchorPaneId : newPaneId,
        width: anchorCell.width,
        height: anchorCell.height,
        cellIdA: insertPrev ? null : anchorCellId,
        cellIdB: insertPrev ? anchorCellId : null,
        axis: axis,
      );

      panesLayout = axis == Axis.horizontal
          ? HorizontalPaneList(
              items,
              width: anchorCell.width,
              height: anchorCell.height,
            )
          : VerticalPaneList(
              items,
              width: anchorCell.width,
              height: anchorCell.height,
            );
      AffogatoEvents.windowPaneLayoutChangedEventsController
          .add(WindowPaneLayoutChangedEvent(panesLayout.id));
    } else {
      final path = (panesLayout as MultiplePaneList).pathToPane(anchorPaneId);
      MultiplePaneList parentOfAnchor =
          path?.last ?? (throw Exception('Parent of anchor not found'));
      final int index = parentOfAnchor.value.indexWhere(
          (pane) => pane is SinglePaneList && pane.paneId == anchorPaneId);
      final PaneList anchorCell = parentOfAnchor.value[index];
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
              )
            : VerticalPaneList(
                items,
                width: anchorCell.width,
                height: anchorCell.height,
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
      AffogatoEvents.windowPaneLayoutChangedEventsController
          .add(WindowPaneLayoutChangedEvent(parentOfAnchor.id));
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
}

sealed class PaneList {
  final String id;
  double width;
  double height;

  PaneList({
    required this.width,
    required this.height,
    String? id,
  }) : id = id ?? utils.generateId();
}

class SinglePaneList extends PaneList {
  final String paneId;

  SinglePaneList(
    this.paneId, {
    required super.width,
    required super.height,
    super.id,
  });
}

sealed class MultiplePaneList extends PaneList {
  List<PaneList> value;

  MultiplePaneList(
    this.value, {
    required super.width,
    required super.height,
    super.id,
  });

  /// Uses DFS to search for the ancestor tree of a given pane ID. Set [removeGivenPane]
  /// if the [SinglePaneList] containing the [paneId] should be deleted. This is used by
  /// the [removePaneById] method.
  List<MultiplePaneList>? pathToPane(
    String paneId, {
    bool removeGivenPane = false,
  }) {
    for (final val in value) {
      if (val is SinglePaneList) {
        if (val.paneId == paneId) {
          value.remove(val);
          return [this];
        }
      } else {
        final tmp = (val as MultiplePaneList)
            .pathToPane(paneId, removeGivenPane: removeGivenPane);
        if (tmp != null) return [this, ...tmp];
      }
    }
    return null;
  }
}

class VerticalPaneList extends MultiplePaneList {
  VerticalPaneList(
    super.value, {
    required super.width,
    required super.height,
    super.id,
  });
}

class HorizontalPaneList extends MultiplePaneList {
  HorizontalPaneList(
    super.value, {
    required super.width,
    required super.height,
    super.id,
  });
}

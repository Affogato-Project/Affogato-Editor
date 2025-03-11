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

  void addPaneLeft({
    required String anchorCellId,
    required String anchorPaneId,
    required String newPaneId,
  }) {
    // handle the case where there is only one pane
    if (panesLayout is SinglePaneList) {
      final anchorCell = findCellById(anchorCellId);
      panesLayout = HorizontalPaneList(
        [
          SinglePaneList(
            newPaneId,
            width: anchorCell.width / 2,
            height: anchorCell.height,
          ),
          SinglePaneList(
            anchorPaneId,
            id: anchorCellId,
            width: anchorCell.width / 2,
            height: anchorCell.height,
          )
        ],
        width: anchorCell.width,
        height: anchorCell.height,
      );
      AffogatoEvents.editorPaneLayoutChangedEvents
          .add(EditorPaneLayoutChangedEvent(panesLayout.id));
    } else {
      MultiplePaneList parentOfAnchor =
          (panesLayout as MultiplePaneList).pathToPane(anchorPaneId)?.last ??
              (throw Exception('Parent of anchor not found'));
      final int index = parentOfAnchor.value.indexWhere(
          (pane) => pane is SinglePaneList && pane.paneId == anchorPaneId);
      final PaneList anchorCell = parentOfAnchor.value[index];

      if (parentOfAnchor is VerticalPaneList) {
        parentOfAnchor.value[index] = HorizontalPaneList(
          [
            SinglePaneList(
              newPaneId,
              width: anchorCell.width / 2,
              height: anchorCell.height,
            ),
            SinglePaneList(
              anchorPaneId,
              width: anchorCell.width / 2,
              height: anchorCell.height,
            )
          ],
          width: anchorCell.width,
          height: anchorCell.height,
        );
      } else if (parentOfAnchor is HorizontalPaneList) {
        final double newWidth =
            parentOfAnchor.width / (parentOfAnchor.value.length + 1);
        for (int i = 0; i < parentOfAnchor.value.length; i++) {
          if (i == index) {
            parentOfAnchor.value.insert(
              index,
              SinglePaneList(
                newPaneId,
                width: newWidth,
                height: anchorCell.height,
              ),
            );
          } else {
            parentOfAnchor.value[i].width = newWidth;
          }
        }
      }

      AffogatoEvents.editorPaneLayoutChangedEvents
          .add(EditorPaneLayoutChangedEvent(parentOfAnchor.id));
    }
  }

  void addPaneRight({
    required String anchorPaneId,
    required String newPaneId,
  }) {}
  void addPaneBottom({
    required String anchorPaneId,
    required String newPaneId,
  }) {}
  void addPaneTop({
    required String anchorPaneId,
    required String newPaneId,
  }) {}
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

final class SinglePaneList extends PaneList {
  final String paneId;

  SinglePaneList(
    this.paneId, {
    required super.width,
    required super.height,
    super.id,
  });
}

sealed class MultiplePaneList extends PaneList {
  final List<PaneList> value;

  MultiplePaneList(
    this.value, {
    required super.width,
    required super.height,
    super.id,
  });

  /// Uses DFS to search for the ancestor tree of a given pane ID
  List<MultiplePaneList>? pathToPane(String paneId) {
    for (final val in value) {
      if (val is SinglePaneList) {
        if (val.paneId == paneId) return [this];
      } else {
        final tmp = (val as MultiplePaneList).pathToPane(paneId);
        if (tmp != null) return [this, ...tmp];
      }
    }
    return null;
  }
}

final class VerticalPaneList extends MultiplePaneList {
  VerticalPaneList(
    super.value, {
    required super.width,
    required super.height,
    super.id,
  });
}

final class HorizontalPaneList extends MultiplePaneList {
  HorizontalPaneList(
    super.value, {
    required super.width,
    required super.height,
    super.id,
  });
}

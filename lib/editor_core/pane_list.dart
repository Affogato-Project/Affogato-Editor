part of affogato.editor;

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

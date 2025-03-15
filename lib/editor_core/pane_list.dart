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

  String toTree(int indent);
}

class SinglePaneList extends PaneList {
  final String paneId;

  SinglePaneList(
    this.paneId, {
    required super.width,
    required super.height,
    super.id,
  });

  @override
  String toTree(int indent) => "${' ' * indent}|-SINGLE($id) -> $paneId";
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
          if (removeGivenPane) value.remove(val);
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

  @override
  String toTree(int indent) => [
        "${' ' * indent}|-VERT($id) [${value.length}]",
        ...[for (final val in value) val.toTree(indent + 2)]
      ].join('\n');
}

class HorizontalPaneList extends MultiplePaneList {
  HorizontalPaneList(
    super.value, {
    required super.width,
    required super.height,
    super.id,
  });

  @override
  String toTree(int indent) => [
        "${' ' * indent}|-HORZ($id) [${value.length}]",
        ...[for (final val in value) val.toTree(indent + 2)]
      ].join('\n');
}

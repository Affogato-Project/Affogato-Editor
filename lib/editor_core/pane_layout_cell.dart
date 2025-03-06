part of affogato.editor;

/// A [PaneLayoutCell] contains one or more [PaneInstance]s and manages their layout, sizing, and positioning data.
/// A null value for either [width] or [height] indicates that sizing in that dimension is left to
/// the [PaneLayoutCellWidget], to be computed based on the available children and their constraints.
/// Either [verticalChildren] or [horizontalChildren] should be provided, and it is an error to provide both or neither.
class PaneLayoutCell {
  /// A sequence consisting of either [PaneLayoutCell]s or the ID of a pane.
  final List<utils.Either<PaneLayoutCell, String>> verticalChildren;
  final List<utils.Either<PaneLayoutCell, String>> horizontalChildren;
  double? width;
  double? height;

  PaneLayoutCell.vertical({
    required this.verticalChildren,
    required this.width,
    required this.height,
  }) : horizontalChildren = const [];

  PaneLayoutCell.horizontal({
    required this.horizontalChildren,
    required this.width,
    required this.height,
  }) : verticalChildren = const [];

  @override
  int get hashCode =>
      "${verticalChildren.hashCode}-${horizontalChildren.hashCode}-$width-$height"
          .hashCode;

  @override
  bool operator ==(Object other) =>
      other is PaneLayoutCell &&
      other.width == width &&
      height == other.height &&
      listEquals(other.verticalChildren, verticalChildren) &&
      listEquals(other.horizontalChildren, horizontalChildren);
}

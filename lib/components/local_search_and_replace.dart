part of affogato.editor;

/// This controller provides a method to control the animations and required
/// show/dismiss operations to interact with the [SearchAndReplaceWidget] in an intra-file
/// context (hence the `Local` prefix).
///
/// In order to correctly implement the mechanism for the search-and-replace overlay, instantiate this
/// class in the [State] object of the parent widget. Pass the [overlayKey] generated by this class to the
/// [Widget.key] property of the [SearchAndReplaceWidget]. Then, call the
class LocalSearchAndReplaceController {
  final LocalSearchAndReplaceData localSearchAndReplaceData =
      LocalSearchAndReplaceData();
  final GlobalKey<SearchAndReplaceWidgetState> overlayKey = GlobalKey();
  late final AnimationController searchAndReplaceAnimationController;
  late final Animation<Offset> searchAndReplaceOffsetAnimation = Tween<Offset>(
    begin: const Offset(0, -1.25),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: searchAndReplaceAnimationController,
      curve: Curves.linear,
    ),
  );
  final List<Positioned> searchAndReplaceMatchHighlights = [];
  Iterable<Match> matches = Iterable.empty();
  int searchItemCurrentIndex = 0;
  String searchText = '';
  String? replaceText;
  final VoidCallback? onDismiss;
  final double cellWidth;
  final double cellHeight;
  final TextEditingController textController;
  double currentItemOffset = 0;

  LocalSearchAndReplaceController({
    required TickerProvider tickerProvider,
    required this.cellWidth,
    required this.cellHeight,
    required this.textController,
    this.onDismiss,
  }) : searchAndReplaceAnimationController = AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: tickerProvider,
        );

  void show() {
    searchAndReplaceAnimationController.forward();
    overlayKey.currentState!.searchFieldFocusNode.requestFocus();
    regenerateMatches(
      newText: textController.selection.isCollapsed
          ? searchText
          : textController.selection.textInside(textController.text),
    );
  }

  void dismiss() {
    searchAndReplaceAnimationController.reverse();
    searchAndReplaceMatchHighlights.clear();
    onDismiss?.call();
  }

  void toggle() {
    if (!(overlayKey.currentState?.mounted ?? false)) return;
    if (isShown) {
      show();
    } else {
      dismiss();
    }
  }

  void nextMatch() {
    if (searchItemCurrentIndex + 1 >= matches.length) {
      searchItemCurrentIndex = 0;
    } else {
      searchItemCurrentIndex += 1;
    }
    searchAndReplaceMatchHighlights
      ..clear()
      ..addAll(
        generateSearchAndReplaceHighlights(
          matches: matches,
          wordWidth: searchText.length,
        ),
      );
  }

  void prevMatch() {
    if (searchItemCurrentIndex - 1 < 0) {
      searchItemCurrentIndex = matches.length - 1;
    } else {
      searchItemCurrentIndex -= 1;
    }
    searchAndReplaceMatchHighlights
      ..clear()
      ..addAll(
        generateSearchAndReplaceHighlights(
          matches: matches,
          wordWidth: searchText.length,
        ),
      );
  }

  void regenerateMatches({
    required String newText,
  }) {
    searchText = newText;
    if (searchText != '') {
      matches = searchText.allMatches(textController.text);
      searchAndReplaceMatchHighlights
        ..clear()
        ..addAll(
          generateSearchAndReplaceHighlights(
            matches: matches,
            wordWidth: searchText.length,
          ),
        );
    }
  }

  List<Positioned> generateSearchAndReplaceHighlights({
    required Iterable<Match> matches,
    required int wordWidth,
  }) {
    final List<Positioned> widgets = [];
    for (int i = 0; i < matches.length; i++) {
      final Match match = matches.elementAt(i);
      final double offset =
          (textController.text.substring(0, match.start).split('\n').length -
                  1) *
              cellHeight;
      widgets.add(
        Positioned(
          key: ValueKey('$searchText-$searchItemCurrentIndex-$i'),
          top: offset,
          left: utils.AffogatoConstants.lineNumbersColWidth +
              utils.AffogatoConstants.lineNumbersGutterWidth +
              charNumAtIndex(match.start, controllerText: textController.text) *
                  cellWidth -
              2,
          width: wordWidth * cellWidth + 2,
          child: Container(
            height: cellHeight,
            width: wordWidth * cellWidth,
            color: Colors.orange
                .withOpacity(i == searchItemCurrentIndex ? 0.3 : 0.2),
          ),
        ),
      );
      if (i == searchItemCurrentIndex) currentItemOffset = offset;
    }
    return widgets;
  }

  int charNumAtIndex(int index, {required String controllerText}) {
    int charNum = 0;
    for (int i = 0; i < controllerText.length; i++) {
      if (i == index) return charNum;
      if (controllerText[i] == '\n') {
        charNum = 0;
      } else {
        charNum += 1;
      }
    }
    return charNum;
  }

  bool get isShown => searchAndReplaceAnimationController.value == 0;

  void scrollIfActiveMatchOutsideViewport({
    required double scrollOffset,
    required double viewportHeight,
    required void Function(double) scrollCallback,
  }) {
    if (currentItemOffset > scrollOffset + viewportHeight - 10) {
      scrollCallback(currentItemOffset + 40);
    } else if (currentItemOffset < scrollOffset - viewportHeight + 10) {
      scrollCallback(currentItemOffset - 40);
    }
  }
}

/// This object stores the state/data for the [SearchAndReplaceWidget] in an intra-file
/// context.
class LocalSearchAndReplaceData {
  final List<Positioned> searchAndReplaceMatchHighlights = [];
  int searchItemCurrentIndex = 0;
  Iterable<Match> matches = Iterable.empty();
}

part of affogato.editor;

class AffogatoCompletionsWidget extends StatelessWidget {
  final EditorTheme editorTheme;
  final List<String> completions;
  final int currentSelection;
  final void Function(int) onSelectionIndexChange;
  final void Function() onSelectionAccept;

  const AffogatoCompletionsWidget({
    required this.completions,
    required this.editorTheme,
    required this.currentSelection,
    required this.onSelectionIndexChange,
    required this.onSelectionAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> completionItems = [];
    for (int i = 0; i < completions.length; i++) {
      completionItems.add(
        MouseRegion(
          onEnter: (_) => onSelectionIndexChange(i),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => onSelectionAccept(),
            child: Container(
              width: utils.AffogatoConstants.completionsMenuWidth,
              height: utils.AffogatoConstants.completionsMenuItemHeight,
              color: i == currentSelection
                  ? editorTheme.menuSelectionBackground
                  : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  completions[i],
                  style: editorTheme.defaultTextStyle.copyWith(
                    color: editorTheme.menuForeground,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: utils.AffogatoConstants.completionsMenuWidth,
      decoration: BoxDecoration(
        color: editorTheme.menuBackground,
        border: Border.all(color: editorTheme.menuSeparatorAndBorderBackground),
      ),
      child: Column(
        children: completionItems,
      ),
    );
  }
}

class CompletionsController {
  final List<String> dictionary;
  List<String>? currentCompletions;

  CompletionsController({
    required this.dictionary,
  });

  /// If a valid word (present in the dictionary) is being typed, a [List<String>]
  /// with the valid completions is returned, and null otherwise. This method should
  /// only be called if a [LSPClient] is not in use.
  List<String>? registerTokenInsert({
    required String content,
    required TextSelection selection,
  }) {
    if (selection.isCollapsed) {
      if (utils.charIsAlphaNum(content[selection.baseOffset])) {
        final word =
            _parseWordBeforeToken(content: content, pos: selection.baseOffset);
        // update the completions widget
        final Iterable<String> suggestions =
            dictionary.where((vocabEntry) => vocabEntry.startsWith(word));
        return currentCompletions =
            suggestions.isEmpty ? null : suggestions.toList();
      } else {
        final word = _parseWordBeforeToken(
            content: content, pos: selection.baseOffset - 1);
        // update the dictionary
        if (!dictionary.contains(word)) dictionary.add(word);
        dictionary.sort();
      }
    }

    return currentCompletions = null;
  }

  String _parseWordBeforeToken({
    required String content,
    required int pos,
    void Function(String)? forEachChar,
  }) {
    final List<String> chars = [];
    for (pos; pos >= 0; pos--) {
      if (!utils.charIsAlphaNum(content[pos])) {
        break;
      } else {
        chars.add(content[pos]);
        forEachChar?.call(content[pos]);
      }
    }
    return chars.reversed.join();
  }

  List<String> parseAllWordsInDocument({required String content}) {
    final List<String> words = [];
    final List<String> chars = [];
    for (int pos = 0; pos < content.length; pos++) {
      if (!utils.charIsAlphaNum(content[pos])) {
        if (chars.isNotEmpty) {
          words.add(chars.join());
          chars.clear();
        }
      } else {
        chars.add(content[pos]);
      }
    }
    return words;
  }
}

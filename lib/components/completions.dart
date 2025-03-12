part of affogato.editor;

class AffogatoCompletionsWidget extends StatelessWidget {
  final EditorTheme editorTheme;
  final CompletionsController controller;

  AffogatoCompletionsWidget({
    required this.editorTheme,
    required this.controller,
  }) : super(
          key: ValueKey(
              "${controller.currentCompletions?.map((e) => e.hashCode).join('-').hashCode}-${controller.completionItem}"
                  .hashCode),
        );

  @override
  Widget build(BuildContext context) {
    final List<Widget> completionItems = [];
    for (int i = 0; i < controller.currentCompletions!.length; i++) {
      completionItems.add(
        MouseRegion(
          onEnter: (_) => controller.updateCompletionIndex(i),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => controller.onAcceptAndDismiss(controller
                .currentCompletions![controller.completionItem]
                .substring(controller.currentWord.length)),
            child: Container(
              width: utils.AffogatoConstants.completionsMenuWidth,
              height: utils.AffogatoConstants.completionsMenuItemHeight,
              color: i == controller.completionItem
                  ? editorTheme.menuSelectionBackground.withOpacity(0.3)
                  : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: controller.currentWord,
                        style: editorTheme.defaultTextStyle.copyWith(
                          color: editorTheme.menuSelectionBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: controller.currentCompletions![i]
                            .substring(controller.currentWord.length),
                        style: editorTheme.defaultTextStyle.copyWith(
                          color: editorTheme.menuForeground,
                        ),
                      ),
                    ],
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
  int completionItem = 0;
  bool showingCompletions = false;
  final void Function(VoidCallback) refresh;
  final void Function(String) onAcceptAndDismiss;
  String currentWord = '';

  CompletionsController({
    required this.dictionary,
    required this.refresh,
    required this.onAcceptAndDismiss,
  });

  /// If a valid word (present in the dictionary) is being typed, a [List<String>]
  /// with the valid completions is returned, and null otherwise. This method should
  /// only be called if a [LSPClient] is not in use.
  List<String>? registerTextChanged({
    required String content,
    required TextSelection selection,
    required KeyEvent keyEvent,
  }) {
    if (selection.isCollapsed) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.backspace) {
        final res = _updateCompletions(
          content: content,
          selection: TextSelection.collapsed(offset: selection.baseOffset - 2),
        );

        return res;
      } else {
        final String char = HardwareKeyboard.instance.isShiftPressed
            ? keyEvent.logicalKey.keyLabel
            : keyEvent.logicalKey.keyLabel.toLowerCase();
        content = "$content$char";
        if (utils.charIsAlphaNum(char) || (const [' ', '\n']).contains(char)) {
          if (utils.charIsAlphaNum(content[selection.baseOffset])) {
            return _updateCompletions(
              content: content,
              selection: selection,
            );
          } else {
            final word = _parseWordBeforeToken(
                content: content, pos: selection.baseOffset - 1);
            // update the dictionary
            if (!dictionary.contains(word)) dictionary.add(word);
            dictionary.sort();
          }
        }
      }
    }
    showingCompletions = false;
    return currentCompletions = null;
  }

  void updateCompletionIndex(int newIndex) {
    completionItem = newIndex;
    refresh(() {});
  }

  List<String>? _updateCompletions({
    required String content,
    required TextSelection selection,
  }) {
    currentWord =
        _parseWordBeforeToken(content: content, pos: selection.baseOffset);
    if (currentWord == '') {
      showingCompletions = false;
      return currentCompletions = null;
    }
    final Iterable<String> suggestions =
        dictionary.where((vocabEntry) => vocabEntry.startsWith(currentWord));
    currentCompletions = suggestions.isEmpty ? null : suggestions.toList();
    if (currentCompletions != null) {
      showingCompletions = true;
      return currentCompletions;
    } else {
      showingCompletions = false;
      return currentCompletions = null;
    }
  }

  KeyEventResult handleKeyEvent(KeyEvent key) {
    if (showingCompletions && key is KeyDownEvent) {
      if (key.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (completionItem != 0) {
          completionItem -= 1;
        } else {
          completionItem = currentCompletions!.length - 1;
        }
        return KeyEventResult.handled;
      } else if (key.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (completionItem != currentCompletions!.length - 1) {
          completionItem += 1;
        } else {
          completionItem = 0;
        }
        return KeyEventResult.handled;
      } else if (key.logicalKey == LogicalKeyboardKey.escape) {
        showingCompletions = false;
        return KeyEventResult.handled;
      } else if (key.logicalKey == LogicalKeyboardKey.enter) {
        onAcceptAndDismiss(
            currentCompletions![completionItem].substring(currentWord.length));
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    } else {
      return KeyEventResult.ignored;
    }
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

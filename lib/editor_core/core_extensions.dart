part of affogato.editor;

class PairMatcherExtension extends AffogatoExtension {
  static const triggerChars = {
    '(': ')',
    '[': ']',
    '{': '}',
    '"': '"',
    "'": "'",
    '`': '`',
  };
  PairMatcherExtension()
      : super(
          name: 'affogato_pair_matcher',
          displayName: 'Pair Matcher',
          bindTriggers: const [AffogatoBindTriggers.onStartupFinished()],
        );

  @override
  void loadExtension({
    required AffogatoFileManager fileManager,
  }) {
    // Need to
    /**
     * TODO:
     *  1. prohibit access to the underlying [StreamController] in future versions
     *  2. handle bracket wrapping by keeping track of previous [TextSelection] in EditingContext
     *  3. use Editor API to make document change requests, not through the StreamController
     */
    AffogatoEvents.editorKeyEvent.stream.listen((event) {
      if (event.keyEvent is KeyDownEvent || event.keyEvent is KeyRepeatEvent) {
        if (triggerChars.containsKey(event.keyEvent.character)) {
          final String newText = event.editingContext.selection
                  .textBefore(event.editingContext.content) +
              triggerChars[event.keyEvent.character]! +
              event.editingContext.selection
                  .textAfter(event.editingContext.content);
          AffogatoEvents.editorDocumentRequestChangeEvents.add(
            EditorDocumentRequestChangeEvent(
              editorAction: EditorAction(
                newContent: newText,
                newSelection: event.editingContext.selection,
              ),
            ),
          );
        } else if (event.keyEvent.logicalKey == LogicalKeyboardKey.backspace &&
            event.editingContext.selection.start <
                event.editingContext.content.length) {
          final String char = event
              .editingContext.content[event.editingContext.selection.start];
          if (triggerChars.containsValue(char)) {
            final String newText = event.editingContext.selection
                    .textBefore(event.editingContext.content) +
                event.editingContext.selection
                    .textAfter(event.editingContext.content)
                    .substring(1);
            AffogatoEvents.editorDocumentRequestChangeEvents.add(
              EditorDocumentRequestChangeEvent(
                editorAction: EditorAction(
                  newContent: newText,
                  newSelection: event.editingContext.selection,
                ),
              ),
            );
          }
        }
      }
    });
  }
}

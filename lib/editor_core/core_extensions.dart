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
          bindTriggers: const ['startupFinished'],
        );

  @override
  void loadExtension(AffogatoAPI api) {
    // Need to
    /**
     * TODO:
     *  2. handle bracket wrapping by keeping track of previous [TextSelection] in EditingContext
     */
    api.editor.keyEventsStream.listen((event) {
      if (event.keyEvent is KeyDownEvent || event.keyEvent is KeyRepeatEvent) {
        if (triggerChars.containsKey(event.keyEvent.character)) {
          final String newText = event.editingContext.selection
                  .textBefore(event.editingContext.content) +
              triggerChars[event.keyEvent.character]! +
              event.editingContext.selection
                  .textAfter(event.editingContext.content);
          api.vfs.documentRequestChange(
            VFSDocumentRequestChangeEvent(
              entityId: api.workspace.workspaceConfigs.entitiesLocation.entries
                  .firstWhere((entry) =>
                      entry.value.$1 ==
                      api.workspace.workspaceConfigs.activeInstance!)
                  .key,
              editorAction: EditorAction(
                editingValue: TextEditingValue(
                  text: newText,
                  selection: event.editingContext.selection,
                ),
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
            api.vfs.documentRequestChange(
              VFSDocumentRequestChangeEvent(
                entityId: api
                    .workspace.workspaceConfigs.entitiesLocation.entries
                    .firstWhere((entry) =>
                        entry.value.$1 ==
                        api.workspace.workspaceConfigs.activeInstance!)
                    .key,
                editorAction: EditorAction(
                  editingValue: TextEditingValue(
                    text: newText,
                    selection: event.editingContext.selection,
                  ),
                ),
              ),
            );
          }
        }
      }
    });
  }
}

final class AutoIndenterExtension extends AffogatoEditorKeybindingExtension {
  late AffogatoAPI api;
  static const triggerChars = {
    '(': ')',
    '[': ']',
    '{': '}',
  };
  AutoIndenterExtension()
      : super(
          keys: [LogicalKeyboardKey.enter],
          name: 'affogato_auto_indenter',
          displayName: 'Auto Indenter',
          bindTriggers: const ['startupFinished'],
        );

  @override
  KeyEventResult handle({
    required EditorKeyEvent editorKeyEvent,
    required AffogatoVFS vfs,
    required AffogatoWorkspaceConfigs workspaceConfigs,
  }) {
    if (!editorKeyEvent.editingContext.selection.isCollapsed ||
        editorKeyEvent.editingContext.selection.start - 1 < 0) {
      return KeyEventResult.ignored;
    }
    if (editorKeyEvent.keyEvent is KeyDownEvent) {
      final String prevChar = editorKeyEvent.editingContext
          .content[editorKeyEvent.editingContext.selection.start - 1];
      if (triggerChars.containsKey(prevChar)) {
        final String precedentText = editorKeyEvent.editingContext.selection
            .textBefore(editorKeyEvent.editingContext.content);
        final int numSpaces =
            numSpacesBeforeFirstChar(precedentText.split('\n').last);

        final int tabSizeInSpaces =
            workspaceConfigs.stylingConfigs.tabSizeInSpaces;

        final String insertText =
            "\n${' ' * (numSpaces + tabSizeInSpaces)}\n${' ' * numSpaces}";

        final String succeedingText = editorKeyEvent.editingContext.selection
            .textAfter(editorKeyEvent.editingContext.content);

        final String newText = precedentText + insertText + succeedingText;

        api.vfs.documentRequestChange(
          VFSDocumentRequestChangeEvent(
            entityId: api.workspace.workspaceConfigs.entitiesLocation.entries
                .firstWhere((entry) =>
                    entry.value.$1 ==
                    api.workspace.workspaceConfigs.activeInstance!)
                .key,
            editorAction: EditorAction(
              editingValue: TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset: precedentText.length +
                      1 +
                      numSpaces +
                      workspaceConfigs.stylingConfigs.tabSizeInSpaces,
                ),
              ),
            ),
          ),
        );
        return KeyEventResult.handled;
      }
    } else if (editorKeyEvent.keyEvent is KeyRepeatEvent) {}
    return KeyEventResult.ignored;
  }

  @override
  void loadExtension(AffogatoAPI api) {
    this.api = api;
    api.editor.keyEventsStream
        .where((event) => event.keyEvent.logicalKey == LogicalKeyboardKey.enter)
        .listen((event) {});
  }

  int numSpacesBeforeFirstChar(String line) =>
      line.length - line.trimLeft().length;
}

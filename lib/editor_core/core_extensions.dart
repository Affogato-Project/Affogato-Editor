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
                  .firstWhere((entry) => entry.value.$1 == event.instanceId)
                  .key,
              editorAction: EditorAction(
                editingValue: TextEditingValue(
                  text: newText,
                  selection: event.editingContext.selection,
                ),
              ),
              originId: name,
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
                originId: name,
                entityId: api
                    .workspace.workspaceConfigs.entitiesLocation.entries
                    .firstWhere((entry) => entry.value.$1 == event.instanceId)
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

enum _IndentType {
  none,
  add,
  maintain,
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
    required AffogatoAPI api,
    required EditorKeyEvent editorKeyEvent,
  }) {
    if (!editorKeyEvent.editingContext.selection.isCollapsed ||
        editorKeyEvent.editingContext.selection.start - 1 < 0) {
      return KeyEventResult.ignored;
    }
    if (editorKeyEvent.keyEvent is KeyDownEvent) {
      final String prevChar = editorKeyEvent.editingContext
          .content[editorKeyEvent.editingContext.selection.start - 1];
      final _IndentType indentType = triggerChars.containsKey(prevChar)
          ? _IndentType.add
          : editorKeyEvent.keyEvent.logicalKey == LogicalKeyboardKey.enter
              ? _IndentType.maintain
              : _IndentType.none;
      if (indentType == _IndentType.add || indentType == _IndentType.maintain) {
        final String precedentText = editorKeyEvent.editingContext.selection
            .textBefore(editorKeyEvent.editingContext.content);

        final int numSpaces =
            numSpacesBeforeFirstChar(precedentText.split('\n').last);
        if (numSpaces == 0 && indentType == _IndentType.maintain) {
          return KeyEventResult.ignored;
        }
        final int tabSizeInSpaces =
            api.workspace.workspaceConfigs.stylingConfigs.tabSizeInSpaces;

        final String insertText =
            "\n${' ' * (indentType == _IndentType.add ? (numSpaces + tabSizeInSpaces) : 0)}${indentType == _IndentType.add ? '\n' : ''}${' ' * numSpaces}";

        final String succeedingText = editorKeyEvent.editingContext.selection
            .textAfter(editorKeyEvent.editingContext.content);

        final String newText = precedentText + insertText + succeedingText;
        api.vfs.documentRequestChange(
          VFSDocumentRequestChangeEvent(
            originId: name,
            entityId: api.workspace.workspaceConfigs.entitiesLocation.entries
                .firstWhere(
                    (entry) => entry.value.$1 == editorKeyEvent.instanceId)
                .key,
            editorAction: EditorAction(
              editingValue: TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset: precedentText.length +
                      1 +
                      numSpaces +
                      (indentType == _IndentType.add
                          ? api.workspace.workspaceConfigs.stylingConfigs
                              .tabSizeInSpaces
                          : 0),
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

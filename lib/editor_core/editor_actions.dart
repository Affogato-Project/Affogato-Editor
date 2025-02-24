part of affogato.editor;

class EditorAction {
  final TextSelection? newSelection;
  final String? newContent;

  const EditorAction({
    required this.newContent,
    required this.newSelection,
  });
  const EditorAction.none()
      : newSelection = null,
        newContent = null;
}

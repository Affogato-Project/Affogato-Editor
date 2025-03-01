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

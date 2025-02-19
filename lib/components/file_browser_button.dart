part of affogato.editor;

enum QuartetButtonState { none, hovered, pressed, active }

class FileBrowserButton extends StatelessWidget {
  final EditorTheme editorTheme;
  final double indent;
  final AffogatoFileItem entry;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final QuartetButtonState buttonState;
  final void Function(dynamic) onEnter;
  final void Function(dynamic) onExit;
  final void Function(dynamic) onTapUp;
  final void Function() onDoubleTap;
  final bool expanded;

  const FileBrowserButton({
    required this.entry,
    required this.indent,
    required this.editorTheme,
    required this.workspaceConfigs,
    required this.buttonState,
    required this.onEnter,
    required this.onExit,
    required this.onTapUp,
    required this.onDoubleTap,
    required this.expanded,
    super.key,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: onEnter,
      onExit: onExit,
      child: GestureDetector(
        onTapUp: onTapUp,
        onDoubleTap: onDoubleTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: switch (buttonState) {
              QuartetButtonState.none => Colors.transparent,
              QuartetButtonState.hovered => Colors.red.withOpacity(0.1),
              QuartetButtonState.active => Colors.red.withOpacity(0.6),
              QuartetButtonState.pressed => Colors.blue,
            },
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: indent),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: entry is AffogatoDirectoryItem
                        ? Icon(
                            (expanded
                                ? Icons.arrow_downward
                                : Icons.chevron_right),
                            size: 40,
                          )
                        : const SizedBox(
                            width: 40,
                            height: 40,
                          ),
                  ),
                  Text(
                    entry is AffogatoDirectoryItem
                        ? (entry as AffogatoDirectoryItem).dirName
                        : workspaceConfigs
                            .getDoc((entry as AffogatoDocumentItem).id)
                            .docName,
                    style: TextStyle(color: editorTheme.defaultTextColor),
                  )
                ],
              ),
              /* if (widget.entry is AffogatoDirectoryItem && expanded) ...[
            for (final subentry in (widget.workspaceConfigs
                .getDir((widget.entry as AffogatoDirectoryItem).dirName)))
              FileBrowserButton(
                entry: subentry,
                indent: widget.indent + 16,
                editorTheme: widget.editorTheme,
                workspaceConfigs: widget.workspaceConfigs,
              ),
          ], */
            ],
          ),
        ),
      ),
    );
  }
}

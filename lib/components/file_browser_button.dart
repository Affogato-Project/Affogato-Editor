part of affogato.editor;

class FileBrowserButton extends StatefulWidget {
  final EditorTheme editorTheme;
  final double indent;
  final AffogatoFileItem entry;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  const FileBrowserButton({
    required this.entry,
    required this.indent,
    required this.editorTheme,
    required this.workspaceConfigs,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => FileBrowserButtonState();
}

class FileBrowserButtonState extends State<FileBrowserButton>
    with utils.StreamSubscriptionManager {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTapUp: (_) {
              if (widget.entry is AffogatoDirectoryItem) {
                setState(() {
                  expanded = !expanded;
                });
              }
            },
            onDoubleTap: () {
              if (widget.entry is AffogatoDocumentItem) {
                setState(() {
                  AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
                    WindowEditorRequestDocumentSetActiveEvent(
                      documentId: (widget.entry as AffogatoDocumentItem).id,
                    ),
                  );
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: widget.indent),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: widget.entry is AffogatoDirectoryItem
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
                  widget.entry is AffogatoDirectoryItem
                      ? (widget.entry as AffogatoDirectoryItem).dirName
                      : widget.workspaceConfigs
                          .getDoc((widget.entry as AffogatoDocumentItem).id)
                          .docName,
                  style: TextStyle(color: widget.editorTheme.defaultTextColor),
                )
              ],
            ),
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
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

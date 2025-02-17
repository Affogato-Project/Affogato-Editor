part of affogato.editor;

class FileBrowserButton extends StatefulWidget {
  final EditorTheme editorTheme;
  final double indent;
  final FileBrowserEntry entry;

  const FileBrowserButton({
    required this.entry,
    required this.indent,
    required this.editorTheme,
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
              if (widget.entry is FileBrowserDirectoryEntry) {
                setState(() {
                  expanded = !expanded;
                });
              }
            },
            onDoubleTap: () {
              if (widget.entry is FileBrowserDocumentEntry) {
                setState(() {
                  AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
                    WindowEditorRequestDocumentSetActiveEvent(
                      document:
                          (widget.entry as FileBrowserDocumentEntry).document,
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
                  child: widget.entry is FileBrowserDirectoryEntry
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
                  widget.entry is FileBrowserDirectoryEntry
                      ? (widget.entry as FileBrowserDirectoryEntry).dirName
                      : (widget.entry as FileBrowserDocumentEntry)
                          .document
                          .docName,
                  style: TextStyle(color: widget.editorTheme.defaultTextColor),
                )
              ],
            ),
          ),
          if (widget.entry is FileBrowserDirectoryEntry && expanded) ...[
            for (final subentry
                in (widget.entry as FileBrowserDirectoryEntry).entries)
              FileBrowserButton(
                entry: subentry,
                indent: widget.indent + 16,
                editorTheme: widget.editorTheme,
              ),
          ],
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

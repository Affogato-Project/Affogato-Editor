part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final double expandedWidth;
  final EditorTheme editorTheme;
  final List<FileBrowserEntry> items;

  const PrimaryBar({
    required this.expandedWidth,
    required this.items,
    required this.editorTheme,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PrimaryBarState();
}

class PrimaryBarState extends State<PrimaryBar> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return expanded
        ? Container(
            width: widget.expandedWidth,
            color: widget.editorTheme.primaryBarColor,
            child: ListView(
              children: [
                for (final entry in widget.items)
                  FileBrowserButton(
                    entry: entry,
                    indent: 0,
                    editorTheme: widget.editorTheme,
                  ),
              ],
            ),
          )
        : const SizedBox(width: 0, height: 0);
  }
}

class FileBrowserEntry {
  const FileBrowserEntry();
}

class FileBrowserDocumentEntry extends FileBrowserEntry {
  final AffogatoDocument document;

  const FileBrowserDocumentEntry({
    required this.document,
  });
}

class FileBrowserDirectoryEntry extends FileBrowserEntry {
  final String dirName;
  final List<FileBrowserEntry> entries;

  const FileBrowserDirectoryEntry({
    required this.dirName,
    required this.entries,
  });
}

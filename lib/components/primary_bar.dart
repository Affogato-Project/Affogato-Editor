part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final double expandedWidth;
  final EditorTheme editorTheme;
  final List<AffogatoFileItem> items;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  const PrimaryBar({
    required this.expandedWidth,
    required this.items,
    required this.editorTheme,
    required this.workspaceConfigs,
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
            height: double.infinity,
            decoration: BoxDecoration(
              color: widget.editorTheme.primaryBarColor,
              border: Border(
                left: BorderSide(
                  color: widget.editorTheme.borderColor,
                ),
                right: BorderSide(
                  color: widget.editorTheme.borderColor,
                ),
              ),
            ),
            child: ListView(
              children: [
                for (final entry in widget.items)
                  FileBrowserButton(
                    entry: entry,
                    indent: 0,
                    editorTheme: widget.editorTheme,
                    workspaceConfigs: widget.workspaceConfigs,
                  ),
              ],
            ),
          )
        : const SizedBox(width: 0, height: 0);
  }
}

/// Used to represent documents and directories when they are first loaded into
/// the editor. Afterwards, the editor will work with and manipulate these entities
/// using the [AffogatoFileItem], which passes IDs around rather than the actual entities.
sealed class FileItem {
  const FileItem();
}

class FileDocumentItem extends FileItem {
  final AffogatoDocument document;

  const FileDocumentItem({
    required this.document,
  });
}

class FileDirectoryItem extends FileItem {
  final String dirName;
  final List<FileItem> entries;

  const FileDirectoryItem({
    required this.dirName,
    required this.entries,
  });
}

sealed class AffogatoFileItem {
  const AffogatoFileItem();
}

class AffogatoDocumentItem extends AffogatoFileItem {
  final String id;
  const AffogatoDocumentItem(this.id);
}

class AffogatoDirectoryItem extends AffogatoFileItem {
  final String dirName;
  const AffogatoDirectoryItem(this.dirName);
}

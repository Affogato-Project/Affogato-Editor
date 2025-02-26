part of affogato.editor;

enum QuartetButtonState { none, hovered, pressed, active }

class FileBrowserButton extends StatefulWidget {
  final EditorTheme<Color, TextStyle> editorTheme;
  final double indent;
  final AffogatoFileItem entry;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final bool isRoot;

  FileBrowserButton({
    required this.entry,
    required this.indent,
    required this.editorTheme,
    required this.workspaceConfigs,
    this.isRoot = false,
  }) : super(key: ValueKey(entry.hash));

  @override
  State<StatefulWidget> createState() => FileBrowserButtonState();
}

class FileBrowserButtonState extends State<FileBrowserButton> {
  QuartetButtonState buttonState = QuartetButtonState.none;
  bool isDragTarget = false;
  bool isValidDragTarget = false;
  bool? expanded;
  bool hasFocus = false;

  @override
  void initState() {
    if (widget.entry is AffogatoDirectoryItem) expanded = widget.isRoot;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor;
    if (widget.entry is AffogatoDocumentItem) {
      if (widget.workspaceConfigs
          .isDocumentShown((widget.entry as AffogatoDocumentItem).documentId)) {
        buttonColor = hasFocus
            ? widget.editorTheme.buttonBackground ?? Colors.red
            : widget.editorTheme.buttonSecondaryBackground ?? Colors.red;
      } else {
        buttonColor = buttonState == QuartetButtonState.hovered
            ? widget.editorTheme.buttonSecondaryHoverBackground ?? Colors.red
            : Colors.transparent;
      }
    } else {
      buttonColor = buttonState == QuartetButtonState.hovered
          ? widget.editorTheme.buttonSecondaryHoverBackground ?? Colors.red
          : Colors.transparent;
    }
    return TapRegion(
      onTapInside: (_) => setState(() => hasFocus = true),
      onTapOutside: (_) => setState(() => hasFocus = false),
      child: Draggable(
        // only single file/directory for now.
        data: [widget.entry],
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: widget.editorTheme.buttonBackground?.withOpacity(0.4),
              border: Border.all(
                color: widget.editorTheme.buttonBackground ?? Colors.red,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 6,
                right: 6,
                top: 2,
                bottom: 2,
              ),
              child: Text(
                widget.entry is AffogatoDirectoryItem
                    ? "${widget.workspaceConfigs.fileManager.getDocsInDir((widget.entry as AffogatoDirectoryItem).dirPath).length} items"
                    : widget.workspaceConfigs.fileManager
                        .getDoc(
                            (widget.entry as AffogatoDocumentItem).documentId)
                        .docName,
                style: TextStyle(color: widget.editorTheme.buttonForeground),
              ),
            ),
          ),
        ),
        child: DragTarget<List<AffogatoFileItem>>(
          onWillAcceptWithDetails: (details) {
            isDragTarget = true;
            // assign a value to a variable and return that value, without even creating a separate named function. brilliant.
            return isValidDragTarget = () {
              if (widget.entry is! AffogatoDirectoryItem) return false;
              final List<String> docsInDir = widget.workspaceConfigs.fileManager
                  .getDocsInDir(
                      (widget.entry as AffogatoDirectoryItem).dirPath);
              final List<String> subdirs = widget.workspaceConfigs.fileManager
                  .getSubdirectoriesInDir(
                      (widget.entry as AffogatoDirectoryItem).dirPath);
              return details.data.every((item) {
                // make sure the dragged folder isn't already in the folder it is being dragged into
                if (item is AffogatoDirectoryItem) {
                  return item.dirPath !=
                          (widget.entry as AffogatoDirectoryItem).dirPath &&
                      !subdirs.contains(item.dirPath);
                } else {
                  // make sure the dragged document isn't already in the folder either
                  return !docsInDir
                      .contains((item as AffogatoDocumentItem).documentId);
                }
              });
            }();
          },
          onLeave: (_) => isValidDragTarget = isDragTarget = false,
          onAcceptWithDetails: (details) {
            for (final item in details.data) {
              if (item is AffogatoDirectoryItem) {
                widget.workspaceConfigs.fileManager.moveDir(item.dirPath,
                    (widget.entry as AffogatoDirectoryItem).dirPath);
              } else {
                widget.workspaceConfigs.fileManager.moveDoc(
                    (item as AffogatoDocumentItem).documentId,
                    (widget.entry as AffogatoDirectoryItem).dirPath);
              }
              AffogatoEvents.fileManagerStructureChangedEvents
                  .add(const FileManagerStructureChangedEvent());
            }
          },
          builder: (ctx, candidates, rejected) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDragTarget
                    ? widget.entry is AffogatoDocumentItem || !isValidDragTarget
                        ? Colors.transparent
                        : buttonColor
                    : buttonColor,
              ),
              child: ContextMenuRegion<(Type, String)>(
                contextMenuBuilder: (ctx, pos) =>
                    AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: TextSelectionToolbarAnchors(primaryAnchor: pos),
                  buttonItems: widget.entry is AffogatoDirectoryItem
                      ? [
                          ContextMenuButtonItem(
                            label: 'New File',
                            onPressed: () {
                              final String docId =
                                  widget.workspaceConfigs.fileManager.createDoc(
                                AffogatoDocument(
                                  docName: 'Untitled',
                                  srcContent: '',
                                  maxVersioningLimit: 5,
                                ),
                                path: (widget.entry as AffogatoDirectoryItem)
                                    .dirPath,
                              );
                              ContextMenuController.removeAny();
                              setState(() {
                                expanded = true;
                              });
                              AffogatoEvents
                                  .windowEditorRequestDocumentSetActiveEvents
                                  .add(
                                WindowEditorRequestDocumentSetActiveEvent(
                                    documentId: docId),
                              );
                            },
                          ),
                          ContextMenuButtonItem(
                            label: 'New Folder',
                            onPressed: () {
                              widget.workspaceConfigs.fileManager.createDir(
                                'untitled',
                                (widget.entry as AffogatoDirectoryItem).dirPath,
                              );
                              ContextMenuController.removeAny();
                              setState(() {
                                expanded = true;
                              });
                            },
                          ),
                        ]
                      : const [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTapUp: (_) => setState(() {
                        if (widget.entry is AffogatoDirectoryItem) {
                          expanded = !expanded!;
                        }
                      }),
                      onDoubleTap: () => setState(() {
                        if (widget.entry is AffogatoDocumentItem) {
                          buttonState = QuartetButtonState.active;
                          AffogatoEvents
                              .windowEditorRequestDocumentSetActiveEvents
                              .add(
                            WindowEditorRequestDocumentSetActiveEvent(
                              documentId: (widget.entry as AffogatoDocumentItem)
                                  .documentId,
                            ),
                          );
                        }
                      }),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(
                          () => buttonState =
                              buttonState == QuartetButtonState.none
                                  ? QuartetButtonState.hovered
                                  : buttonState,
                        ),
                        onExit: (_) => setState(
                          () => buttonState =
                              buttonState == QuartetButtonState.pressed ||
                                      buttonState == QuartetButtonState.active
                                  ? buttonState
                                  : QuartetButtonState.none,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: widget.entry is AffogatoDirectoryItem
                                  ? SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Icon(
                                          (expanded!
                                              ? Icons.keyboard_arrow_down
                                              : Icons.chevron_right),
                                          size: 24,
                                          color: widget.editorTheme
                                              .buttonSecondaryForeground,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Icon(
                                          Icons.description,
                                          size: 24,
                                          color: widget.editorTheme
                                              .buttonSecondaryForeground,
                                        ),
                                      ),
                                    ),
                            ),
                            Text(
                              widget.entry is AffogatoDirectoryItem
                                  ? widget.isRoot
                                      ? widget.workspaceConfigs.projectName
                                      : (widget.entry as AffogatoDirectoryItem)
                                          .dirPath
                                          .dirNameFromPath()
                                  : widget.workspaceConfigs.fileManager
                                      .getDoc(
                                          (widget.entry as AffogatoDocumentItem)
                                              .documentId)
                                      .docName,
                              style: TextStyle(
                                color: widget.entry is AffogatoDocumentItem &&
                                        hasFocus
                                    ? widget.editorTheme.buttonForeground
                                    : widget
                                        .editorTheme.buttonSecondaryForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.entry is AffogatoDirectoryItem && expanded!) ...[
                      for (final subentry in (widget
                          .workspaceConfigs.fileManager
                          .getSubdirectoriesInDir(
                              (widget.entry as AffogatoDirectoryItem).dirPath)))
                        Padding(
                          padding: EdgeInsets.only(
                              left: (widget.indent + 1) *
                                  utils.AffogatoConstants
                                      .primaryBarFileTreeIndentSize),
                          child: FileBrowserButton(
                            entry: AffogatoDirectoryItem(
                              subentry,
                              documents: [
                                for (final docId in widget
                                    .workspaceConfigs.fileManager
                                    .getDocsInDir(subentry))
                                  AffogatoDocumentItem(docId)
                              ],
                              directories: [
                                for (final dirPath in widget
                                    .workspaceConfigs.fileManager
                                    .getSubdirectoriesInDir(subentry))
                                  AffogatoDirectoryItem(dirPath)
                              ],
                            ),
                            indent: widget.indent + 1,
                            editorTheme: widget.editorTheme,
                            workspaceConfigs: widget.workspaceConfigs,
                          ),
                        ),
                      for (final subentry
                          in (widget.workspaceConfigs.fileManager.getDocsInDir(
                              (widget.entry as AffogatoDirectoryItem).dirPath)))
                        Padding(
                          padding: EdgeInsets.only(
                              left: (widget.indent + 1) *
                                  utils.AffogatoConstants
                                      .primaryBarFileTreeIndentSize),
                          child: FileBrowserButton(
                            entry: AffogatoDocumentItem(subentry),
                            indent: widget.indent + 1,
                            editorTheme: widget.editorTheme,
                            workspaceConfigs: widget.workspaceConfigs,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

extension StringUtils on String {
  String dirNameFromPath() => (split('/')..removeLast()).last;
}

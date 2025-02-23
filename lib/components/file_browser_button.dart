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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              buttonColor /* widget.entry is AffogatoDocumentItem
              ? widget.workspaceConfigs.isDocumentShown(
                      (widget.entry as AffogatoDocumentItem).documentId)
                  ? widget.editorTheme.buttonSecondaryBackground
                  : buttonState == QuartetButtonState.hovered
                      ? widget.editorTheme.buttonSecondaryHoverBackground
                      : Colors.transparent
              : buttonState == QuartetButtonState.hovered
                  ? widget.editorTheme.buttonSecondaryHoverBackground
                  : Colors.transparent */
          ,
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
                  AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
                    WindowEditorRequestDocumentSetActiveEvent(
                      documentId:
                          (widget.entry as AffogatoDocumentItem).documentId,
                    ),
                  );
                }
              }),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(
                  () => buttonState = buttonState == QuartetButtonState.none
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
                                  color: widget
                                      .editorTheme.buttonSecondaryForeground,
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
                                  color: widget
                                      .editorTheme.buttonSecondaryForeground,
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
                              .getDoc((widget.entry as AffogatoDocumentItem)
                                  .documentId)
                              .docName,
                      style: TextStyle(
                        color: widget.entry is AffogatoDocumentItem && hasFocus
                            ? widget.editorTheme.buttonForeground
                            : widget.editorTheme.buttonSecondaryForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.entry is AffogatoDirectoryItem && expanded!) ...[
              for (final subentry in (widget.workspaceConfigs.fileManager
                  .getSubdirectoriesInDir(
                      (widget.entry as AffogatoDirectoryItem).dirPath)))
                Padding(
                  padding: EdgeInsets.only(
                      left: (widget.indent + 1) *
                          utils.AffogatoConstants.primaryBarFileTreeIndentSize),
                  child: FileBrowserButton(
                    entry: AffogatoDirectoryItem(
                      subentry,
                      documents: [
                        for (final docId in widget.workspaceConfigs.fileManager
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
              for (final subentry in (widget.workspaceConfigs.fileManager
                  .getDocsInDir(
                      (widget.entry as AffogatoDirectoryItem).dirPath)))
                Padding(
                  padding: EdgeInsets.only(
                      left: (widget.indent + 1) *
                          utils.AffogatoConstants.primaryBarFileTreeIndentSize),
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
  }
}

extension StringUtils on String {
  String dirNameFromPath() => (split('/')..removeLast()).last;
}

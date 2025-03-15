part of affogato.editor;

enum QuartetButtonState { none, hovered, pressed, active }

class FileBrowserButton extends StatefulWidget {
  final double indent;
  final AffogatoVFSEntity entry;
  final bool isRoot;
  final AffogatoAPI api;

  FileBrowserButton({
    required this.api,
    required this.entry,
    required this.indent,
    this.isRoot = false,
  }) : super(key: ValueKey(entry.entityId));

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
    if (widget.entry.isDirectory) expanded = widget.isRoot;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor;
    if (widget.entry.isDirectory) {
      if (widget.api.workspace.workspaceConfigs.instancesData.values
          .whereType<AffogatoEditorInstanceData>()
          .map((data) => data.documentId)
          .contains(widget.entry.entityId)) {
        buttonColor = hasFocus
            ? widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
                    .buttonBackground ??
                Colors.red
            : widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
                    .buttonSecondaryBackground ??
                Colors.red;
      } else {
        buttonColor = buttonState == QuartetButtonState.hovered
            ? widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
                    .buttonSecondaryHoverBackground ??
                Colors.red
            : Colors.transparent;
      }
    } else {
      buttonColor = buttonState == QuartetButtonState.hovered
          ? widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
                  .buttonSecondaryHoverBackground ??
              Colors.red
          : Colors.transparent;
    }
    return TapRegion(
      onTapInside: (_) => setState(() => hasFocus = true),
      onTapOutside: (_) => setState(() => hasFocus = false),
      child: Draggable<List<AffogatoVFSEntity>>(
        // only single file/directory for now.
        data: [widget.entry],
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: widget.api.workspace.workspaceConfigs.themeBundle
                  .editorTheme.buttonBackground
                  ?.withOpacity(0.4),
              border: Border.all(
                color: widget.api.workspace.workspaceConfigs.themeBundle
                        .editorTheme.buttonBackground ??
                    Colors.red,
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
                widget.entry.isDirectory
                    ? "${widget.entry.files.length + widget.entry.subdirs.length} items"
                    : widget.entry.name,
                style: TextStyle(
                    color: widget.api.workspace.workspaceConfigs.themeBundle
                        .editorTheme.buttonForeground),
              ),
            ),
          ),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDragTarget
                ? !widget.entry.isDirectory || !isValidDragTarget
                    ? Colors.transparent
                    : buttonColor
                : buttonColor,
          ),
          child: ContextMenuRegion<(Type, String)>(
            contextMenuBuilder: (ctx, pos) =>
                AdaptiveTextSelectionToolbar.buttonItems(
              anchors: TextSelectionToolbarAnchors(primaryAnchor: pos),
              buttonItems: widget.entry.isDirectory
                  ? [
                      ContextMenuButtonItem(
                        label: 'New File',
                        onPressed: () {
                          final String docId = utils.generateId();
                          widget.api.vfs.createEntity(
                            dirId: widget.entry.entityId,
                            AffogatoVFSEntity.file(
                              entityId: docId,
                              doc: AffogatoDocument(
                                docName: 'Untitled',
                                srcContent: '',
                                maxVersioningLimit: 5,
                              ),
                            ),
                          );
                          ContextMenuController.removeAny();
                          setState(() {
                            expanded = true;
                          });
                          widget.api.window.requestDocumentSetActive(docId);
                        },
                      ),
                      ContextMenuButtonItem(
                        label: 'New Folder',
                        onPressed: () {
                          widget.api.vfs.createEntity(
                            dirId: widget.entry.entityId,
                            AffogatoVFSEntity.dir(
                              entityId: utils.generateId(),
                              name: 'untitled',
                              files: [],
                              subdirs: [],
                            ),
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
                    if (widget.entry.isDirectory) expanded = !expanded!;
                  }),
                  onDoubleTap: () => setState(() {
                    if (!widget.entry.isDirectory) {
                      buttonState = QuartetButtonState.active;
                      widget.api.window
                          .requestDocumentSetActive((widget.entry).entityId);
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
                    child: DragTarget<List<AffogatoVFSEntity>>(
                      // a valid drag target must:
                      // - be a directory
                      // - not be the item being dragged onto it (i.e, you can't drag a folder onto itself)
                      // - not already contain any of the items being dragged onto it
                      onWillAcceptWithDetails: (details) {
                        setState(() {
                          buttonState = buttonState == QuartetButtonState.none
                              ? QuartetButtonState.hovered
                              : buttonState;
                          isDragTarget = true;
                        });
                        // assign a value to a variable and return that value, without even creating a separate named function. brilliant.
                        var isValidDragTarget = (() =>
                            widget.entry.isDirectory &&
                            details.data.every((item) =>
                                item.entityId != widget.entry.entityId &&
                                !widget.entry.files.contains(item) &&
                                !widget.entry.subdirs.contains(item)))();
                        return isValidDragTarget;
                      },
                      onLeave: (_) {
                        setState(() {
                          isValidDragTarget = isDragTarget = false;
                        });
                      },

                      onAcceptWithDetails: (details) {
                        for (final item in details.data) {
                          widget.api.vfs.moveEntity(
                            entityId: item.entityId,
                            newDirId: widget.entry.entityId,
                          );

                          AffogatoEvents.vfsStructureChangedEventsController
                              .add(const VFSStructureChangedEvent());

                          isDragTarget = false;
                        }
                      },
                      builder: (ctx, candidates, rejected) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: widget.entry.isDirectory
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
                                            .api
                                            .workspace
                                            .workspaceConfigs
                                            .themeBundle
                                            .editorTheme
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
                                        color: widget
                                            .api
                                            .workspace
                                            .workspaceConfigs
                                            .themeBundle
                                            .editorTheme
                                            .buttonSecondaryForeground,
                                      ),
                                    ),
                                  ),
                          ),
                          Text(
                            widget.entry.name,
                            style: TextStyle(
                              color: !widget.entry.isDirectory && hasFocus
                                  ? widget.api.workspace.workspaceConfigs
                                      .themeBundle.editorTheme.buttonForeground
                                  : widget
                                      .api
                                      .workspace
                                      .workspaceConfigs
                                      .themeBundle
                                      .editorTheme
                                      .buttonSecondaryForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.entry.isDirectory && expanded!) ...[
                  for (final subentry in widget.entry.subdirs)
                    Padding(
                      padding: EdgeInsets.only(
                          left: (widget.indent + 1) *
                              utils.AffogatoConstants
                                  .primaryBarFileTreeIndentSize),
                      child: FileBrowserButton(
                        api: widget.api,
                        entry: subentry,
                        indent: widget.indent + 1,
                      ),
                    ),
                  for (final subentry in widget.entry.files)
                    Padding(
                      padding: EdgeInsets.only(
                          left: (widget.indent + 1) *
                              utils.AffogatoConstants
                                  .primaryBarFileTreeIndentSize),
                      child: FileBrowserButton(
                        api: widget.api,
                        entry: subentry,
                        indent: widget.indent + 1,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringUtils on String {
  String dirNameFromPath() => (split('/')..removeLast()).last;
}

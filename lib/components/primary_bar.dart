part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final EditorTheme<Color, TextStyle> editorTheme;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoAPI api;

  const PrimaryBar({
    required this.api,
    required this.editorTheme,
    required this.workspaceConfigs,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PrimaryBarState();
}

class PrimaryBarState extends State<PrimaryBar>
    with utils.StreamSubscriptionManager {
  @override
  void initState() {
    registerListener(
      widget.api.window.instanceDidSetActive,
      (event) {
        setState(() {});
      },
    );

    registerListener(
      widget.api.editor.instanceClosedStream,
      (event) {
        setState(() {});
      },
    );

    registerListener(
      widget.api.vfs.structureChangedStream,
      (_) {
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.workspaceConfigs.isPrimaryBarExpanded
              ? utils.AffogatoConstants.primaryBarExpandedWidth +
                  utils.AffogatoConstants.primaryBarClosedWidth
              : utils.AffogatoConstants.primaryBarClosedWidth) +
          2,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.editorTheme.panelBackground,
        border: Border(
          left: BorderSide(
            color: widget.editorTheme.panelBorder ?? Colors.red,
          ),
          right: BorderSide(
            color: widget.editorTheme.panelBorder ?? Colors.red,
          ),
        ),
      ),
      child: SizedBox(
        width: widget.workspaceConfigs.isPrimaryBarExpanded
            ? utils.AffogatoConstants.primaryBarExpandedWidth +
                utils.AffogatoConstants.primaryBarClosedWidth
            : utils.AffogatoConstants.primaryBarClosedWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: utils.AffogatoConstants.primaryBarClosedWidth,
              height: double.infinity,
              decoration: widget.workspaceConfigs.isPrimaryBarExpanded
                  ? BoxDecoration(
                      color: widget.editorTheme.panelBackground,
                      border: Border(
                        left: BorderSide(
                          color: widget.editorTheme.panelBorder ?? Colors.red,
                        ),
                        right: BorderSide(
                          color: widget.editorTheme.panelBorder ?? Colors.red,
                        ),
                      ),
                    )
                  : null,
              child: Column(
                children: [
                  AffogatoButton(
                    isPrimary: false,
                    width: utils.AffogatoConstants.primaryBarClosedWidth,
                    height: utils.AffogatoConstants.primaryBarClosedWidth,
                    editorTheme: widget.editorTheme,
                    onTap: () {
                      setState(() {
                        widget.workspaceConfigs.isPrimaryBarExpanded =
                            !widget.workspaceConfigs.isPrimaryBarExpanded;

                        AffogatoEvents.windowPaneLayoutChangedEventsController
                            .add(WindowPaneLayoutChangedEvent(widget
                                .workspaceConfigs.paneManager.panesLayout.id));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Icon(
                          Icons.file_copy,
                          size: 28,
                          color: widget.editorTheme.buttonSecondaryForeground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.workspaceConfigs.isPrimaryBarExpanded)
              SizedBox(
                width: utils.AffogatoConstants.primaryBarExpandedWidth,
                child: FileBrowserButton(
                  api: widget.api,
                  isRoot: true,
                  entry: widget.workspaceConfigs.vfs.root,
                  indent: 0,
                  editorTheme: widget.editorTheme,
                  workspaceConfigs: widget.workspaceConfigs,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

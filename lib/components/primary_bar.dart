part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final AffogatoAPI api;

  const PrimaryBar({
    required this.api,
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
      width: (widget.api.workspace.workspaceConfigs.isPrimaryBarExpanded
              ? utils.AffogatoConstants.primaryBarExpandedWidth +
                  utils.AffogatoConstants.primaryBarClosedWidth
              : utils.AffogatoConstants.primaryBarClosedWidth) +
          2,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
            .panelBackground,
        border: Border(
          left: BorderSide(
            color: widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
                    .panelBorder ??
                Colors.red,
          ),
          right: BorderSide(
            color: widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
                    .panelBorder ??
                Colors.red,
          ),
        ),
      ),
      child: SizedBox(
        width: widget.api.workspace.workspaceConfigs.isPrimaryBarExpanded
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
              decoration:
                  widget.api.workspace.workspaceConfigs.isPrimaryBarExpanded
                      ? BoxDecoration(
                          color: widget.api.workspace.workspaceConfigs
                              .themeBundle.editorTheme.panelBackground,
                          border: Border(
                            left: BorderSide(
                              color: widget.api.workspace.workspaceConfigs
                                      .themeBundle.editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                            right: BorderSide(
                              color: widget.api.workspace.workspaceConfigs
                                      .themeBundle.editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                          ),
                        )
                      : null,
              child: Column(
                children: [
                  AffogatoButton(
                    api: widget.api,
                    isPrimary: false,
                    width: utils.AffogatoConstants.primaryBarClosedWidth,
                    height: utils.AffogatoConstants.primaryBarClosedWidth,
                    onTap: () {
                      setState(() {
                        widget.api.workspace.workspaceConfigs
                                .isPrimaryBarExpanded =
                            !widget.api.workspace.workspaceConfigs
                                .isPrimaryBarExpanded;
                        // trigger a full re-layout from the root pane
                        AffogatoEvents
                            .windowPaneCellLayoutChangedEventsController
                            .add(WindowPaneCellLayoutChangedEvent(widget.api
                                .workspace.workspaceConfigs.panesLayout.id));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Icon(
                          Icons.file_copy,
                          size: 28,
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
                ],
              ),
            ),
            if (widget.api.workspace.workspaceConfigs.isPrimaryBarExpanded)
              SizedBox(
                width: utils.AffogatoConstants.primaryBarExpandedWidth,
                child: FileBrowserButton(
                  api: widget.api,
                  isRoot: true,
                  entry: widget.api.workspace.workspaceConfigs.vfs.root,
                  indent: 0,
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

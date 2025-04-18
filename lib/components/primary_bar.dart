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

enum PrimaryBarMode {
  collapsed,
  files,
  search,
}

class PrimaryBarState extends State<PrimaryBar>
    with utils.StreamSubscriptionManager {
  bool mouseIsOverPrimaryBar = false;

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
    return MouseRegion(
      onEnter: (_) => setState(() {
        mouseIsOverPrimaryBar = true;
      }),
      onExit: (_) => setState(() {
        mouseIsOverPrimaryBar = false;
      }),
      child: Container(
        width: (widget.api.workspace.workspaceConfigs.primaryBarMode !=
                    PrimaryBarMode.collapsed
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
              color: widget.api.workspace.workspaceConfigs.themeBundle
                      .editorTheme.panelBorder ??
                  Colors.red,
            ),
            right: BorderSide(
              color: widget.api.workspace.workspaceConfigs.themeBundle
                      .editorTheme.panelBorder ??
                  Colors.red,
            ),
          ),
        ),
        child: SizedBox(
          width: widget.api.workspace.workspaceConfigs.primaryBarMode !=
                  PrimaryBarMode.collapsed
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
                    widget.api.workspace.workspaceConfigs.primaryBarMode !=
                            PrimaryBarMode.collapsed
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
                          widget.api.workspace.workspaceConfigs.primaryBarMode =
                              widget.api.workspace.workspaceConfigs
                                          .primaryBarMode ==
                                      PrimaryBarMode.files
                                  ? PrimaryBarMode.collapsed
                                  : PrimaryBarMode.files;
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
                    AffogatoButton(
                      api: widget.api,
                      isPrimary: false,
                      width: utils.AffogatoConstants.primaryBarClosedWidth,
                      height: utils.AffogatoConstants.primaryBarClosedWidth,
                      onTap: () {
                        setState(() {
                          widget.api.workspace.workspaceConfigs.primaryBarMode =
                              widget.api.workspace.workspaceConfigs
                                          .primaryBarMode ==
                                      PrimaryBarMode.search
                                  ? PrimaryBarMode.collapsed
                                  : PrimaryBarMode.search;
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
                            Icons.search,
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
              switch (widget.api.workspace.workspaceConfigs.primaryBarMode) {
                PrimaryBarMode.files => SizedBox(
                    width: utils.AffogatoConstants.primaryBarExpandedWidth,
                    child: FileBrowserButton(
                      api: widget.api,
                      isRoot: true,
                      entry: widget.api.workspace.workspaceConfigs.vfs.root,
                      showIndentGuides: mouseIsOverPrimaryBar,
                    ),
                  ),
                PrimaryBarMode.search => const SizedBox(),
                /* SizedBox(
                    width: utils.AffogatoConstants.primaryBarExpandedWidth,
                    child: SearchAndReplacePanel(
                      api: widget.api,
                      width: utils.AffogatoConstants.primaryBarExpandedWidth,
                    ),
                  ), */
                PrimaryBarMode.collapsed => const SizedBox(),
              }
            ],
          ),
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

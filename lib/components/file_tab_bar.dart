part of affogato.editor;

class FileTabBar extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;
  final List<String> instanceIds;
  final String? currentInstanceId;
  final String paneId;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoAPI api;

  const FileTabBar({
    required this.api,
    required this.stylingConfigs,
    required this.workspaceConfigs,
    required this.instanceIds,
    required this.currentInstanceId,
    required this.paneId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => FileTabBarState();
}

class FileTabBarState extends State<FileTabBar>
    with utils.StreamSubscriptionManager {
  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [];
    for (int i = 0; i < widget.instanceIds.length; i++) {
      final bool isCurrent = widget.instanceIds[i] == widget.currentInstanceId;
      final Color activeColor = isCurrent
          ? widget.workspaceConfigs.themeBundle.editorTheme
                  .tabActiveBackground ??
              Colors.red
          : widget.workspaceConfigs.themeBundle.editorTheme
                  .tabInactiveBackground ??
              Colors.red;
      tabs.add(
        FileTab(
          label: widget.workspaceConfigs.vfs
              .accessEntity(
                  (widget.workspaceConfigs.instancesData[widget.instanceIds[i]]
                          as AffogatoEditorInstanceData)
                      .documentId)!
              .name,
          instanceId: widget.instanceIds[i],
          paneId: widget.paneId,
          onTap: () {
            widget.api.window.setActiveInstance(
              instanceId: widget.instanceIds[i],
              paneId: widget.api.workspace.workspaceConfigs.activePane,
            );

            setState(() {});
          },
          onClose: () {
            widget.api.editor.closeInstance(instanceId: widget.instanceIds[i]);
            AffogatoEvents.editorInstanceClosedEventsController.add(
              EditorInstanceClosedEvent(
                instanceId: widget.instanceIds[i],
                paneId: widget.paneId,
              ),
            );
          },
          editorTheme: widget.workspaceConfigs.themeBundle.editorTheme,
          activeColor: activeColor,
          isCurrent: isCurrent,
          height: widget.stylingConfigs.tabBarHeight,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: widget.stylingConfigs.tabBarHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: widget.workspaceConfigs.themeBundle.editorTheme
                    .editorGroupHeaderTabsBackground,
                border: Border.all(
                  color: widget.workspaceConfigs.themeBundle.editorTheme
                          .editorGroupHeaderTabsBorder ??
                      Colors.red,
                ),
              ),
            ),
          ),
          Row(
            children: tabs,
          ),
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

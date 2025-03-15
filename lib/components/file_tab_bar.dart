part of affogato.editor;

class FileTabBar extends StatelessWidget {
  final List<String> instanceIds;
  final String? currentInstanceId;
  final String paneId;
  final AffogatoAPI api;

  const FileTabBar({
    required this.api,
    required this.instanceIds,
    required this.currentInstanceId,
    required this.paneId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [];
    for (int i = 0; i < instanceIds.length; i++) {
      final bool isCurrent = instanceIds[i] == currentInstanceId;
      final Color activeColor = isCurrent
          ? api.workspace.workspaceConfigs.themeBundle.editorTheme
                  .tabActiveBackground ??
              Colors.red
          : api.workspace.workspaceConfigs.themeBundle.editorTheme
                  .tabInactiveBackground ??
              Colors.red;
      tabs.add(
        FileTab(
          label: api.vfs
              .accessEntity(
                  (api.workspace.workspaceConfigs.instancesData[instanceIds[i]]
                          as AffogatoEditorInstanceData)
                      .documentId)!
              .name,
          instanceId: instanceIds[i],
          paneId: paneId,
          onTap: () {
            api.window.setActiveInstance(
              instanceId: instanceIds[i],
              paneId: paneId,
            );
          },
          onClose: () {
            api.editor.closeInstance(instanceId: instanceIds[i]);
          },
          editorTheme: api.workspace.workspaceConfigs.themeBundle.editorTheme,
          activeColor: activeColor,
          isCurrent: isCurrent,
          height: api.workspace.workspaceConfigs.stylingConfigs.tabBarHeight,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: api.workspace.workspaceConfigs.stylingConfigs.tabBarHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: api.workspace.workspaceConfigs.themeBundle.editorTheme
                    .editorGroupHeaderTabsBackground,
                border: Border.all(
                  color: api.workspace.workspaceConfigs.themeBundle.editorTheme
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
}

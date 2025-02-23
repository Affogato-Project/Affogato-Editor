part of affogato.editor;

class FileTabBar extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;
  final List<String> documentIds;
  final String? currentDocId;
  final String paneId;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  const FileTabBar({
    required this.stylingConfigs,
    required this.workspaceConfigs,
    required this.documentIds,
    required this.currentDocId,
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

    for (int i = 0; i < widget.documentIds.length; i++) {
      final bool isCurrent = widget.documentIds[i] == widget.currentDocId;
      final Color activeColor = isCurrent
          ? widget.workspaceConfigs.themeBundle.editorTheme
                  .tabActiveBackground ??
              Colors.red
          : widget.workspaceConfigs.themeBundle.editorTheme
                  .tabInactiveBackground ??
              Colors.red;
      tabs.add(
        GestureDetector(
          onTap: () {
            AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
              WindowEditorRequestDocumentSetActiveEvent(
                documentId: widget.documentIds[i],
              ),
            );
            setState(() {});
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              height: widget.stylingConfigs.tabBarHeight,
              decoration: BoxDecoration(
                color: activeColor,
                border: Border(
                  right: BorderSide(
                    color: widget.workspaceConfigs.themeBundle.editorTheme
                            .tabBorder ??
                        Colors.red,
                  ),
                  top: BorderSide(
                    color: (isCurrent
                            ? widget.workspaceConfigs.themeBundle.editorTheme
                                .tabActiveBorderTop
                            : widget.workspaceConfigs.themeBundle.editorTheme
                                .tabBorder) ??
                        Colors.red,
                  ),
                  bottom: BorderSide(
                      color: isCurrent
                          ? activeColor
                          : widget.workspaceConfigs.themeBundle.editorTheme
                                  .editorGroupHeaderTabsBorder ??
                              Colors.red),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.workspaceConfigs.fileManager
                          .getDoc(widget.documentIds[i])
                          .docName,
                      style: TextStyle(
                        color: isCurrent
                            ? widget.workspaceConfigs.themeBundle.editorTheme
                                .tabActiveForeground
                            : widget.workspaceConfigs.themeBundle.editorTheme
                                .tabInactiveForeground,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        AffogatoEvents.editorDocumentClosedEvents.add(
                          EditorDocumentClosedEvent(
                            documentId: widget.documentIds[i],
                            paneId: widget.paneId,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.close,
                        size: 14,
                        color: isCurrent
                            ? widget.workspaceConfigs.themeBundle.editorTheme
                                .tabActiveForeground
                            : widget.workspaceConfigs.themeBundle.editorTheme
                                .tabInactiveForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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

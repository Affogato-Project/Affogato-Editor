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
          ? widget.stylingConfigs.themeBundle.editorTheme.editorColor
          : Colors.transparent;
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
                  top: isCurrent
                      ? BorderSide(
                          color: widget.stylingConfigs.themeBundle.editorTheme
                              .defaultTextColor
                              .withOpacity(0.5),
                          width: 1,
                        )
                      : BorderSide.none,
                  bottom: BorderSide(
                    color: activeColor,
                  ),
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
                        color: widget.stylingConfigs.themeBundle.editorTheme
                            .defaultTextColor
                            .withOpacity(0.5),
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
                        color: widget.stylingConfigs.themeBundle.editorTheme
                            .defaultTextColor
                            .withOpacity(0.5),
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
      child: Row(
        children: tabs,
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

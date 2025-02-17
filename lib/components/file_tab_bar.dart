part of affogato.editor;

class FileTabBar extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;
  final List<AffogatoDocument> documents;
  final AffogatoDocument? currentDoc;

  const FileTabBar({
    required this.stylingConfigs,
    required this.documents,
    required this.currentDoc,
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

    for (int i = 0; i < widget.documents.length; i++) {
      final bool isCurrent = widget.documents[i] == widget.currentDoc;
      tabs.add(
        Container(
          height: widget.stylingConfigs.tabBarHeight,
          color: isCurrent
              ? widget.stylingConfigs.themeBundle.editorTheme.editorColor
              : Colors.transparent,
          child: GestureDetector(
            onTap: () {
              AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
                WindowEditorRequestDocumentSetActiveEvent(
                  document: widget.documents[i],
                ),
              );
              setState(() {});
            },
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.documents[i].docName,
                      style: TextStyle(
                        color: isCurrent
                            ? widget.stylingConfigs.themeBundle.editorTheme
                                .defaultTextColor
                            : widget.stylingConfigs.themeBundle.editorTheme
                                .defaultTextColor
                                .withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        size: 10,
                        color: isCurrent
                            ? widget.stylingConfigs.themeBundle.editorTheme
                                .defaultTextColor
                            : widget.stylingConfigs.themeBundle.editorTheme
                                .defaultTextColor
                                .withOpacity(0.5),
                      ),
                    ),
                  ],
                )),
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

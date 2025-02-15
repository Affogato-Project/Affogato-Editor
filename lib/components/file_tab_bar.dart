part of affogato.editor;

class FileTabBar extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;
  final List<AffogatoDocument> documents;

  const FileTabBar({
    required this.stylingConfigs,
    required this.documents,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => FileTabBarState();
}

class FileTabBarState extends State<FileTabBar> {
  int activeDocIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<GestureDetector> tabs = [];
    for (int i = 0; i < widget.documents.length; i++) {
      tabs.add(
        GestureDetector(
          onTap: () => AffogatoEvents.editorInstanceSetActiveEvents.add(
            WindowEditorInstanceSetActiveEvent(document: widget.documents[i]),
          ),
          child: Text(
            widget.documents[i].docName,
            style: TextStyle(
              color: i == activeDocIndex ? Colors.red : Colors.blue,
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
}

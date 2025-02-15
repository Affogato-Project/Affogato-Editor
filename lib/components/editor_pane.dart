part of affogato.editor;

class EditorPane extends StatefulWidget {
  final List<AffogatoDocument> documents;
  final LayoutConfigs layoutConfigs;
  final AffogatoStylingConfigs stylingConfigs;

  const EditorPane({
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.documents,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

class EditorPaneState extends State<EditorPane> {
  final List<AffogatoDocument> documents = [];

  @override
  void initState() {
    documents.addAll(widget.documents);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.layoutConfigs.width,
      height: widget.layoutConfigs.height,
      child: Column(
        children: [
          FileTabBar(
            stylingConfigs: widget.stylingConfigs,
            documents: widget.documents,
          ),
          // place the affogato editor instance here
          // whether you maintain a separate state for each document
          // or load it on-the-fly
          // can be a configurable parameter
        ],
      ),
    );
  }
}

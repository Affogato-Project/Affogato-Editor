part of affogato.editor;

class EditorPane extends StatefulWidget {
  final List<AffogatoDocument> documents;
  final LayoutConfigs layoutConfigs;
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;

  const EditorPane({
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.performanceConfigs,
    required this.documents,
    required this.windowKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

class EditorPaneState extends State<EditorPane> {
  final List<AffogatoDocument> documents = [];
  late AffogatoDocument currentDocument;

  @override
  void initState() {
    documents.addAll(widget.documents);
    if (documents.isEmpty) {
      documents.add(AffogatoDocument(srcContent: '', docName: 'Untitled'));
    }
    currentDocument = documents.first;
    AffogatoEvents.editorInstanceSetActiveEvents.stream.listen((event) {
      currentDocument = event.document;
    });
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
          SizedBox(
            width: widget.layoutConfigs.width,
            height: widget.layoutConfigs.height -
                widget.stylingConfigs.tabBarHeight,
            child: AffogatoEditorInstance(
              document: currentDocument,
              instanceState: widget.performanceConfigs.rendererType ==
                      InstanceRendererType.savedState
                  ? widget.windowKey.currentState!.savedStates[currentDocument]
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

part of affogato.editor;

class EditorPane extends StatefulWidget {
  final List<AffogatoDocument> documents;
  final LayoutConfigs layoutConfigs;
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;

  const EditorPane({
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.performanceConfigs,
    required this.workspaceConfigs,
    required this.documents,
    required this.windowKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

class EditorPaneState extends State<EditorPane>
    with utils.StreamSubscriptionManager {
  final String paneId = utils.generateId();
  AffogatoDocument? currentDocument;

  @override
  void initState() {
    if (!widget.workspaceConfigs.paneDocumentData.containsKey(paneId)) {
      widget.workspaceConfigs.paneDocumentData[paneId] = widget.documents;
    }

    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream
          .where((e) => e.paneId == paneId),
      (event) {
        setState(() {
          currentDocument = event.document;
          AffogatoEvents.editorInstanceRequestReloadEvents
              .add(const EditorInstanceRequestReloadEvent());
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FileTabBar(
            stylingConfigs: widget.stylingConfigs,
            documents: widget.workspaceConfigs.paneDocumentData[paneId]!,
            currentDoc: currentDocument,
          ),
          currentDocument != null
              ? Container(
                  width: double.infinity,
                  height: widget.layoutConfigs.height -
                      widget.stylingConfigs.tabBarHeight -
                      utils.AffogatoConstants.tabBarPadding * 2,
                  color:
                      widget.stylingConfigs.themeBundle.editorTheme.editorColor,
                  child: AffogatoEditorInstance(
                    document: currentDocument!,
                    width: widget.layoutConfigs.width,
                    editorTheme: widget.stylingConfigs.themeBundle.editorTheme,
                    instanceState: widget.performanceConfigs.rendererType ==
                            InstanceRendererType.savedState
                        ? widget.windowKey.currentState!
                            .savedStates[currentDocument]
                        : null,
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.abc,
                    size: 40,
                  ),
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

part of affogato.editor;

class EditorPane extends StatefulWidget {
  final List<String> documentIds;
  final LayoutConfigs layoutConfigs;
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final GlobalKey<AffogatoWindowState> windowKey;
  final String paneId;

  const EditorPane({
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.performanceConfigs,
    required this.workspaceConfigs,
    required this.documentIds,
    required this.windowKey,
    required this.paneId,
    required super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

class EditorPaneState extends State<EditorPane>
    with utils.StreamSubscriptionManager {
  String? currentDocumentId;

  @override
  void initState() {
    if (!widget.workspaceConfigs.paneDocumentData.containsKey(widget.paneId)) {
      widget.workspaceConfigs.paneDocumentData[widget.paneId] =
          widget.documentIds;
    }

    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (event) {
        setState(() {
          currentDocumentId = event.documentId;
          AffogatoEvents.editorInstanceRequestReloadEvents
              .add(const EditorInstanceRequestReloadEvent());
        });
      },
    );

    registerListener(
      AffogatoEvents.windowEditorInstanceUnsetActiveEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (event) {
        setState(() {
          if (widget.documentIds.isEmpty) {
            currentDocumentId = null;
          } else {
            currentDocumentId = widget.documentIds.last;
          }
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
            documentIds:
                widget.workspaceConfigs.paneDocumentData[widget.paneId]!,
            workspaceConfigs: widget.workspaceConfigs,
            currentDocId: currentDocumentId,
            paneId: widget.paneId,
          ),
          currentDocumentId != null
              ? Container(
                  width: double.infinity,
                  height: widget.layoutConfigs.height -
                      widget.stylingConfigs.tabBarHeight -
                      utils.AffogatoConstants.tabBarPadding * 2,
                  decoration: BoxDecoration(
                    color: widget
                        .stylingConfigs.themeBundle.editorTheme.editorColor,
                    border: Border(
                      right: BorderSide(
                        color: widget
                            .stylingConfigs.themeBundle.editorTheme.borderColor,
                      ),
                    ),
                  ),
                  child: AffogatoEditorInstance(
                    documentId: currentDocumentId!,
                    workspaceConfigs: widget.workspaceConfigs,
                    width: widget.layoutConfigs.width,
                    editorTheme: widget.stylingConfigs.themeBundle.editorTheme,
                    instanceState: widget.performanceConfigs.rendererType ==
                            InstanceRendererType.savedState
                        ? widget.workspaceConfigs.statesRegistry
                                .containsKey(currentDocumentId)
                            ? widget.workspaceConfigs
                                .statesRegistry[currentDocumentId]
                            : null
                        : null,
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Text(
                      'Affogato',
                      style: TextStyle(
                        color: widget.stylingConfigs.themeBundle.editorTheme
                            .defaultTextColor,
                      ),
                    ),
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

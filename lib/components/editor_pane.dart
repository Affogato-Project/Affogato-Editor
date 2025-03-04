part of affogato.editor;

/// An [EditorPane] corresponds to what VSCode calls the "EditorGroup".
class EditorPane extends StatefulWidget {
  final LayoutConfigs layoutConfigs;
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoExtensionsEngine extensionsEngine;
  final GlobalKey<AffogatoWindowState> windowKey;
  final String paneId;

  const EditorPane({
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.performanceConfigs,
    required this.workspaceConfigs,
    required this.extensionsEngine,
    required this.windowKey,
    required this.paneId,
    required super.key,
  });

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

class EditorPaneState extends State<EditorPane>
    with utils.StreamSubscriptionManager {
  /// This is used to manage which [PaneInstance] is shown
  String? currentInstanceId;
  late List<String> instanceIds;

  void paneLoad() {
    instanceIds = widget.workspaceConfigs.panesData[widget.paneId]!;
    if (instanceIds.isNotEmpty) currentInstanceId = instanceIds.first;
  }

  @override
  void initState() {
    paneLoad();

    registerListener(
      AffogatoEvents.windowEditorPaneReloadEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (_) => setState(() {
        paneLoad();
      }),
    );

    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream,
      (event) {
        if (instanceIds.contains(event.instanceId)) {
          setState(() {
            currentInstanceId = event.instanceId;
          });
        }
      },
    );

    registerListener(
      AffogatoEvents.windowEditorInstanceUnsetActiveEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (event) {
        setState(() {
          if (instanceIds.isEmpty) {
            currentInstanceId = null;
          } else {
            currentInstanceId = instanceIds.last;
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
          if (instanceIds.isNotEmpty)
            FileTabBar(
              stylingConfigs: widget.stylingConfigs,
              instanceIds: instanceIds,
              workspaceConfigs: widget.workspaceConfigs,
              currentInstanceId: currentInstanceId,
              paneId: widget.paneId,
            ),
          currentInstanceId != null
              ? Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: widget.layoutConfigs.height -
                      widget.stylingConfigs.tabBarHeight -
                      utils.AffogatoConstants.tabBarPadding * 2,
                  decoration: BoxDecoration(
                    color: widget.workspaceConfigs.themeBundle.editorTheme
                        .editorBackground,
                    border: Border(
                      left: BorderSide(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                                .panelBorder ??
                            Colors.red,
                      ),
                      right: BorderSide(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                                .panelBorder ??
                            Colors.red,
                      ),
                      bottom: BorderSide(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                                .panelBorder ??
                            Colors.red,
                      ),
                    ),
                  ),
                  child: AffogatoEditorInstance(
                    instanceId: currentInstanceId!,
                    workspaceConfigs: widget.workspaceConfigs,
                    width: widget.layoutConfigs.width,
                    editorTheme:
                        widget.workspaceConfigs.themeBundle.editorTheme,
                    extensionsEngine: widget.extensionsEngine,
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Text(
                      'Affogato',
                      style: TextStyle(
                        color: widget.workspaceConfigs.themeBundle.editorTheme
                            .editorForeground,
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

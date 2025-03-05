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
  bool isDragTarget = false;

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

    registerListener(
      AffogatoEvents.editorPaneAddInstanceEvents.stream
          .where((e) => e.paneId == widget.paneId),
      (event) {
        if (instanceIds.contains(event.instanceId)) return;
        setState(() {
          instanceIds.add(currentInstanceId = event.instanceId);
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color? bgColor;
    if (isDragTarget) {
      bgColor = widget.workspaceConfigs.themeBundle.editorTheme
          .buttonSecondaryHoverBackground;
    } else if (currentInstanceId != null) {
      bgColor =
          widget.workspaceConfigs.themeBundle.editorTheme.editorBackground;
    } else {
      bgColor = null;
    }

    return Expanded(
      child: DragTarget<FileTabDragData>(
          onWillAcceptWithDetails: (details) {
            final bool willAccept = widget.paneId != details.data.paneId;
            if (willAccept) {
              setState(() {
                isDragTarget = willAccept;
              });
            }

            return willAccept;
          },
          onLeave: (_) => setState(() {
                isDragTarget = false;
              }),
          onAcceptWithDetails: (details) {
            AffogatoEvents.windowEditorInstanceClosedEvents.add(
              WindowEditorInstanceClosedEvent(
                paneId: details.data.paneId,
                instanceId: details.data.instanceId,
              ),
            );
            AffogatoEvents.editorPaneAddInstanceEvents.add(
              EditorPaneAddInstanceEvent(
                paneId: widget.paneId,
                instanceId: details.data.instanceId,
              ),
            );
            setState(() {
              isDragTarget = false;
            });
          },
          builder: (conext, candidates, rejected) {
            return Column(
              children: [
                instanceIds.isNotEmpty
                    ? FileTabBar(
                        stylingConfigs: widget.stylingConfigs,
                        instanceIds: instanceIds,
                        workspaceConfigs: widget.workspaceConfigs,
                        currentInstanceId: currentInstanceId,
                        paneId: widget.paneId,
                      )
                    : SizedBox(height: widget.stylingConfigs.tabBarHeight),
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: widget.layoutConfigs.height -
                      widget.stylingConfigs.tabBarHeight -
                      utils.AffogatoConstants.tabBarPadding * 2,
                  decoration: BoxDecoration(
                    color: bgColor,
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
                  child: currentInstanceId != null
                      ? AffogatoEditorInstance(
                          instanceId: currentInstanceId!,
                          workspaceConfigs: widget.workspaceConfigs,
                          width: widget.layoutConfigs.width,
                          editorTheme:
                              widget.workspaceConfigs.themeBundle.editorTheme,
                          extensionsEngine: widget.extensionsEngine,
                        )
                      : Center(
                          child: SizedBox(
                            width: 100,
                            height: 50,
                            child: Text(
                              'Affogato',
                              style: TextStyle(
                                color: widget.workspaceConfigs.themeBundle
                                    .editorTheme.editorForeground,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

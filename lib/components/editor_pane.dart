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

enum DragAreaSegment { center, left, right, top, bottom }

class EditorPaneState extends State<EditorPane>
    with utils.StreamSubscriptionManager {
  /// This is used to manage which [PaneInstance] is shown
  String? currentInstanceId;
  late List<String> instanceIds;
  bool isDragTarget = false;
  DragAreaSegment? dragAreaSegment;

  void paneLoad() {
    instanceIds = widget.workspaceConfigs.panesData[widget.paneId]!.instances;
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
    return DragTarget<List<AffogatoVFSEntity>>(
      onWillAcceptWithDetails: (details) {
        final bool willAccept =
            details.data.every((entity) => !entity.isDirectory);
        if (willAccept) {
          setState(() {
            isDragTarget = willAccept;
            dragAreaSegment = DragAreaSegment.center;
          });
        }

        return willAccept;
      },
      onLeave: (_) => setState(() {
        isDragTarget = false;
        dragAreaSegment = null;
      }),
      onMove: (details) {
        /* print((
            details.offset.dx - (context.size?.width ?? 0),
            details.offset.dy - (context.size?.height ?? 0)
          )); */
      },
      onAcceptWithDetails: (details) {
        for (final entity in details.data) {
          AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
              WindowEditorRequestDocumentSetActiveEvent(
                  documentId: entity.entityId));
/*           final String instanceId = utils.generateId();
          widget.workspaceConfigs.instancesData[instanceId] =
              AffogatoEditorInstanceData(
            documentId: entity.entityId,
            languageBundle: widget.workspaceConfigs.detectLanguage(widget
                .workspaceConfigs.vfs
                .accessEntity(entity.entityId)!
                .document!
                .extension),
            themeBundle: widget.workspaceConfigs.themeBundle,
          );
          AffogatoEvents.editorPaneAddInstanceEvents.add(
            EditorPaneAddInstanceEvent(
              paneId: widget.paneId,
              instanceId: instanceId,
            ),
          ); */
        }

        setState(() {
          isDragTarget = false;
          dragAreaSegment = null;
        });
      },
      builder: (context, _, __) {
        return DragTarget<FileTabDragData>(
            onWillAcceptWithDetails: (details) {
              final bool willAccept = widget.paneId != details.data.paneId;
              if (willAccept) {
                setState(() {
                  isDragTarget = willAccept;
                  dragAreaSegment = DragAreaSegment.center;
                });
              }

              return willAccept;
            },
            onLeave: (_) => setState(() {
                  isDragTarget = false;
                  dragAreaSegment = null;
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
                dragAreaSegment = null;
              });
            },
            builder: (context, ___, ____) {
              return Column(
                children: [
                  if (instanceIds.isNotEmpty)
                    FileTabBar(
                      stylingConfigs: widget.stylingConfigs,
                      instanceIds: instanceIds,
                      workspaceConfigs: widget.workspaceConfigs,
                      currentInstanceId: currentInstanceId,
                      paneId: widget.paneId,
                    ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    height: (instanceIds.isEmpty
                            ? widget.layoutConfigs.height
                            : widget.layoutConfigs.height -
                                widget.stylingConfigs.tabBarHeight) -
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
                    child: Stack(
                      children: [
                        currentInstanceId != null
                            ? AffogatoEditorInstance(
                                instanceId: currentInstanceId!,
                                workspaceConfigs: widget.workspaceConfigs,
                                layoutConfigs: widget.layoutConfigs,
                                editorTheme: widget
                                    .workspaceConfigs.themeBundle.editorTheme,
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
                        if (isDragTarget)
                          Positioned(
                            child: Container(
                              color: widget.workspaceConfigs.themeBundle
                                  .editorTheme.buttonSecondaryHoverBackground,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            });
      },
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

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
  final String cellId;

  EditorPane({
    required this.cellId,
    required this.stylingConfigs,
    required this.layoutConfigs,
    required this.performanceConfigs,
    required this.workspaceConfigs,
    required this.extensionsEngine,
    required this.windowKey,
    required this.paneId,
  }) : super(
            key: ValueKey(
                "${workspaceConfigs.panesData[paneId]}${layoutConfigs.width}-${layoutConfigs.height}-$paneId-$cellId"));

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

enum DragAreaSegment { centre, left, right, top, bottom }

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
        paneLoad();
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
        paneLoad();
        if (instanceIds.contains(event.instanceId)) return;
        setState(() {
          instanceIds.add(currentInstanceId = event.instanceId);
        });
      },
    );

    super.initState();
  }

  void updatePointer(DragTargetDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    if (localOffset.dx < widget.layoutConfigs.width * 0.2) {
      setState(() => dragAreaSegment = DragAreaSegment.left);
    } else if (localOffset.dx > widget.layoutConfigs.width * 0.8) {
      setState(() => dragAreaSegment = DragAreaSegment.right);
    } else if (localOffset.dy < widget.layoutConfigs.height * 0.2) {
      setState(() => dragAreaSegment = DragAreaSegment.top);
    } else if (localOffset.dy > widget.layoutConfigs.height * 0.8) {
      setState(() => dragAreaSegment = DragAreaSegment.bottom);
    } else {
      setState(() => dragAreaSegment = DragAreaSegment.centre);
    }
  }

  List<String> createInstancesFromEntities(List<AffogatoVFSEntity> entities) {
    final List<String> results = [];

    for (final entity in entities) {
      final String id = utils.generateId();
      AffogatoEvents.editorInstanceCreateEvents
          .add(const EditorInstanceCreateEvent());
      widget.workspaceConfigs.instancesData[id] = AffogatoEditorInstanceData(
        documentId: entity.entityId,
        languageBundle: widget.workspaceConfigs.detectLanguage(widget
            .workspaceConfigs.vfs
            .accessEntity(entity.entityId)!
            .document!
            .extension),
        themeBundle: widget.workspaceConfigs.themeBundle,
      );
      results.add(id);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.layoutConfigs.width,
      height: widget.layoutConfigs.height,
      child: GestureDetector(
        onTap: () => widget.workspaceConfigs.activePane = widget.paneId,
        child: DragTarget<List<AffogatoVFSEntity>>(
          onWillAcceptWithDetails: (details) {
            final bool willAccept =
                details.data.every((entity) => !entity.isDirectory);
            if (willAccept) {
              setState(() {
                isDragTarget = willAccept;
                dragAreaSegment = DragAreaSegment.centre;
              });
            }

            return willAccept;
          },
          onLeave: (_) => setState(() {
            isDragTarget = false;
            dragAreaSegment = null;
          }),
          onMove: updatePointer,
          onAcceptWithDetails: (details) {
            final String newPaneId = utils.generateId();
            widget.workspaceConfigs.panesData[newPaneId] =
                PaneData(instances: createInstancesFromEntities(details.data));
            switch (dragAreaSegment!) {
              case DragAreaSegment.left:
                widget.workspaceConfigs.paneManager.addPaneLeft(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.right:
                widget.workspaceConfigs.paneManager.addPaneRight(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.bottom:
                widget.workspaceConfigs.paneManager.addPaneBottom(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.top:
                widget.workspaceConfigs.paneManager.addPaneTop(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.centre:
                for (final entity in details.data) {
                  AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
                    WindowEditorRequestDocumentSetActiveEvent(
                      documentId: entity.entityId,
                      paneId: widget.paneId,
                    ),
                  );
                }
                break;
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
                      dragAreaSegment = DragAreaSegment.centre;
                    });
                  }

                  return willAccept;
                },
                onLeave: (_) => setState(() {
                      isDragTarget = false;
                      dragAreaSegment = null;
                    }),
                onMove: updatePointer,
                onAcceptWithDetails: (details) {
                  AffogatoEvents.windowEditorInstanceClosedEvents.add(
                    WindowEditorInstanceClosedEvent(
                      paneId: details.data.paneId,
                      instanceId: details.data.instanceId,
                    ),
                  );

                  switch (dragAreaSegment!) {
                    case DragAreaSegment.left:
                      widget.workspaceConfigs.paneManager.addPaneLeft(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.right:
                      widget.workspaceConfigs.paneManager.addPaneRight(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.bottom:
                      widget.workspaceConfigs.paneManager.addPaneBottom(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.top:
                      widget.workspaceConfigs.paneManager.addPaneTop(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.centre:
                      AffogatoEvents.editorPaneAddInstanceEvents.add(
                        EditorPaneAddInstanceEvent(
                          paneId: widget.paneId,
                          instanceId: details.data.instanceId,
                        ),
                      );
                      break;
                  }

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
                                widget.stylingConfigs.tabBarHeight),
                        decoration: BoxDecoration(
                          color: widget.workspaceConfigs.themeBundle.editorTheme
                              .editorBackground,
                          border: Border(
                            left: BorderSide(
                              color: widget.workspaceConfigs.themeBundle
                                      .editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                            right: BorderSide(
                              color: widget.workspaceConfigs.themeBundle
                                      .editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                            bottom: BorderSide(
                              color: widget.workspaceConfigs.themeBundle
                                      .editorTheme.panelBorder ??
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
                                    layoutConfigs: LayoutConfigs(
                                      width: widget.layoutConfigs.width,
                                      height: (instanceIds.isEmpty
                                              ? widget.layoutConfigs.height
                                              : widget.layoutConfigs.height -
                                                  widget.stylingConfigs
                                                      .tabBarHeight) -
                                          utils.AffogatoConstants
                                                  .tabBarPadding *
                                              2,
                                    ),
                                    editorTheme: widget.workspaceConfigs
                                        .themeBundle.editorTheme,
                                    extensionsEngine: widget.extensionsEngine,
                                  )
                                : Center(
                                    child: SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: Text(
                                        'Affogato',
                                        style: TextStyle(
                                          color: widget
                                              .workspaceConfigs
                                              .themeBundle
                                              .editorTheme
                                              .editorForeground,
                                        ),
                                      ),
                                    ),
                                  ),
                            if (isDragTarget && dragAreaSegment != null)
                              switch (dragAreaSegment!) {
                                DragAreaSegment.left => Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: widget.layoutConfigs.width * 0.5,
                                    child: Container(
                                      color: widget
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .buttonSecondaryHoverBackground,
                                    ),
                                  ),
                                DragAreaSegment.right => Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: widget.layoutConfigs.width * 0.5,
                                    child: Container(
                                      color: widget
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .buttonSecondaryHoverBackground,
                                    ),
                                  ),
                                DragAreaSegment.top => Positioned(
                                    left: 0,
                                    top: 0,
                                    right: 0,
                                    height: widget.layoutConfigs.height * 0.5,
                                    child: Container(
                                      color: widget
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .buttonSecondaryHoverBackground,
                                    ),
                                  ),
                                DragAreaSegment.bottom => Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    height: widget.layoutConfigs.height * 0.5,
                                    child: Container(
                                      color: widget
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .buttonSecondaryHoverBackground,
                                    ),
                                  ),
                                DragAreaSegment.centre => Positioned(
                                    child: Container(
                                      color: widget
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .buttonSecondaryHoverBackground,
                                    ),
                                  ),
                              }
                          ],
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

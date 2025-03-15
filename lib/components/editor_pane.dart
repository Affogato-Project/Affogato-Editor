part of affogato.editor;

/// An [EditorPane] corresponds to what VSCode calls the "EditorGroup".
class EditorPane extends StatefulWidget {
  final LayoutConfigs layoutConfigs;
  final AffogatoAPI api;
  final GlobalKey<AffogatoWindowState> windowKey;
  final String paneId;
  final String cellId;

  EditorPane({
    required this.cellId,
    required this.layoutConfigs,
    required this.api,
    required this.windowKey,
    required this.paneId,
  });
  // key: ValueKey( "${api.workspace.workspaceConfigs.panesData[paneId]}${layoutConfigs.width}-${layoutConfigs.height}-$paneId-$cellId")

  @override
  State<StatefulWidget> createState() => EditorPaneState();
}

enum DragAreaSegment { centre, left, right, top, bottom }

class EditorPaneState extends State<EditorPane>
    with utils.StreamSubscriptionManager {
  bool isDragTarget = false;
  DragAreaSegment? dragAreaSegment;

  @override
  void initState() {
    registerListener(
      widget.api.window.panes.requestReloadStream
          .where((event) => event.paneId == widget.paneId),
      (_) {
        setState(() {});
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
      widget.api.workspace.workspaceConfigs.instancesData[id] =
          AffogatoEditorInstanceData(
        documentId: entity.entityId,
        languageBundle: widget.api.workspace.workspaceConfigs.detectLanguage(
            widget.api.workspace.workspaceConfigs.vfs
                .accessEntity(entity.entityId)!
                .document!
                .extension),
        themeBundle: widget.api.workspace.workspaceConfigs.themeBundle,
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
        onTap: () =>
            widget.api.workspace.workspaceConfigs.activePane = widget.paneId,
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
            widget.api.workspace.workspaceConfigs.panesData[newPaneId] =
                PaneData(
              instances: createInstancesFromEntities(details.data),
            );
            switch (dragAreaSegment!) {
              case DragAreaSegment.left:
                widget.api.window.panes.addPaneLeft(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.right:
                widget.api.window.panes.addPaneRight(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.bottom:
                widget.api.window.panes.addPaneBottom(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.top:
                widget.api.window.panes.addPaneTop(
                  newPaneId: newPaneId,
                  anchorPaneId: widget.paneId,
                  anchorCellId: widget.cellId,
                );
                break;
              case DragAreaSegment.centre:
                widget.api.workspace.addInstancesToPane(
                  instanceIds: widget.api.workspace
                      .createEditorInstancesForEntities(entities: details.data),
                  paneId: widget.paneId,
                );
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
                  widget.api.editor
                      .closeInstance(instanceId: details.data.instanceId);

                  switch (dragAreaSegment!) {
                    case DragAreaSegment.left:
                      widget.api.window.panes.addPaneLeft(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.right:
                      widget.api.window.panes.addPaneRight(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.bottom:
                      widget.api.window.panes.addPaneBottom(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.top:
                      widget.api.window.panes.addPaneTop(
                        anchorPaneId: widget.paneId,
                        newPaneId: details.data.instanceId,
                        anchorCellId: widget.cellId,
                      );
                      break;
                    case DragAreaSegment.centre:
                      widget.api.workspace.addInstancesToPane(
                        instanceIds: [details.data.instanceId],
                        paneId: widget.paneId,
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
                      if (widget.api.workspace.workspaceConfigs
                          .panesData[widget.paneId]!.instances.isNotEmpty)
                        FileTabBar(
                          api: widget.api,
                          instanceIds: widget.api.workspace.workspaceConfigs
                              .panesData[widget.paneId]!.instances,
                          currentInstanceId: widget
                              .api
                              .workspace
                              .workspaceConfigs
                              .panesData[widget.paneId]!
                              .activeInstance,
                          paneId: widget.paneId,
                        ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: double.infinity,
                        height: (widget.api.workspace.workspaceConfigs
                                .panesData[widget.paneId]!.instances.isEmpty
                            ? widget.layoutConfigs.height
                            : widget.layoutConfigs.height -
                                widget.api.workspace.workspaceConfigs
                                    .stylingConfigs.tabBarHeight),
                        decoration: BoxDecoration(
                          color: widget.api.workspace.workspaceConfigs
                              .themeBundle.editorTheme.editorBackground,
                          border: Border(
                            left: BorderSide(
                              color: widget.api.workspace.workspaceConfigs
                                      .themeBundle.editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                            right: BorderSide(
                              color: widget.api.workspace.workspaceConfigs
                                      .themeBundle.editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                            bottom: BorderSide(
                              color: widget.api.workspace.workspaceConfigs
                                      .themeBundle.editorTheme.panelBorder ??
                                  Colors.red,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            widget
                                        .api
                                        .workspace
                                        .workspaceConfigs
                                        .panesData[widget.paneId]!
                                        .activeInstance !=
                                    null
                                ? AffogatoEditorInstance(
                                    api: widget.api,
                                    paneId: widget.paneId,
                                    instanceId: widget
                                        .api
                                        .workspace
                                        .workspaceConfigs
                                        .panesData[widget.paneId]!
                                        .activeInstance!,
                                    layoutConfigs: LayoutConfigs(
                                      width: widget.layoutConfigs.width,
                                      height: (widget
                                                  .api
                                                  .workspace
                                                  .workspaceConfigs
                                                  .panesData[widget.paneId]!
                                                  .instances
                                                  .isEmpty
                                              ? widget.layoutConfigs.height
                                              : widget.layoutConfigs.height -
                                                  widget
                                                      .api
                                                      .workspace
                                                      .workspaceConfigs
                                                      .stylingConfigs
                                                      .tabBarHeight) -
                                          utils.AffogatoConstants
                                                  .tabBarPadding *
                                              2,
                                    ),
                                    extensionsEngine:
                                        widget.api.extensions.engine,
                                  )
                                : Center(
                                    child: SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: Text(
                                        'Affogato',
                                        style: TextStyle(
                                          color: widget
                                              .api
                                              .workspace
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
                                          .api
                                          .workspace
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
                                          .api
                                          .workspace
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
                                          .api
                                          .workspace
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
                                          .api
                                          .workspace
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .buttonSecondaryHoverBackground,
                                    ),
                                  ),
                                DragAreaSegment.centre => Positioned(
                                    child: Container(
                                      color: widget
                                          .api
                                          .workspace
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

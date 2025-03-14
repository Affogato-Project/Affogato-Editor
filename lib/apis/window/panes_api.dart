part of affogato.apis;

class AffogatoPanesAPI extends AffogatoAPIComponent
    with utils.StreamSubscriptionManager {
  final Stream<WindowPaneLayoutChangedEvent> layoutChangedStream =
      AffogatoEvents.windowPaneLayoutChangedEventsController.stream;
  final Stream<WindowPaneRequestReloadEvent> requestReloadStream =
      AffogatoEvents.windowPaneRequestReloadEventsController.stream;

  AffogatoPanesAPI();

  @override
  void init() {
    // rebuild the panes layout
    registerListener(
      layoutChangedStream,
      (_) {
        /* 
        setState(() {
          final String paneId = utils.generateId();
          final tmp = widget.workspaceConfigs.paneManager.panesLayout;

          if (tmp is SinglePaneList) {
            widget.workspaceConfigs.paneManager.panesLayout = SinglePaneList(
              paneId,
              width: (widget.workspaceConfigs.isPrimaryBarExpanded
                      ? widget.workspaceConfigs.stylingConfigs.windowWidth -
                          (utils.AffogatoConstants.primaryBarExpandedWidth +
                              utils.AffogatoConstants.primaryBarClosedWidth)
                      : widget.workspaceConfigs.stylingConfigs.windowWidth -
                          utils.AffogatoConstants.primaryBarClosedWidth) -
                  3,
              height: widget.workspaceConfigs.stylingConfigs.windowHeight -
                  utils.AffogatoConstants.statusBarHeight,
              id: tmp.id,
            );
          } else if (tmp is HorizontalPaneList) {
            widget.workspaceConfigs.paneManager.panesLayout =
                HorizontalPaneList(
              tmp.value,
              width: (widget.workspaceConfigs.isPrimaryBarExpanded
                      ? widget.workspaceConfigs.stylingConfigs.windowWidth -
                          (utils.AffogatoConstants.primaryBarExpandedWidth +
                              utils.AffogatoConstants.primaryBarClosedWidth)
                      : widget.workspaceConfigs.stylingConfigs.windowWidth -
                          utils.AffogatoConstants.primaryBarClosedWidth) -
                  3,
              height: widget.workspaceConfigs.stylingConfigs.windowHeight -
                  utils.AffogatoConstants.statusBarHeight,
              id: tmp.id,
            );
          } else if (tmp is VerticalPaneList) {
            widget.workspaceConfigs.paneManager.panesLayout = VerticalPaneList(
              tmp.value,
              width: (widget.workspaceConfigs.isPrimaryBarExpanded
                      ? widget.workspaceConfigs.stylingConfigs.windowWidth -
                          (utils.AffogatoConstants.primaryBarExpandedWidth +
                              utils.AffogatoConstants.primaryBarClosedWidth)
                      : widget.workspaceConfigs.stylingConfigs.windowWidth -
                          utils.AffogatoConstants.primaryBarClosedWidth) -
                  3,
              height: widget.workspaceConfigs.stylingConfigs.windowHeight -
                  utils.AffogatoConstants.statusBarHeight,
              id: tmp.id,
            );
          }
          paneLayoutKey = UniqueKey();
        });
      */
      },
    );
  }

  /// This method should ONLY be called if the [AffogatoWorkspaceConfigs.paneManager.paneLayout] is not a [SinglePaneList]. Otherwise,
  /// call [addDefaultPane].
  ///
  /// [areaSegment] is the direction, relative to the pane given by [anchorPaneId], to which the new pane should be
  /// placed. This merely informs the computation of the actual [PaneData] of the
  /// *preference* for the new pane's placement. It may or may not be respected.
  void addPane({
    required List<String> instanceIds,
    required DragAreaSegment areaSegment,
    required String anchorPaneId,
  }) {}

  void addDefaultPane() {
    /*  if (api.workspace.workspaceConfigs.panesData.isEmpty) {
      final String paneId = utils.generateId();
      api.workspace.workspaceConfigs
        ..panesData[paneId] = PaneData(instances: [])
        ..paneManager = 
    } */
  }

  void initPaneManager(String paneId) {
    api.workspace.workspaceConfigs.paneManager = PaneManager.empty(
      rootPane: SinglePaneList(
        paneId,
        width: (api.workspace.workspaceConfigs.isPrimaryBarExpanded
                ? api.workspace.workspaceConfigs.stylingConfigs.windowWidth -
                    (utils.AffogatoConstants.primaryBarExpandedWidth +
                        utils.AffogatoConstants.primaryBarClosedWidth)
                : api.workspace.workspaceConfigs.stylingConfigs.windowWidth -
                    utils.AffogatoConstants.primaryBarClosedWidth) -
            3,
        height: api.workspace.workspaceConfigs.stylingConfigs.windowHeight -
            utils.AffogatoConstants.statusBarHeight,
      ),
    );
  }

  void removePane() {}
}

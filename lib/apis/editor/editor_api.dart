part of affogato.apis;

class AffogatoEditorAPI extends AffogatoAPIComponent {
  final Stream<EditorInstanceLoadedEvent> instanceLoadedStream =
      AffogatoEvents.editorInstanceLoadedEventsController.stream;
  final Stream<EditorInstanceClosedEvent> instanceClosedStream =
      AffogatoEvents.editorInstanceClosedEventsController.stream;
  final Stream<EditorKeyEvent> keyEventsStream =
      AffogatoEvents.editorKeyEventsController.stream;
  final Stream<EditorInstanceRequestReloadEvent> instanceRequestReloadStream =
      AffogatoEvents.editorInstanceRequestReloadEventsController.stream;
  final Stream<EditorInstanceRequestToggleSearchOverlayEvent>
      instanceRequestToggleSearchOverlay = AffogatoEvents
          .editorInstanceRequestToggleSearchOverlayEventsController.stream;

  AffogatoEditorAPI();
  @override
  init() {
    instanceLoadedStream.listen((event) {
      api.workspace
        ..workspaceConfigs.entitiesLocation[event.documentId] =
            (event.instanceId, event.paneId)
        ..setActivePaneFromInstance(event.instanceId);
    });
    instanceClosedStream.listen((event) {
      api.workspace.workspaceConfigs.entitiesLocation.removeWhere(
        (_, value) => event.instanceId == value.$1 && event.paneId == value.$2,
      );
    });
  }

  /// Visually, this is when the "x" icon of the instance's button on the [FileTabBar] is pressed
  /// 1. The instance will be removed from workspace data.
  /// 2. The instance will be unset as the active one.
  /// 3. A new instance will be chosen, if possible, to be the active one.
  void closeInstance({
    required String instanceId,
  }) {
    final String? paneId = api.workspace.workspaceConfigs.panesData.entries
        .where((entry) => entry.value.instances.contains(instanceId))
        .firstOrNull
        ?.key;
    if (paneId == null) {
      throw Exception('$instanceId is not in an existing pane');
    } else {
      int removeIndex = 0;
      // loop through each instanceId in the pane to determine the index of the instance to be removed
      // so that it can be used later on to set the next active instance
      for (int i = 0;
          i <
              api.workspace.workspaceConfigs.panesData[paneId]!.instances
                  .length;
          i++) {
        if (api.workspace.workspaceConfigs.panesData[paneId]!.instances[i] ==
            instanceId) {
          removeIndex = i;
          break;
        }
      }
      api.window.unsetActiveInstance(instanceId: instanceId);
      api.workspace.workspaceConfigs.panesData[paneId]!.instances
          .removeAt(removeIndex);
      if (removeIndex != 0) {
        api.window.setActiveInstance(
          paneId: paneId,
          instanceId: api.workspace.workspaceConfigs.panesData[paneId]!
              .instances[removeIndex - 1],
        );
      }
    }
    AffogatoEvents.editorInstanceClosedEventsController.add(
      EditorInstanceClosedEvent(
        instanceId: instanceId,
        paneId: paneId,
      ),
    );
  }

  /// Essentially, this causes the search-and-replace overlay to be toggled.
  /// 1. The instanceId of the active instance will be fetched.
  /// 2. The instance will be notified of the request.
  void requestCurrentInstanceToggleSearchOverlay() {
    if (api.workspace.workspaceConfigs.activeInstance != null) {
      AffogatoEvents.editorInstanceRequestToggleSearchOverlayEventsController
          .add(EditorInstanceRequestToggleSearchOverlayEvent(
              api.workspace.workspaceConfigs.activeInstance!));
    }
  }

  /// Calls to this method are extremely expensive since all the state-related data in
  /// the [AffogatoEditorInstanceState] is reloaded
  void requestInstanceReload(String instanceId) =>
      AffogatoEvents.editorInstanceRequestReloadEventsController
          .add(EditorInstanceRequestReloadEvent(instanceId));
}

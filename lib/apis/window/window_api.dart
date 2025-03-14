part of affogato.apis;

class AffogatoWindowAPI extends AffogatoAPIComponent {
  final AffogatoPanesAPI panes;
  final Stream<WindowClosedEvent> closedStream =
      AffogatoEvents.windowClosedEventsController.stream;
  final Stream<WindowStartupFinishedEvent> startupFinishedStream =
      AffogatoEvents.windowStartupFinishedEventsController.stream;
  final Stream<WindowRequestDocumentSetActiveEvent>
      requestDocumentSetActiveStream =
      AffogatoEvents.windowRequestDocumentSetActiveEventsController.stream;
  final Stream<WindowInstanceDidSetActiveEvent> instanceDidSetActive =
      AffogatoEvents.windowInstanceDidSetActiveEventsController.stream;
  final Stream<WindowInstanceDidUnsetActiveEvent> instanceDidUnsetActive =
      AffogatoEvents.windowInstanceDidUnsetActiveEventsController.stream;
  final Stream<WindowKeyboardEvent> keyboardEventStream =
      AffogatoEvents.windowKeyboardEventsController.stream;

  AffogatoWindowAPI({
    required this.panes,
  });

  @override
  void init() {
    panes
      ..api = api
      ..init();
  }

  /// Ensures, by any means, that the entity specified by [entityId] is shown. No checks are
  /// performed to verify that [entityId] points to a valid entity in the VFS.
  /// 1. Checks if any pane contains an instance with this document, creating an instance and assigning it to a pane otherwise
  /// 2. Requests the pane to set that instance as active, using [setActiveInstance]
  void requestDocumentSetActive(String entityId) {
    final String instanceToSetActive;
    if (!api.workspace.workspaceConfigs.entitiesLocation
        .containsKey(entityId)) {
      final entity = api.vfs.getEntityById(entityId);
      if (entity != null) {
        final List<String> instanceIds =
            api.workspace.createEditorInstancesForEntities(entities: [entity]);
        if (api.workspace.workspaceConfigs.panesData.isEmpty) {
          api.window.panes.addDefaultPane();
        }
        instanceToSetActive = instanceIds.first;
      } else {
        throw Exception('Entity ID $entityId is not a valid ID');
      }
    } else {
      instanceToSetActive =
          api.workspace.workspaceConfigs.entitiesLocation[entityId]!.$1;
    }

    api.window.setActiveInstance(
      instanceId: instanceToSetActive,
      paneId: api.workspace.workspaceConfigs.panesData.keys.first,
    );
  }

  /// Called when the instance given by [instanceId] is no longer the active instance.
  /// 1. Notifies listeners
  void unsetActiveInstance({
    required String instanceId,
  }) {
    AffogatoEvents.windowInstanceDidUnsetActiveEventsController.add(
      WindowInstanceDidUnsetActiveEvent(
        instanceId: instanceId,
      ),
    );
  }

  /// Called to set the instance given by [instanceId] as the active instance in the pane
  /// given by [paneId].
  /// 1. Adds the instanceId to the pane's data (if not already present)
  /// 2. Notifies listeners
  void setActiveInstance({
    required String instanceId,
    required String paneId,
  }) {
    if (!api.workspace.workspaceConfigs.panesData[paneId]!.instances
        .contains(instanceId)) {
      api.workspace
          .addInstancesToPane(instanceIds: [instanceId], paneId: paneId);
    }
    AffogatoEvents.windowPaneRequestReloadEventsController
        .add(WindowPaneRequestReloadEvent(paneId));
  }
}

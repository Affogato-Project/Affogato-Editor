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
      final entity = api.vfs.accessEntity(entityId);
      if (entity != null) {
        final List<String> instanceIds =
            api.workspace.createEditorInstancesForEntities(entities: [entity]);
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
  /// 1. Unsets the globally active instance
  /// 2. If [instanceId] is the active instance for its pane, it is unset as the active instance for that pane
  /// 3. Notifies listeners
  void unsetActiveInstance({
    required String instanceId,
  }) {
    String? paneId;
    api.workspace.workspaceConfigs.activeInstance = null;
    for (final pane in api.workspace.workspaceConfigs.panesData.entries) {
      if (pane.value.instances.contains(instanceId)) {
        paneId = pane.key;
        if (pane.value.activeInstance == instanceId) {
          api.workspace.workspaceConfigs.panesData[pane.key]!.activeInstance =
              null;
        }

        break;
      }
    }

    AffogatoEvents.windowInstanceDidUnsetActiveEventsController.add(
      WindowInstanceDidUnsetActiveEvent(
        instanceId: instanceId,
      ),
    );
    if (paneId != null) {
      AffogatoEvents.windowPaneRequestReloadEventsController
          .add(WindowPaneRequestReloadEvent(paneId));
    }
  }

  /// Called to set the instance given by [instanceId] as the active instance in the pane
  /// given by [paneId].
  /// 1. Adds the instanceId to the pane's data (if not already present)
  /// 2. Updates the globally active instance
  /// 3. Updates the active instance for the pane given by [paneId]
  /// 4. Notifies listeners
  void setActiveInstance({
    required String instanceId,
    required String paneId,
  }) {
    if (!api.workspace.workspaceConfigs.panesData[paneId]!.instances
        .contains(instanceId)) {
      api.workspace
          .addInstancesToPane(instanceIds: [instanceId], paneId: paneId);
    }
    api.workspace.workspaceConfigs
      ..activeInstance = instanceId
      ..panesData[paneId]!.activeInstance = instanceId;
    AffogatoEvents.windowPaneRequestReloadEventsController
        .add(WindowPaneRequestReloadEvent(paneId));
    AffogatoEvents.windowInstanceDidSetActiveEventsController
        .add(WindowInstanceDidSetActiveEvent(instanceId: instanceId));
  }
}

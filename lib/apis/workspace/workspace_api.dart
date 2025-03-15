part of affogato.apis;

class AffogatoWorkspaceAPI extends AffogatoAPIComponent {
  final AffogatoWorkspaceConfigs workspaceConfigs;

  AffogatoWorkspaceAPI({
    required this.workspaceConfigs,
  });

  @override
  void init() {}

  /// Sets the active pane as the one which contains [instanceId]
  String? setActivePaneFromInstance(String instanceId) {
    if (api.workspace.workspaceConfigs.activeInstance != null) {
      for (final pane in api.workspace.workspaceConfigs.panesData.entries) {
        if (pane.value.instances
            .contains(api.workspace.workspaceConfigs.activeInstance)) {
          return pane.key;
        }
      }
    }
    return null;
  }

  void setActivePane(String paneId) =>
      api.workspace.workspaceConfigs.activePane = paneId;

  /// Adds the speicified list of [instanceIds] to the panes data for the pane specified
  /// by [paneId].
  void addInstancesToPane({
    required List<String> instanceIds,
    required String paneId,
  }) {
    if (workspaceConfigs.panesData.containsKey(paneId)) {
      workspaceConfigs.panesData[paneId]!.instances.addAll(instanceIds);
    } else {
      throw Exception('Pane $paneId does not exist');
    }
  }

  /// 1. Creates [AffogatoEditorInstanceData] for each file entity in [entities]
  /// 2. Adds the instance data to the [workspaceConfigs.instancesData]
  /// 3. Returns the ID for each of the created instances
  List<String> createEditorInstancesForEntities({
    required List<AffogatoVFSEntity> entities,
  }) {
    final List<String> instanceIds = [];
    for (final entity in entities) {
      if (!entity.isDirectory) {
        final String instanceId = utils.generateId();
        workspaceConfigs.instancesData[instanceId] = AffogatoEditorInstanceData(
          documentId: entity.entityId,
          languageBundle: workspaceConfigs.detectLanguage(
              api.vfs.accessEntity(entity.entityId)!.document!.extension),
          themeBundle: workspaceConfigs.themeBundle,
        );
        instanceIds.add(instanceId);
      }
    }

    return instanceIds;
  }
}

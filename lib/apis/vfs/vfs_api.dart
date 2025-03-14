part of affogato.apis;

class AffogatoVFSAPI extends AffogatoAPIComponent {
  final Stream<VFSDocumentChangedEvent> documentChangedStream =
      AffogatoEvents.vfsDocumentChangedEventsController.stream;
  final Stream<VFSDocumentRequestChangeEvent> documentRequestChangeStream =
      AffogatoEvents.vfsDocumentRequestChangeEventsController.stream;
  final Stream<VFSStructureChangedEvent> structureChangedStream =
      AffogatoEvents.vfsStructureChangedEventsController.stream;

  AffogatoVFSAPI();

  @override
  void init() {}

  /// Applies the specified changes to the specified document in [event].
  void documentRequestChange(VFSDocumentRequestChangeEvent event) {
    AffogatoEvents.vfsDocumentRequestChangeEventsController.add(event);
  }

  AffogatoVFSEntity? getEntityById(String entityId) =>
      api.workspace.workspaceConfigs.vfs.accessEntity(entityId);
}

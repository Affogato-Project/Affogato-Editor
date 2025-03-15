part of affogato.apis;

final class AffogatoExtensionsAPI extends AffogatoAPIComponent {
  final AffogatoExtensionsEngine engine;

  AffogatoExtensionsAPI({
    required AffogatoExtensionsEngine extensionsEngine,
  }) : engine = extensionsEngine;

  @override
  void init() {
    engine.api = api;
    engine.init();
    api.window.startupFinishedStream.listen((_) {
      for (final ext in api.workspace.workspaceConfigs.extensions.where(
        (e) => e.bindTriggers.contains('startupFinished'),
      )) {
        api.extensions.register(ext);
        ext.loadExtension(api);
      }
    });
  }

  void deinit() {
    engine.deinit();
  }

  void register(AffogatoExtension extension) => engine.addExtension(extension);
}

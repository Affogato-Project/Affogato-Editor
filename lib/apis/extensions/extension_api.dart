part of affogato.apis;

enum ExtensionRuntime {
  /// Shared runtime with the editor, but on a separate thread. Only for extensions written natively in Dart.
  dart,
}

abstract class AffogatoExtension {
  final String name;
  final String displayName;
  final String id = generateId();
  final List<String> bindTriggers;
  final ExtensionRuntime runtime = ExtensionRuntime.dart;

  AffogatoExtension({
    required this.name,
    required this.displayName,
    required List<AffogatoBindTriggers> bindTriggers,
  }) : bindTriggers = bindTriggers.map((t) => t.id).toList();

  AffogatoExtension.fromVSCodeManifest(Map<String, Object?> json)
      : name = json['name'] as String,
        displayName = json['displayName'] as String,
        bindTriggers = (json['activationEvents'] as List).cast<String>();

  void loadExtension({
    required AffogatoFileManager fileManager,
  });
}

class AffogatoExtensionsAPI {
  final List<AffogatoExtension> _extensions = [];

  void register(AffogatoExtension extension) => _extensions.add(extension);
}

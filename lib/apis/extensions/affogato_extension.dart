part of affogato.apis;

enum ExtensionRuntime {
  /// Shared runtime with the editor, but on a separate thread. Only for extensions written natively in Dart.
  dart,
}

abstract class AffogatoExtension {
  final String name;
  final String displayName;
  final String id = utils.generateId();
  final List<String> bindTriggers;
  final ExtensionRuntime runtime = ExtensionRuntime.dart;

  AffogatoExtension({
    required this.name,
    required this.displayName,
    required this.bindTriggers,
  });

  AffogatoExtension.fromVSCodeManifest(Map<String, Object?> json)
      : name = json['name'] as String,
        displayName = json['displayName'] as String,
        bindTriggers = (json['activationEvents'] as List).cast<String>();

  void loadExtension(AffogatoAPI api);
}

/// This class is for extensions that override the default behaviour of keys when typing
/// into the editor. It is not to be confused with:
/// - [AffogatoKeybindingExtension], which registers keyboard sequences for keyboard shortcuts, triggered when editor text fields are not in focus or when initated with Command/Option keys
/// - [AffogatoExtension], the base class from which a standard extension is built. To override default key behaviour, the [AffogatoExtension] class is insufficient since
/// listening to the [AffogatoEvents] stream allows only for async processing, rather than the sync processing needed by the dispatcher to determine whether each key should be
/// sent to the TextField or not
///
/// The way this class is works is that the `base` modifier, a new feature in Dart 3.0, prevents the `loadExtension` method from being overriden. This is useful because the
/// type of trigger is already known in advance, and can be registered automatically along with some processing
abstract base class AffogatoEditorKeybindingExtension
    extends AffogatoExtension {
  final List<LogicalKeyboardKey>? keys;

  AffogatoEditorKeybindingExtension({
    required this.keys,
    required super.name,
    required super.displayName,
    required super.bindTriggers,
  });

  KeyEventResult handle({
    required AffogatoAPI api,
    required EditorKeyEvent editorKeyEvent,
  });

  @override
  void loadExtension(AffogatoAPI api) {}
}

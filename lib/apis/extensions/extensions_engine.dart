part of affogato.apis;

class AffogatoExtensionsEngine {
  static final Iterable<LogicalKeyboardKey> allKeys =
      LogicalKeyboardKey.knownLogicalKeys;

  final Map<String, List<StreamSubscription>> extensionListeners = {};

  final Map<LogicalKeyboardKey, AffogatoEditorKeybindingExtension>
      editorKeybindingExtensions = {};
  final List<AffogatoExtension> extensions = [];

  final AffogatoVFS vfs;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  AffogatoExtensionsEngine({
    required this.vfs,
    required this.workspaceConfigs,
  });

  registerEditorKeybindingExtension(AffogatoEditorKeybindingExtension ext) {
    for (final key in (ext.keys ?? allKeys)) {
      if (editorKeybindingExtensions.containsKey(key)) {
        print(
            "AEKB Extension '${ext.displayName}' tried to register editor key binding for '${key.keyLabel}' but it is already reserved by '${editorKeybindingExtensions[key]!.displayName}'.");
      } else {
        editorKeybindingExtensions[key] = ext;
      }
    }
  }

  KeyEventResult triggerEditorKeybindings(EditorKeyEvent event) {
    if (editorKeybindingExtensions.containsKey(event.keyEvent.logicalKey)) {
      return editorKeybindingExtensions[event.keyEvent.logicalKey]!.handle(
        editorKeyEvent: event,
        vfs: vfs,
        workspaceConfigs: workspaceConfigs,
      );
    } else {
      return KeyEventResult.ignored;
    }
  }

  void addExtension(AffogatoExtension ext) {
    if (ext is AffogatoEditorKeybindingExtension) {
      registerEditorKeybindingExtension(ext);
    }

    extensions.add(ext);
  }

  void deinit() async {
    for (final listeners in extensionListeners.values) {
      for (final hook in listeners) {
        await hook.cancel();
      }
    }
  }
}

part of affogato.editor;

class PaneData {
  final List<String> instances;
  String? activeInstance;

  PaneData({
    required this.instances,
    String? activeInstance,
  }) : activeInstance = activeInstance ?? instances.firstOrNull;
}

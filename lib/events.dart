part of affogato.editor;

class AffogatoEvents {
  static final StreamController<WindowEvent> windowEvents =
      StreamController.broadcast();
  static final StreamController<WindowEditorPaneAddEvent> editorPaneAddEvents =
      StreamController.broadcast();
  static final StreamController<WindowEditorInstanceSetActiveEvent>
      editorInstanceSetActiveEvents = StreamController.broadcast();
}

sealed class Event {
  final String eventId;

  const Event(this.eventId);
}

/// WINDOW EVENTS ///

class WindowEvent extends Event {
  const WindowEvent(String id) : super('window.$id');
}

class WindowEditorPaneEvent extends WindowEvent {
  const WindowEditorPaneEvent(String id) : super('editorPane.$id');
}

class WindowEditorPaneAddEvent extends WindowEditorPaneEvent {
  // final AffogatoDocument document;
  final LayoutConfigs layoutConfigs;

  const WindowEditorPaneAddEvent({
    required this.layoutConfigs,
  }) : super('add');
}

class WindowEditorInstanceEvent extends WindowEvent {
  const WindowEditorInstanceEvent(String id) : super('editorInstance.$id');
}

class WindowEditorInstanceSetActiveEvent extends WindowEditorInstanceEvent {
  final AffogatoDocument document;
  const WindowEditorInstanceSetActiveEvent({
    required this.document,
  }) : super('setActive');
}

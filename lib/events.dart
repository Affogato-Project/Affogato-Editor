part of affogato.editor;

class AffogatoEvents {
  static final StreamController<WindowEvent> windowEvents =
      StreamController.broadcast();
  static final StreamController<WindowCloseEvent> windowCloseEvents =
      StreamController.broadcast();
  static final StreamController<WindowEditorPaneAddEvent> editorPaneAddEvents =
      StreamController.broadcast();
  static final StreamController<WindowEditorInstanceSetActiveEvent>
      editorInstanceSetActiveEvents = StreamController.broadcast();

  static final StreamController<WindowEditorRequestDocumentSetActiveEvent>
      windowEditorRequestDocumentSetActiveEvents = StreamController.broadcast();

  static final StreamController<EditorInstanceCreateEvent>
      editorInstanceCreateEvents = StreamController.broadcast();

  static final StreamController<EditorInstanceLoadedEvent>
      editorInstanceLoadedEvents = StreamController.broadcast();
  static final StreamController<EditorKeyEvent> editorKeyEvent =
      StreamController.broadcast();
  static final StreamController<EditorDocumentChangedEvent>
      editorDocumentChangedEvents = StreamController.broadcast();

  static final StreamController<EditorDocumentClosedEvent>
      editorDocumentClosedEvents = StreamController.broadcast();

  static final StreamController<EditorPaneAddDocumentEvent>
      editorPaneAddDocumentEvents = StreamController.broadcast();

  static final StreamController<EditorInstanceRequestReloadEvent>
      editorInstanceRequestReloadEvents = StreamController.broadcast();
}

sealed class Event {
  final String eventId;

  const Event(this.eventId);
}

/// WINDOW EVENTS ///

class WindowEvent extends Event {
  const WindowEvent(String id) : super('window.$id');
}

class WindowCloseEvent extends WindowEvent {
  const WindowCloseEvent() : super('close');
}

class WindowEditorPaneEvent extends WindowEvent {
  const WindowEditorPaneEvent(String id) : super('editorPane.$id');
}

class WindowEditorPaneAddEvent extends WindowEditorPaneEvent {
  final EditorPane editorPane;

  const WindowEditorPaneAddEvent(this.editorPane) : super('add');
}

class WindowEditorInstanceEvent extends WindowEvent {
  const WindowEditorInstanceEvent(String id) : super('editorInstance.$id');
}

class WindowEditorInstanceSetActiveEvent extends WindowEditorInstanceEvent {
  final String paneId;
  final String documentId;
  const WindowEditorInstanceSetActiveEvent({
    required this.paneId,
    required this.documentId,
  }) : super('setActive');
}

class WindowEditorRequestDocumentSetActiveEvent
    extends WindowEditorInstanceEvent {
  final String documentId;
  const WindowEditorRequestDocumentSetActiveEvent({
    required this.documentId,
  }) : super('requestSetActive');
}

/// EDITOR AND DOCUMENT EVENTS ///

class EditorEvent extends Event {
  const EditorEvent(String id) : super('editor.$id');
}

class EditorInstanceEvent extends EditorEvent {
  const EditorInstanceEvent(String id) : super('instance.$id');
}

class EditorInstanceCreateEvent extends EditorInstanceEvent {
  const EditorInstanceCreateEvent() : super('create');
}

class EditorInstanceLoadedEvent extends EditorInstanceEvent {
  const EditorInstanceLoadedEvent() : super('loaded');
}

class EditorInstanceRequestReloadEvent extends EditorInstanceEvent {
  const EditorInstanceRequestReloadEvent() : super('reload');
}

class EditorKeyEvent extends EditorEvent {
  final Type keyEventType;
  final LogicalKeyboardKey key;

  const EditorKeyEvent({
    required this.key,
    required this.keyEventType,
  }) : super('key');
}

class EditorDocumentEvent extends EditorEvent {
  const EditorDocumentEvent(String id) : super('document.$id');
}

class EditorDocumentChangedEvent extends EditorDocumentEvent {
  final String newContent;

  const EditorDocumentChangedEvent(this.newContent) : super('change');
}

class EditorDocumentClosedEvent extends EditorDocumentEvent {
  final String documentId;
  final String paneId;

  const EditorDocumentClosedEvent({
    required this.documentId,
    required this.paneId,
  }) : super('close');
}

class EditorPaneEvent extends EditorEvent {
  const EditorPaneEvent(String id) : super('pane.$id');
}

class EditorPaneAddDocumentEvent extends EditorPaneEvent {
  final String paneId;
  final String documentId;

  const EditorPaneAddDocumentEvent({
    required this.paneId,
    required this.documentId,
  }) : super('addDoc');
}

part of affogato.editor;

class AffogatoEvents {
  static final StreamController<WindowCloseEvent> windowCloseEvents =
      StreamController.broadcast();
  static final StreamController<WindowEditorPaneAddEvent>
      windowEditorPaneAddEvents = StreamController.broadcast();
  static final StreamController<WindowEditorPaneRemoveEvent>
      windowEditorPaneRemoveEvents = StreamController.broadcast();
  static final StreamController<WindowEditorInstanceSetActiveEvent>
      editorInstanceSetActiveEvents = StreamController.broadcast();
  static final StreamController<WindowEditorInstanceUnsetActiveEvent>
      windowEditorInstanceUnsetActiveEvents = StreamController.broadcast();
  static final StreamController<WindowEditorRequestDocumentSetActiveEvent>
      windowEditorRequestDocumentSetActiveEvents = StreamController.broadcast();

  static final StreamController<WindowKeyboardEvent> windowKeyboardEvents =
      StreamController.broadcast();

  static final StreamController<EditorInstanceCreateEvent>
      editorInstanceCreateEvents = StreamController.broadcast();

  static final StreamController<EditorInstanceLoadedEvent>
      editorInstanceLoadedEvents = StreamController.broadcast();
  static final StreamController<EditorKeyEvent> editorKeyEvents =
      StreamController.broadcast();
  static final StreamController<EditorDocumentChangedEvent>
      editorDocumentChangedEvents = StreamController.broadcast();

  static final StreamController<EditorDocumentRequestChangeEvent>
      editorDocumentRequestChangeEvents = StreamController.broadcast();

  static final StreamController<EditorDocumentClosedEvent>
      editorDocumentClosedEvents = StreamController.broadcast();

  static final StreamController<EditorPaneAddDocumentEvent>
      editorPaneAddDocumentEvents = StreamController.broadcast();

  static final StreamController<EditorInstanceRequestReloadEvent>
      editorInstanceRequestReloadEvents = StreamController.broadcast();

  static final StreamController<EditorInstanceRequestToggleSearchOverlayEvent>
      editorInstanceRequestToggleSearchOverlayEvents =
      StreamController.broadcast();

  static final StreamController<FileManagerStructureChangedEvent>
      vfsStructureChangedEvents = StreamController.broadcast();
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
  final List<String> documentIds;
  const WindowEditorPaneAddEvent(this.documentIds) : super('add');
}

class WindowEditorPaneRemoveEvent extends WindowEditorPaneEvent {
  const WindowEditorPaneRemoveEvent() : super('remove');
}

class WindowEditorInstanceEvent extends WindowEvent {
  const WindowEditorInstanceEvent(String id) : super('editorInstance.$id');
}

class WindowEditorInstanceSetActiveEvent extends WindowEditorInstanceEvent {
  final String paneId;
  final String documentId;
  final LanguageBundle? languageBundle;

  const WindowEditorInstanceSetActiveEvent({
    required this.paneId,
    required this.documentId,
    required this.languageBundle,
  }) : super('setActive');
}

class WindowEditorInstanceUnsetActiveEvent extends WindowEditorInstanceEvent {
  final String paneId;
  final String documentId;

  const WindowEditorInstanceUnsetActiveEvent({
    required this.paneId,
    required this.documentId,
  }) : super('unsetActive');
}

class WindowEditorRequestDocumentSetActiveEvent
    extends WindowEditorInstanceEvent {
  final String documentId;
  const WindowEditorRequestDocumentSetActiveEvent({
    required this.documentId,
  }) : super('requestSetActive');
}

class WindowKeyboardEvent extends WindowEvent {
  final KeyEvent keyEvent;
  const WindowKeyboardEvent(this.keyEvent) : super('keyboard');
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
  final String documentId;
  const EditorInstanceLoadedEvent(this.documentId) : super('loaded');
}

class EditorInstanceRequestReloadEvent extends EditorInstanceEvent {
  const EditorInstanceRequestReloadEvent() : super('reload');
}

class EditorInstanceRequestToggleSearchOverlayEvent
    extends EditorInstanceEvent {
  final String documentId;
  const EditorInstanceRequestToggleSearchOverlayEvent(this.documentId)
      : super('requestToggleSearchOverlay');
}

class EditingContext {
  final String content;
  final TextSelection selection;

  const EditingContext({
    required this.content,
    required this.selection,
  });
}

class EditorKeyEvent extends EditorEvent {
  final KeyEvent keyEvent;
  final String documentId;
  final EditingContext editingContext;

  const EditorKeyEvent({
    required this.keyEvent,
    required this.documentId,
    required this.editingContext,
  }) : super('key');
}

class EditorDocumentEvent extends EditorEvent {
  const EditorDocumentEvent(String id) : super('document.$id');
}

enum DocumentChangeType { addition, deletion, overwrite }

class EditorDocumentChangedEvent extends EditorDocumentEvent {
  final String newContent;
  final String documentId;
  final TextSelection selection;

  const EditorDocumentChangedEvent({
    required this.newContent,
    required this.documentId,
    required this.selection,
  }) : super('change');
}

class EditorDocumentRequestChangeEvent extends EditorDocumentEvent {
  final EditorAction editorAction;

  const EditorDocumentRequestChangeEvent({
    required this.editorAction,
  }) : super('changeRequest');
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

/// FILE MANAGER EVENTS ///

class FileManagerEvent extends Event {
  const FileManagerEvent(String id) : super('vfs.$id');
}

class FileManagerStructureChangedEvent extends FileManagerEvent {
  const FileManagerStructureChangedEvent() : super('structureChanged');
}

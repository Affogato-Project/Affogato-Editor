part of affogato.editor;

/// AffogatoEvents forms the foundation of all communication and interaction in the Affogato Editor.
/// It is how actions are executed and how state is observed. However, actions are not meant to be performed directly
/// by adding events to streams in this class. Use the [AffogatoAPI], which groups events into specific tasks,
/// to perform actions safely. As for reading [Stream] events, while there is no issue with listening to streams from
/// this class directly, it is preferred that the [AffogatoAPI] is used for that purpose as well, just because it clearly
/// delineates different endpoints and for consistency.
///
/// There is a specific naming convention for each [Event]:
/// <area><label>Event
/// where `area` represents the specific part of the Affogato Editor that the event concerns, such as
/// "windowPane" or "editorInstance", etc. [Event]s from streams in this class can be of two categories:
/// 1. A *request* to perform an action
/// 2. A *notification* that an action has been performed
/// The `label` gives us information about the type of the event. The label for a request will start with
/// `request`, while the label for a notification will be in past tense. For example, "requestDocumentSetActive" is a request label,
/// while "documentChanged" or "instanceDidSetActive" are notification labels.
class AffogatoEvents {
  // WINDOW //
  /// Emitted whenever the [AffogatoWindow] is closed. Usually, the last event emitted
  /// before the whole widget is disposed.
  static final StreamController<WindowClosedEvent>
      windowClosedEventsController = StreamController.broadcast();

  /// Emitted after the [AffogatoWindow] is initialised and once extensions are ready to be loaded.
  static final StreamController<WindowStartupFinishedEvent>
      windowStartupFinishedEventsController = StreamController.broadcast();

  /* static final StreamController<WindowPaneReloadEvent>
      windowPaneRequestReloadEvents = StreamController.broadcast(); */

  /// Emitted whenever the layout of panes in the window changes.
  static final StreamController<WindowPaneLayoutChangedEvent>
      windowPaneLayoutChangedEventsController = StreamController.broadcast();

  /// Emitted whenever an instance has been set as the active instance
  static final StreamController<WindowInstanceDidSetActiveEvent>
      windowInstanceDidSetActiveEventsController = StreamController.broadcast();

  /// Emitted whenever an instance has been unset as the active instance
  static final StreamController<WindowInstanceDidUnsetActiveEvent>
      windowInstanceDidUnsetActiveEventsController =
      StreamController.broadcast();

  /// Emitted to request for a document to be set as the active instance, regardless
  /// of whether there is an instance associated with it or whether the instance is currently
  /// in any of the panes.
  static final StreamController<WindowRequestDocumentSetActiveEvent>
      windowRequestDocumentSetActiveEventsController =
      StreamController.broadcast();

  static final StreamController<WindowPaneRequestReloadEvent>
      windowPaneRequestReloadEventsController = StreamController.broadcast();
  /* /// Emitted to ask for a specific instance to be added to a specific pane.
  static final StreamController<WindowPaneRequestAddInstanceEvent>
      windowPaneRequestAddInstanceEventsController =
      StreamController.broadcast(); */

  /// Emitted for key presses while no instance is currently in focus. If an instance is
  /// in focus, listen instead for events on [editorKeyEventsController].
  static final StreamController<WindowKeyboardEvent>
      windowKeyboardEventsController = StreamController.broadcast();

  // EDITOR //
  /// Emitted when an instance has been loaded.
  static final StreamController<EditorInstanceLoadedEvent>
      editorInstanceLoadedEventsController = StreamController.broadcast();

  /// Emitted when an instance has been closed.
  static final StreamController<EditorInstanceClosedEvent>
      editorInstanceClosedEventsController = StreamController.broadcast();

  /// Emitted for key presses while focus is currently on the [TextField] of
  /// a specific instance.
  static final StreamController<EditorKeyEvent> editorKeyEventsController =
      StreamController.broadcast();

  /// Emitted to ask a specific instance to reload its state.
  static final StreamController<EditorInstanceRequestReloadEvent>
      editorInstanceRequestReloadEventsController =
      StreamController.broadcast();

  /// Emitted to ask a specific instance to toggle the search-and-replace overlay.
  static final StreamController<EditorInstanceRequestToggleSearchOverlayEvent>
      editorInstanceRequestToggleSearchOverlayEventsController =
      StreamController.broadcast();

  // VFS //
  /// Emitted when a specific document's contents have changed.
  static final StreamController<VFSDocumentChangedEvent>
      vfsDocumentChangedEventsController = StreamController.broadcast();

  /// Emitted to modify the contents of a specific document.
  static final StreamController<VFSDocumentRequestChangeEvent>
      vfsDocumentRequestChangeEventsController = StreamController.broadcast();

  /// Emitted when the directory structure of the VFS has changed.
  static final StreamController<VFSStructureChangedEvent>
      vfsStructureChangedEventsController = StreamController.broadcast();
}

sealed class Event {
  final String eventId;

  const Event(this.eventId);
}

/// WINDOW EVENTS ///

abstract class WindowEvent extends Event {
  const WindowEvent(String id) : super('window.$id');
}

/// This event is also a bind trigger, which means extensions can give this event's
/// ID as a bind trigger in the [AffogatoExtension.bindTriggers] property
class WindowStartupFinishedEvent extends WindowEvent {
  const WindowStartupFinishedEvent() : super('startupFinished');
}

class WindowClosedEvent extends WindowEvent {
  const WindowClosedEvent() : super('closed');
}

abstract class WindowPaneEvent extends WindowEvent {
  const WindowPaneEvent(String id) : super('pane.$id');
}

/// Indicates that a layout change has occurred and descendants of the cell given by
/// [cellId] need to be rebuilt. Each pane cell listens to events from this stream that have
/// their [cellId]. Once such an event is received, `setState` is called and that widget will then
/// emit more such [WindowPaneLayoutChangedEvent]s, one for each [cellId] in its immediate children.
class WindowPaneLayoutChangedEvent extends WindowPaneEvent {
  final String cellId;
  const WindowPaneLayoutChangedEvent(this.cellId) : super('layoutChanged');
}

/// Requests the pane specified by [paneId] to perform a reload of its state
class WindowPaneRequestReloadEvent extends WindowPaneEvent {
  final String paneId;
  const WindowPaneRequestReloadEvent(this.paneId) : super('requestReload');
}

abstract class WindowInstanceEvent extends WindowEvent {
  const WindowInstanceEvent(String id) : super('instance.$id');
}

class WindowRequestDocumentSetActiveEvent extends WindowInstanceEvent {
  final String documentId;
  final String? paneId;

  const WindowRequestDocumentSetActiveEvent({
    required this.documentId,
    required this.paneId,
  }) : super('requestDocumentSetActive');
}

class WindowInstanceDidSetActiveEvent extends WindowInstanceEvent {
  final String instanceId;

  const WindowInstanceDidSetActiveEvent({
    required this.instanceId,
  }) : super('didSetActive');
}

class WindowInstanceDidUnsetActiveEvent extends WindowInstanceEvent {
  final String instanceId;

  const WindowInstanceDidUnsetActiveEvent({
    required this.instanceId,
  }) : super('didUnsetActive');
}

class WindowKeyboardEvent extends WindowEvent {
  final KeyEvent keyEvent;
  const WindowKeyboardEvent(this.keyEvent) : super('keyboard');
}

/// EDITOR AND DOCUMENT EVENTS ///

abstract class EditorEvent extends Event {
  const EditorEvent(String id) : super('editor.$id');
}

abstract class EditorInstanceEvent extends EditorEvent {
  const EditorInstanceEvent(String id) : super('instance.$id');
}

/// The [instanceId] gives the ID of the instance that was loaded, the
/// [paneId] containing that instance, as well as the [documentId] being handled
/// by the instance.
class EditorInstanceLoadedEvent extends EditorInstanceEvent {
  final String paneId;
  final String instanceId;
  final String documentId;
  const EditorInstanceLoadedEvent({
    required this.instanceId,
    required this.paneId,
    required this.documentId,

  }) : super('loaded');
}

class EditorInstanceClosedEvent extends EditorInstanceEvent {
  final String instanceId;
  final String paneId;

  const EditorInstanceClosedEvent({
    required this.instanceId,
    required this.paneId,
  }) : super('closed');
}

class EditorInstanceRequestReloadEvent extends EditorInstanceEvent {
  final String instanceId;
  const EditorInstanceRequestReloadEvent(this.instanceId) : super('reload');
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
  final String instanceId;
  final EditingContext editingContext;

  const EditorKeyEvent({
    required this.keyEvent,
    required this.instanceId,
    required this.editingContext,
  }) : super('key');
}

enum DocumentChangeType { addition, deletion, overwrite }

/// FILE MANAGER EVENTS ///

abstract class VFSEvent extends Event {
  const VFSEvent(String id) : super('vfs.$id');
}

abstract class VFSDocumentEvent extends Event {
  const VFSDocumentEvent(String id) : super('document.$id');
}

class VFSStructureChangedEvent extends VFSEvent {
  const VFSStructureChangedEvent() : super('structureChanged');
}

class VFSDocumentChangedEvent extends VFSDocumentEvent {
  final String newContent;
  final String documentId;
  final TextSelection selection;

  const VFSDocumentChangedEvent({
    required this.newContent,
    required this.documentId,
    required this.selection,
  }) : super('documentChanged');
}

class VFSDocumentRequestChangeEvent extends VFSDocumentEvent {
  final String entityId;
  final EditorAction editorAction;

  const VFSDocumentRequestChangeEvent({
    required this.entityId,
    required this.editorAction,
  }) : super('documentRequestChange');
}

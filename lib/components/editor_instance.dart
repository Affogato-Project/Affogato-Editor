part of affogato.editor;

class AffogatoEditorInstance extends StatefulWidget {
  final String documentId;
  final AffogatoInstanceState? instanceState;
  final EditorTheme editorTheme;
  final double width;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  AffogatoEditorInstance({
    required this.documentId,
    required this.width,
    required this.editorTheme,
    required this.workspaceConfigs,
    this.instanceState,
  }) : super(
            key: ValueKey(
                '$documentId${instanceState?.hashCode}${editorTheme.hashCode}$width'));

  @override
  State<StatefulWidget> createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState extends State<AffogatoEditorInstance>
    with utils.StreamSubscriptionManager {
  final TextSelectionControls selectionControls =
      AffogatoTextSelectionControls();
  final TextEditingController textController = TextEditingController();
  late AffogatoInstanceState instanceState;
  final FocusNode keyboardListenerFocusNode = FocusNode();
  late AffogatoDocument currentDoc;

  static const double _lineNumbersColWidth = 40;

  @override
  void initState() {
    // All actions needed to spin up a new editor instance
    void loadUpInstance() {
      currentDoc = widget.workspaceConfigs.getDoc(widget.documentId);
      // Assume instant autosave
      textController.text = currentDoc.content;
      // Load or create instance state
      AffogatoInstanceState? newState;
      instanceState = widget.instanceState ??
          (newState = AffogatoInstanceState(
            cursorPos: 0,
            scrollHeight: 0,
            languageBundle: genericLB,
          ));
      if (newState != null) {
        AffogatoEvents.editorInstanceCreateEvents
            .add(const EditorInstanceCreateEvent());
      }

      // Set off the event
      AffogatoEvents.editorInstanceLoadedEvents
          .add(const EditorInstanceLoadedEvent());

      // Link the text controller to the document
      textController.addListener(() {
        currentDoc.addVersion(textController.text);
        AffogatoEvents.editorDocumentChangedEvents.add(
          EditorDocumentChangedEvent(
            newContent: textController.text,
            documentId: widget.documentId,
          ),
        );
        setState(() {});
      });
    }

    // Call once during initState
    loadUpInstance();

    // And register a listener to call whenever the instance needs to be reloaded
    registerListener(
      AffogatoEvents.editorInstanceRequestReloadEvents.stream,
      (event) {
        setState(() {
          // `saveInstance()`
          loadUpInstance();
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> lineNumbers = [];
    for (int i = 1; i <= currentDoc.content.split('\n').length; i++) {
      lineNumbers.add(SizedBox(
        width: _lineNumbersColWidth,
        height: 20,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            i.toString(),
            textAlign: TextAlign.right,
            style: TextStyle(
                color: widget.editorTheme.defaultTextColor.withOpacity(0.4)),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers
          Column(
            children: lineNumbers,
          ),
          // Git indicators
          Column(
            children: [],
          ),
          Expanded(
            child: KeyboardListener(
              focusNode: keyboardListenerFocusNode,
              onKeyEvent: (key) => AffogatoEvents.editorKeyEvent.add(
                EditorKeyEvent(
                  key: key.logicalKey,
                  keyEventType: key.runtimeType,
                ),
              ),
              child: TextField(
                maxLines: null,
                controller: textController,
                decoration: null,

                // selectionControls: selectionControls,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

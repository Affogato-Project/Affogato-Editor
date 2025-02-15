part of affogato.editor;

class AffogatoEditorInstance extends StatefulWidget {
  final AffogatoDocument document;
  final AffogatoInstanceState? instanceState;

  const AffogatoEditorInstance({
    required this.document,
    this.instanceState,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState extends State<AffogatoEditorInstance> {
  late AffogatoInstanceState instanceState;

  @override
  void initState() {
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
    AffogatoEvents.editorInstanceLoadEvents
        .add(const EditorInstanceLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> lineNumbers = [];
    for (int i = 1; i <= widget.document.srcContent.split('\n').length; i++) {
      lineNumbers.add(SizedBox(
        width: 40,
        height: 20,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            i.toString(),
            textAlign: TextAlign.right,
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
        ],
      ),
    );
  }
}

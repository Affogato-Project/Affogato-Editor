part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final double expandedWidth;
  final EditorTheme editorTheme;
  final List<AffogatoFileItem> items;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  PrimaryBar({
    required this.expandedWidth,
    required this.items,
    required this.editorTheme,
    required this.workspaceConfigs,
  }) : super(key: ValueKey(items));

  @override
  State<StatefulWidget> createState() => PrimaryBarState();
}

class PrimaryBarState extends State<PrimaryBar>
    with utils.StreamSubscriptionManager {
  bool expanded = true;
  List<QuartetButtonState> buttonStates = [];
  final List<bool> isExpanded = [];

  @override
  void initState() {
    buttonStates = List<QuartetButtonState>.generate(
      widget.items.length,
      (_) => QuartetButtonState.none,
    );
    isExpanded.addAll(List<bool>.generate(
      widget.items.length,
      (_) => false,
    ));

    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream,
      (event) {
        setState(() {
          final int i = widget.items.indexWhere((i) =>
              i is AffogatoDocumentItem && i.documentId == event.documentId);
          buttonStates = buttonStates
              .map((s) =>
                  s == QuartetButtonState.active ? QuartetButtonState.none : s)
              .toList();
          buttonStates[i] = QuartetButtonState.active;
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> primaryBarButtons = [];
    for (int i = 0; i < widget.items.length; i++) {
      primaryBarButtons.add(
        FileBrowserButton(
          buttonState: buttonStates[i],
          expanded: isExpanded[i],
          entry: widget.items[i],
          indent: 0,
          editorTheme: widget.editorTheme,
          workspaceConfigs: widget.workspaceConfigs,
          onEnter: (_) => setState(
            () => buttonStates[i] = buttonStates[i] == QuartetButtonState.none
                ? QuartetButtonState.hovered
                : buttonStates[i],
          ),
          onExit: (_) => setState(() {
            buttonStates[i] = buttonStates[i] == QuartetButtonState.pressed ||
                    buttonStates[i] == QuartetButtonState.active
                ? buttonStates[i]
                : QuartetButtonState.none;
          }),
          onTapUp: (_) => setState(() {
            if (widget.items[i] is AffogatoDirectoryItem) {
              buttonStates = buttonStates
                  .map((s) => s == QuartetButtonState.pressed
                      ? QuartetButtonState.none
                      : s)
                  .toList();
              buttonStates[i] = QuartetButtonState.pressed;
              isExpanded[i] = !isExpanded[i];
            } else {
              return;
            }
          }),
          onDoubleTap: () => setState(() {
            if (widget.items[i] is AffogatoDocumentItem) {
              buttonStates = buttonStates
                  .map((s) => s == QuartetButtonState.active
                      ? QuartetButtonState.none
                      : s)
                  .toList();
              buttonStates[i] = QuartetButtonState.active;
              isExpanded[i] = !isExpanded[i];
              AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.add(
                WindowEditorRequestDocumentSetActiveEvent(
                  documentId:
                      (widget.items[i] as AffogatoDocumentItem).documentId,
                ),
              );
            } else {
              return;
            }
          }),
        ),
      );
    }
    return expanded
        ? Container(
            width: widget.expandedWidth,
            height: double.infinity,
            decoration: BoxDecoration(
              color: widget.editorTheme.primaryBarColor,
              border: Border(
                left: BorderSide(
                  color: widget.editorTheme.borderColor,
                ),
                right: BorderSide(
                  color: widget.editorTheme.borderColor,
                ),
              ),
            ),
            child: ListView(
              children: primaryBarButtons,
            ),
          )
        : const SizedBox(width: 0, height: 0);
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    super.dispose();
  }
}

part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final double expandedWidth;
  final EditorTheme<Color, TextStyle> editorTheme;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  PrimaryBar({
    required this.expandedWidth,
    required this.editorTheme,
    required this.workspaceConfigs,
  }) : super(
            key: ValueKey(workspaceConfigs.fileManager.documentsRegistry.keys
                .followedBy(
                    workspaceConfigs.fileManager.directoriesRegistry.keys)));

  @override
  State<StatefulWidget> createState() => PrimaryBarState();
}

class PrimaryBarState extends State<PrimaryBar>
    with utils.StreamSubscriptionManager {
  bool expanded = true;

  @override
  void initState() {
    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream,
      (event) {
        setState(() {});
      },
    );

    registerListener(
      AffogatoEvents.editorDocumentClosedEvents.stream,
      (event) {
        setState(() {});
      },
    );

    registerListener(
      AffogatoEvents.fileManagerStructureChangedEvents.stream,
      (_) {
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return expanded
        ? Container(
            width: widget.expandedWidth,
            height: double.infinity,
            decoration: BoxDecoration(
              color: widget.editorTheme.panelBackground,
              border: Border(
                left: BorderSide(
                  color: widget.editorTheme.panelBorder ?? Colors.red,
                ),
                right: BorderSide(
                  color: widget.editorTheme.panelBorder ?? Colors.red,
                ),
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: FileBrowserButton(
                isRoot: true,
                entry: const AffogatoDirectoryItem('./'),
                indent: 0,
                editorTheme: widget.editorTheme,
                workspaceConfigs: widget.workspaceConfigs,
              ),
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

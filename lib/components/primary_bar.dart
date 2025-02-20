part of affogato.editor;

class PrimaryBar extends StatefulWidget {
  final double expandedWidth;
  final EditorTheme editorTheme;
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
  Map<String, QuartetButtonState> docButtonStates = {};
  Map<String, QuartetButtonState> dirButtonStates = {};
  final Map<String, bool> isExpanded = {};

  @override
  void initState() {
    docButtonStates.addAll({
      for (final doc
          in widget.workspaceConfigs.fileManager.documentsRegistry.entries)
        doc.key: QuartetButtonState.none,
    });
    dirButtonStates.addAll({
      for (final dir
          in widget.workspaceConfigs.fileManager.directoriesRegistry.entries)
        dir.key: QuartetButtonState.none,
    });

    isExpanded.addAll({
      for (final dir
          in widget.workspaceConfigs.fileManager.directoriesRegistry.entries)
        dir.key: false,
    });

    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream,
      (event) {
        setState(() {
          for (final s in docButtonStates.entries) {
            if (s.key == event.documentId) {
              docButtonStates[s.key] = QuartetButtonState.active;
            } else {
              docButtonStates[s.key] = QuartetButtonState.none;
            }
          }
        });
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

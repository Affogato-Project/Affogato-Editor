part of affogato.editor;

class StatusBar extends StatefulWidget {
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoStylingConfigs stylingConfigs;

  StatusBar({
    required this.stylingConfigs,
    required this.workspaceConfigs,
  }) : super(
            key: ValueKey(
                '${stylingConfigs.hashCode}${workspaceConfigs.hashCode}'));
  @override
  State<StatefulWidget> createState() => StatusBarState();
}

class StatusBarState extends State<StatusBar>
    with utils.StreamSubscriptionManager {
  String? currentDocumentId;
  LanguageBundle? currentLB;

  @override
  void initState() {
    registerListener(
      AffogatoEvents.editorInstanceSetActiveEvents.stream,
      (event) {
        setState(() {
          currentDocumentId = event.documentId;
          currentLB = event.languageBundle;
        });
      },
    );

/*     registerListener(
        AffogatoEvents.windowEditorInstanceUnsetActiveEvents.stream, (event) {
      setState(() {
        event.documentId;
        currentDocumentId = null;
      });
    }); */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: utils.AffogatoConstants.statusBarHeight,
      decoration: BoxDecoration(
        color: widget.stylingConfigs.themeBundle.editorTheme.panelBackground,
        border: Border.all(
          color: widget.stylingConfigs.themeBundle.editorTheme.panelBorder ??
              Colors.red,
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              AffogatoEvents.windowEditorPaneAddEvents
                  .add(WindowEditorPaneAddEvent([]));
            },
            child: Text(
              'Add Pane',
              style: TextStyle(
                color: widget
                    .stylingConfigs.themeBundle.editorTheme.editorForeground,
              ),
            ),
          ),
          const SizedBox(width: 20),
          TextButton(
            onPressed: () {
              AffogatoEvents.windowEditorPaneRemoveEvents
                  .add(const WindowEditorPaneRemoveEvent());
            },
            child: Text(
              'Remove Pane',
              style: TextStyle(
                color: widget
                    .stylingConfigs.themeBundle.editorTheme.editorForeground,
              ),
            ),
          ),
          const Spacer(),
          if (currentDocumentId != null && currentLB != null)
            TextButton(
              onPressed: () {
                AffogatoEvents.windowEditorPaneRemoveEvents
                    .add(const WindowEditorPaneRemoveEvent());
              },
              child: Text(
                currentLB!.bundleName,
                style: TextStyle(
                  color: widget
                      .stylingConfigs.themeBundle.editorTheme.editorForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}

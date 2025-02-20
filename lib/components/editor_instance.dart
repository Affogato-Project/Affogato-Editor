part of affogato.editor;

class AffogatoEditorInstance extends StatefulWidget {
  final String documentId;
  final AffogatoInstanceState? instanceState;
  final EditorTheme editorTheme;
  final double width;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoStylingConfigs stylingConfigs;
  final LanguageBundle languageBundle;
  final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter, Color,
      TextStyle> themeBundle;

  AffogatoEditorInstance({
    required this.documentId,
    required this.width,
    required this.editorTheme,
    required this.workspaceConfigs,
    required this.stylingConfigs,
    required this.languageBundle,
    required this.themeBundle,
    this.instanceState,
  }) : super(
            key: ValueKey(
                '$documentId${instanceState?.hashCode}${editorTheme.hashCode}$width${languageBundle.bundleName}'));

  @override
  State<StatefulWidget> createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState extends State<AffogatoEditorInstance>
    with utils.StreamSubscriptionManager {
  final ScrollController scrollController = ScrollController();
  late TextEditingController textController;
  late AffogatoInstanceState instanceState;
  final FocusNode textFieldFocusNode = FocusNode();
  late AffogatoDocument currentDoc;
  bool hasScrolled = false;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > 0 && !hasScrolled) {
        setState(() {
          hasScrolled = true;
        });
      } else if (scrollController.offset <= 0 && hasScrolled) {
        setState(() {
          hasScrolled = false;
        });
      }
    });

    // All actions needed to spin up a new editor instance
    void loadUpInstance() {
      textController = AffogatoEditorFieldController(
        languageBundle: widget.languageBundle,
        themeBundle: widget.themeBundle,
        stylingConfigs: widget.stylingConfigs,
      );
      currentDoc =
          widget.workspaceConfigs.fileManager.getDoc(widget.documentId);
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

    // the actual document parsing and interceptors
    registerListener(
      AffogatoEvents.editorKeyEvent.stream
          .where((e) => e.documentId == widget.documentId),
      (event) {
        if (event.keyEventType == KeyDownEvent) {
          textFieldFocusNode.requestFocus();

          if (event.key == LogicalKeyboardKey.tab) {
            setState(() {
              insertTextAtCursorPos(
                  ' ' * widget.workspaceConfigs.tabSizeInSpaces);
            });
          }
        }
      },
    );

    super.initState();
  }

  void insertTextAtCursorPos(String text, {bool moveCursorToEnd = true}) {
    if (textController.selection.isValid) {
      textController.value = TextEditingValue(
        text: textController.selection.isCollapsed
            ? textController.text.substring(0, textController.selection.start) +
                text +
                textController.text.substring(
                    textController.selection.end, textController.text.length)
            : textController.text.replaceRange(
                textController.selection.start,
                textController.selection.end,
                text,
              ),
        selection: moveCursorToEnd
            ? TextSelection.collapsed(
                offset: textController.selection.start + 4)
            : textController.selection,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> leftGutterIndicators = [];
    final List<Widget> lineNumbers = [];
    for (int i = 1; i <= currentDoc.content.split('\n').length; i++) {
      lineNumbers.add(
        SizedBox(
          width: utils.AffogatoConstants.lineNumbersColWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              i.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: widget.editorTheme.defaultTextColor.withOpacity(0.4),
                height: utils.AffogatoConstants.lineHeight,
                fontSize: widget.stylingConfigs.editorFontSize,
              ),
            ),
          ),
        ),
      );

      /* leftGutterIndicators.add(
        Padding(
          padding: const EdgeInsets.only(
              right: utils.AffogatoConstants.lineNumbersGutterRightmostPadding),
          child: Container(
            width: utils.AffogatoConstants.lineNumbersGutterWidth -
                utils.AffogatoConstants.lineNumbersGutterRightmostPadding,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: widget.editorTheme.defaultTextColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              '',
              textAlign: TextAlign.right,
              style: TextStyle(
                height: utils.AffogatoConstants.lineHeight,
                fontSize: widget.stylingConfigs.editorFontSize,
              ),
            ),
          ),
        ),
      ); */
    }
    return Stack(
      children: [
        Positioned(
          top: utils.AffogatoConstants.breadcrumbHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            controller: scrollController,
            hitTestBehavior: HitTestBehavior.translucent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers
                SizedBox(
                  width: utils.AffogatoConstants.lineNumbersColWidth,
                  child: Column(
                    children: [
                      ...lineNumbers,
                      const SizedBox(
                          height: utils.AffogatoConstants.overscrollAmount),
                    ],
                  ),
                ),
                // Left gutter indicators, such as for Git
                const SizedBox(
                  width: utils.AffogatoConstants.lineNumbersGutterWidth -
                      utils.AffogatoConstants.lineNumbersGutterRightmostPadding,
                  child: Column(),
                ),
                Expanded(
                  child: Focus(
                    onKeyEvent: (_, key) {
                      AffogatoEvents.editorKeyEvent.add(
                        EditorKeyEvent(
                          documentId: widget.documentId,
                          key: key.logicalKey,
                          keyEventType: key.runtimeType,
                        ),
                      );
                      return KeyEventResult.ignored;
                    },
                    child: Theme(
                      data: ThemeData(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: widget.editorTheme.defaultTextColor,
                          selectionColor: widget.editorTheme.defaultTextColor
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            focusNode: textFieldFocusNode,
                            maxLines: null,
                            controller: textController,
                            decoration: null,
                            style: TextStyle(
                              color: widget.editorTheme.defaultTextColor,
                              fontFamily: 'IBMPlexMono',
                              height: utils.AffogatoConstants.lineHeight,
                              fontSize: widget.stylingConfigs.editorFontSize,
                            ),
                          ),
                          MouseRegion(
                            opaque: false,
                            hitTestBehavior: HitTestBehavior.translucent,
                            cursor: SystemMouseCursors.text,
                            child: GestureDetector(
                              onTapUp: (_) {
                                textController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: textController.text.length),
                                );
                                textFieldFocusNode.requestFocus();
                              },
                              child: Container(
                                color: Colors.transparent,
                                width: double.infinity,
                                height:
                                    utils.AffogatoConstants.overscrollAmount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 5,
          right: 0,
          height: utils.AffogatoConstants.breadcrumbHeight,
          child: Container(
            width: double.infinity,
            height: utils.AffogatoConstants.breadcrumbHeight,
            decoration: BoxDecoration(
              color: widget.stylingConfigs.themeBundle.editorTheme.editorColor,
              boxShadow: hasScrolled
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [],
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.workspaceConfigs.fileManager
                        .getDocPath(widget.documentId) ??
                    'Unsaved',
                style: widget.editorTheme.defaultTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() async {
    textController.dispose();
    cancelSubscriptions();
    super.dispose();
  }
}

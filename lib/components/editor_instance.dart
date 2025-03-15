part of affogato.editor;

class AffogatoEditorInstanceData extends PaneInstanceData {
  final String documentId;
  final LanguageBundle? languageBundle;
  final ThemeBundle<dynamic, Color, TextStyle, TextSpan> themeBundle;

  AffogatoEditorInstanceData({
    required this.documentId,
    required this.languageBundle,
    required this.themeBundle,
  });
  @override
  Map<String, Object?> toJson() => {
        'documentId': documentId,
        'languageBundle': languageBundle?.bundleName ?? '',
        'themeBundle':
            themeBundle.editorTheme.toString(), // should be .toJson()
      };
}

class AffogatoEditorInstance extends PaneInstance<AffogatoEditorInstanceData> {
  AffogatoEditorInstance({
    required super.api,
    required super.paneId,
    required super.layoutConfigs,
    required super.extensionsEngine,
    required super.instanceId,
  });

  @override
  AffogatoEditorInstanceState createState() => AffogatoEditorInstanceState();
}

class AffogatoEditorInstanceState
    extends State<PaneInstance<AffogatoEditorInstanceData>>
    with
        utils.StreamSubscriptionManager,
        PaneInstanceStateManager<AffogatoEditorInstanceData>,
        SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AffogatoEditorFieldController textController;
  final FocusNode textFieldFocusNode = FocusNode();
  late final CompletionsController completionsController;
  late TextStyle codeTextStyle;
  late double cellWidth;
  late double cellHeight;
  bool hasScrolled = false;
  int currentLineNum = 0;
  int currentCharNum = 0;

  late final LocalSearchAndReplaceController searchAndReplaceController =
      LocalSearchAndReplaceController(
    tickerProvider: this,
    onDismiss: () {
      textFieldFocusNode.requestFocus();
      searchAndReplaceController.replaceText = null;
    },
    cellHeight: cellHeight,
    cellWidth: cellWidth,
    textController: textController,
  );

  @override
  void initState() {
    completionsController = CompletionsController(
      dictionary: [],
      refresh: setState,
      onAcceptAndDismiss: acceptAndDismissCompletionsWidget,
    );
    getData();
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
      codeTextStyle = TextStyle(
        color: widget.api.workspace.workspaceConfigs.themeBundle.editorTheme
            .editorForeground,
        fontFamily: 'IBMPlexMono',
        height: utils.AffogatoConstants.lineHeight,
        fontSize:
            widget.api.workspace.workspaceConfigs.stylingConfigs.editorFontSize,
      );
      // Create a single Text character using the editor's font style and paint it on an imaginary canvas
      // to observe its width and height. This massively increases performance as font-dependent spacing operations
      // such as generating indentation rulers or calculating cursor position no longer need to build and render multiple
      // Text() objects but rather, can use a predefined SizedBox() and even the calculated cellWidth and cellHeight for computations.
      final tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: ' ', style: codeTextStyle),
      )
        ..layout()
        ..paint(
          Canvas(PictureRecorder()),
          Offset.zero,
        );
      cellWidth = (tp.size.width);
      cellHeight = (tp.size.height);
      tp.dispose();

      textController = AffogatoEditorFieldController(
        languageBundle: data.languageBundle,
        themeBundle: data.themeBundle,
        workspaceConfigs: widget.api.workspace.workspaceConfigs,
      )..addListener(() {
          if (textController.text.isNotEmpty) {
            for (int i = textController.selection.baseOffset; i >= 1; i--) {
              if (textController.text[i - 1] == '\n') {
                currentCharNum = textController.selection.baseOffset - i;
                return;
              } else if (i == 1) {
                currentCharNum = textController.selection.baseOffset - i + 1;
                return;
              }
            }
          }
        });

      // Assume instant autosave
      textController.text =
          widget.api.vfs.accessEntity(data.documentId)!.document!.content;

      // Set up completions and LSP (if applicable)
      completionsController.dictionary.addAll(completionsController
          .parseAllWordsInDocument(content: textController.text));

      // Set off the event
      AffogatoEvents.editorInstanceLoadedEventsController.add(
        EditorInstanceLoadedEvent(
          documentId: data.documentId,
          instanceId: widget.instanceId,
          paneId: widget.paneId,
        ),
      );

      // Link the text controller to the document
      textController.addListener(() {
        widget.api.vfs.accessEntity(
          data.documentId,
          isDir: false,
          action: (entity) {
            if (entity != null) {
              entity.document!.addVersion(textController.text);
            }
          },
        );
        AffogatoEvents.vfsDocumentChangedEventsController.add(
          VFSDocumentChangedEvent(
            newContent: textController.text,
            documentId: data.documentId,
            selection: textController.selection,
            originId: widget.instanceId,
          ),
        );
        setState(() {});
      });

      registerListener(
        widget.api.vfs.documentChangedStream.where((event) =>
            event.documentId == data.documentId &&
            event.originId != widget.instanceId),
        (event) {
          setState(() {
            textController.text = widget.api.vfs
                .accessEntity(data.documentId, isDir: false)!
                .document!
                .content;
          });
        },
      );

      // the actual document parsing and interceptors
      registerListener(
        widget.api.editor.keyEventsStream
            .where((e) => e.instanceId == widget.instanceId),
        (event) {
          if (event.keyEvent is KeyDownEvent) {
            textFieldFocusNode.requestFocus();

            if (event.keyEvent.logicalKey == LogicalKeyboardKey.tab) {
              setState(() {
                insertTextAtCursorPos(' ' *
                    widget.api.workspace.workspaceConfigs.stylingConfigs
                        .tabSizeInSpaces);
              });
            }

            setState(() {
              completionsController.registerTextChanged(
                content: textController.text,
                selection: textController.selection,
                keyEvent: event.keyEvent,
              );
            });
          }
        },
      );

      registerListener(
        widget.api.vfs.documentRequestChangeStream,
        (event) {
          textController.value = event.editorAction.editingValue;
          setState(() {});
          AffogatoEvents.vfsDocumentChangedEventsController.add(
            VFSDocumentChangedEvent(
              newContent: textController.text,
              documentId: data.documentId,
              selection: textController.selection,
              originId: widget.instanceId,
            ),
          );
        },
      );

      registerListener(
        widget.api.editor.instanceRequestToggleSearchOverlay
            .where((event) => event.documentId == data.documentId),
        (_) => setState(() {
          searchAndReplaceController.toggle();
        }),
      );
    }

    // Call once during initState
    loadUpInstance();

    // And register a listener to call whenever the instance needs to be reloaded
    registerListener(
      widget.api.editor.instanceRequestReloadStream,
      (event) {
        setState(() {
          // `saveInstance()`
          loadUpInstance();
        });
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

  List<Row> generateIndentationRulers() {
    final List<Row> rows = [];
    // this flag allows a single indentation ruler to be added to the
    // start of lines inside a nested code snippet, such as a function body, even
    // if they are empty lines
    bool isNested = false;
    for (final line in textController.text.split('\n')) {
      // create an initial Row
      final List<Widget> rowItems = [Text('', style: codeTextStyle)];
      // only trigger the loop if there is a possbility of indentation
      if (line.startsWith(' ')) {
        isNested = true;
        for (int i = 0; i < line.length; i++) {
          if (line[i] == ' ') {
            // add an indentation ruler at every tab
            if (i %
                    widget.api.workspace.workspaceConfigs.stylingConfigs
                        .tabSizeInSpaces ==
                0) {
              rowItems.add(
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 0.5,
                        color: widget.api.workspace.workspaceConfigs.themeBundle
                                .editorTheme.editorIndentGuideBackground1 ??
                            Colors.red,
                      ),
                    ),
                  ),
                  child: SizedBox(
                      width: cellWidth *
                          widget.api.workspace.workspaceConfigs.stylingConfigs
                              .tabSizeInSpaces,
                      height: cellHeight),
                ),
              );
            }
          } else {
            break;
          }
        }
      } else {
        isNested = false;
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: line.trim() == '' && !isNested
              ? [
                  SizedBox(
                    width: 0,
                    height: cellHeight,
                  )
                ]
              : rowItems,
        ),
      );
    }

    return rows;
  }

  List<Widget> generateLineNumbers() {
    final List<Widget> lineNumbers = [];
    final int activeLineNum = textController.text
        .substring(0, textController.selection.end)
        .split('\n')
        .length;
    currentLineNum = activeLineNum;
    for (int i = 1; i <= textController.text.split('\n').length; i++) {
      lineNumbers.add(
        SizedBox(
          width: utils.AffogatoConstants.lineNumbersColWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              i.toString(),
              textAlign: TextAlign.right,
              style: codeTextStyle.copyWith(
                color: i == activeLineNum
                    ? widget.api.workspace.workspaceConfigs.themeBundle
                        .editorTheme.editorLineNumberActiveForeground
                    : widget.api.workspace.workspaceConfigs.themeBundle
                        .editorTheme.editorLineNumberForeground,
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
                  color: widget.api.workspace.workspaceConfigs.themeBundle.editorTheme.defaultTextColor.withOpacity(0.1),
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
    return lineNumbers;
  }

  /// Generates the Git diff indicators and code folding buttons.
  List<Widget> generateLeftGutterWidgets() {
    const List<Widget> results = [];

    return results;
  }

  void acceptAndDismissCompletionsWidget(String insertText) {
    final String textBefore =
        textController.selection.textBefore(textController.text);
    textController.value = TextEditingValue(
      text: textBefore +
          insertText +
          textController.selection.textAfter(textController.text),
      selection: TextSelection.collapsed(
        offset: (textBefore + insertText).length,
      ),
    );
    AffogatoEvents.vfsDocumentChangedEventsController.add(
      VFSDocumentChangedEvent(
        newContent: textController.text,
        documentId: data.documentId,
        selection: textController.selection,
        originId: widget.instanceId,
      ),
    );
    textFieldFocusNode.requestFocus();
    setState(() {
      completionsController.showingCompletions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.layoutConfigs.width,
      height: widget.layoutConfigs.height,
      child: Stack(
        children: [
          // Editing Area
          Positioned(
            top: utils.AffogatoConstants.breadcrumbHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: scrollController,
              hitTestBehavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  // Decorations Area — for decorations below the editing layer
                  ...searchAndReplaceController.searchAndReplaceMatchHighlights,
                  Positioned(
                    left: utils.AffogatoConstants.lineNumbersColWidth +
                        utils.AffogatoConstants.lineNumbersGutterWidth,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: generateIndentationRulers(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Line numbers
                      SizedBox(
                        width: utils.AffogatoConstants.lineNumbersColWidth,
                        child: Column(
                          children: [
                            ...generateLineNumbers(),
                            const SizedBox(
                                height:
                                    utils.AffogatoConstants.overscrollAmount),
                          ],
                        ),
                      ),
                      // Left gutter indicators, such as for Git
                      SizedBox(
                        width: utils.AffogatoConstants.lineNumbersGutterWidth -
                            utils.AffogatoConstants
                                .lineNumbersGutterRightmostPadding,
                        child: Column(
                          children: generateLeftGutterWidgets(),
                        ),
                      ),
                      // Editing Field
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus) {
                              widget.api.workspace
                                  .setActivePaneFromInstance(widget.instanceId);
                            }
                          },
                          onKeyEvent: (_, key) {
                            if (searchAndReplaceController.isShown) {
                              searchAndReplaceController.dismiss();
                            }
                            if (completionsController.handleKeyEvent(key) ==
                                KeyEventResult.handled) {
                              return KeyEventResult.handled;
                            }
                            final EditorKeyEvent keyEvent = EditorKeyEvent(
                              instanceId: widget.instanceId,
                              keyEvent: key,
                              editingContext: EditingContext(
                                content: widget.api.vfs
                                    .accessEntity(data.documentId,
                                        isDir: false)!
                                    .document!
                                    .content,
                                selection: textController.selection,
                              ),
                            );

                            AffogatoEvents.editorKeyEventsController
                                .add(keyEvent);

                            return widget.extensionsEngine
                                .triggerEditorKeybindings(keyEvent);
                          },
                          child: Theme(
                            data: ThemeData(
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor: widget
                                    .api
                                    .workspace
                                    .workspaceConfigs
                                    .themeBundle
                                    .editorTheme
                                    .editorForeground,
                                selectionColor: widget
                                        .api
                                        .workspace
                                        .workspaceConfigs
                                        .themeBundle
                                        .editorTheme
                                        .editorSelectionHighlightBackground ??
                                    Colors.red,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  selectionControls:
                                      EmptyTextSelectionControls(),
                                  readOnly: widget.api.vfs
                                      .accessEntity(data.documentId,
                                          isDir: false)!
                                      .document!
                                      .readOnly,
                                  focusNode: textFieldFocusNode,
                                  maxLines: null,
                                  controller: textController,
                                  decoration: null,
                                  style: codeTextStyle.copyWith(
                                      color: widget
                                          .api
                                          .workspace
                                          .workspaceConfigs
                                          .themeBundle
                                          .editorTheme
                                          .textPreformatForeground),
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
                                      height: utils
                                          .AffogatoConstants.overscrollAmount,
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
                ],
              ),
            ),
          ),
          // Overlays Area (hover suggestions, completions UI)
          if (scrollController.hasClients &&
              completionsController.showingCompletions)
            Positioned(
              top: utils.AffogatoConstants.breadcrumbHeight +
                  textController.text
                          .substring(0, textController.selection.baseOffset)
                          .split('\n')
                          .length *
                      cellHeight -
                  scrollController.offset,
              left: utils.AffogatoConstants.lineNumbersColWidth +
                  utils.AffogatoConstants.lineNumbersGutterWidth +
                  currentCharNum * cellWidth,
              width: utils.AffogatoConstants.completionsMenuWidth,
              child: AffogatoCompletionsWidget(
                editorTheme: widget
                    .api.workspace.workspaceConfigs.themeBundle.editorTheme,
                controller: completionsController,
              ),
            ),
          // Search-and-replace overlays
          Positioned(
            top: utils.AffogatoConstants.breadcrumbHeight,
            right: utils.AffogatoConstants.breadcrumbHeight + 5,
            child: SlideTransition(
              position:
                  searchAndReplaceController.searchAndReplaceOffsetAnimation,
              child: SearchAndReplaceWidget(
                api: widget.api,
                key: searchAndReplaceController.overlayKey,
                width: utils.AffogatoConstants.searchAndReplaceWidgetWidth,
                textStyle: codeTextStyle,
                onSearchTextChanged: (newText) {
                  searchAndReplaceController.regenerateMatches(
                      newText: newText);
                  setState(() {});
                },
                onReplaceTextChanged: (newText) {
                  searchAndReplaceController.replaceText = newText;
                },
                searchActionItems: [
                  Text(
                    "${searchAndReplaceController.searchItemCurrentIndex} of ${searchAndReplaceController.matches.length}",
                    style: widget.api.workspace.workspaceConfigs.themeBundle
                        .editorTheme.defaultTextStyle
                        .copyWith(
                      color: widget.api.workspace.workspaceConfigs.themeBundle
                          .editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    api: widget.api,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController
                        ..prevMatch()
                        ..scrollIfActiveMatchOutsideViewport(
                          scrollOffset: scrollController.offset,
                          viewportHeight: widget.layoutConfigs.height -
                              utils.AffogatoConstants.breadcrumbHeight,
                          scrollCallback: scrollController.jumpTo,
                        );
                    }),
                    child: Icon(
                      Icons.arrow_upward,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.api.workspace.workspaceConfigs.themeBundle
                          .editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    api: widget.api,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController
                        ..nextMatch()
                        ..scrollIfActiveMatchOutsideViewport(
                          scrollOffset: scrollController.offset,
                          viewportHeight: widget.layoutConfigs.height -
                              utils.AffogatoConstants.breadcrumbHeight,
                          scrollCallback: scrollController.jumpTo,
                        );
                    }),
                    child: Icon(
                      Icons.arrow_downward,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.api.workspace.workspaceConfigs.themeBundle
                          .editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    api: widget.api,
                    isPrimary: false,
                    onTap: () {
                      searchAndReplaceController.dismiss();
                      textFieldFocusNode.requestFocus();
                    },
                    child: Icon(
                      Icons.close,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.api.workspace.workspaceConfigs.themeBundle
                          .editorTheme.buttonSecondaryForeground,
                    ),
                  )
                ],
                replaceActionItems: [
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    api: widget.api,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController.replaceCurrentMatch();
                    }),
                    child: Icon(
                      Icons.keyboard_return,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.api.workspace.workspaceConfigs.themeBundle
                          .editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AffogatoButton(
                    width:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    height:
                        utils.AffogatoConstants.searchAndReplaceRowItemHeight -
                            10,
                    api: widget.api,
                    isPrimary: false,
                    onTap: () => setState(() {
                      searchAndReplaceController.replaceAllMatches();
                    }),
                    child: Icon(
                      Icons.restore_page,
                      size: utils
                              .AffogatoConstants.searchAndReplaceRowItemHeight -
                          10,
                      color: widget.api.workspace.workspaceConfigs.themeBundle
                          .editorTheme.buttonSecondaryForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Breadcrumb Widget
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: utils.AffogatoConstants.breadcrumbHeight,
            child: Container(
              width: double.infinity,
              height: utils.AffogatoConstants.breadcrumbHeight,
              decoration: BoxDecoration(
                color: widget.api.workspace.workspaceConfigs.themeBundle
                    .editorTheme.editorBackground,
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
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.api.vfs.pathToEntity(data.documentId) ?? 'Unsaved',
                    style: widget.api.workspace.workspaceConfigs.themeBundle
                        .editorTheme.defaultTextStyle
                        .copyWith(
                            fontSize: widget.api.workspace.workspaceConfigs
                                    .stylingConfigs.editorFontSize -
                                3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    searchAndReplaceController.searchAndReplaceAnimationController.dispose();
    textController.dispose();
    cancelSubscriptions();
    super.dispose();
  }
}

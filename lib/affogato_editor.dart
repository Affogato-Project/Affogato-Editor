library affogato.editor;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:affogato_editor/apis/affogato_apis.dart';
import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;
import 'package:affogato_editor/lsp/lsp_client.dart' as lsp;
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';

part './editor_core/configs.dart';
part './editor_core/events.dart';
part './editor_core/editor_actions.dart';
part './editor_core/pane_instance_data.dart';
part './editor_core/pane_data.dart';
part 'editor_core/pane_list.dart';
part './editor_core/virtual_file_system.dart';
part './editor_core/core_extensions.dart';
part './editor_core/keyboard_shortcuts.dart';

part './lsp/lsp.dart';

part './components/shared/context_menu_region.dart';
part './components/shared/search_and_replace_widget.dart';
part './components/shared/button.dart';

part './components/file_tree_icons/icons_map.dart';
part './components/file_tree_icons/seti_ui_icondata.dart';

part './components/editor_pane.dart';
part './components/pane_instance.dart';
part './components/pane_layout_cell_widget.dart';
part './components/file_tab_bar.dart';
part './components/file_tab.dart';
part './components/editor_instance.dart';
part './components/editor_field_controller.dart';
part './components/primary_bar.dart';
part './components/file_browser_button.dart';
part './components/status_bar.dart';
part './components/completions.dart';
part './components/local_search_and_replace.dart';

part './syntax_highlighter/syntax_highlighter.dart';

class AffogatoWindow extends StatefulWidget {
  final AffogatoPerformanceConfigs performanceConfigs;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  const AffogatoWindow({
    required this.performanceConfigs,
    required this.workspaceConfigs,
    super.key,
  });

  @override
  State<AffogatoWindow> createState() => AffogatoWindowState();
}

class AffogatoWindowState extends State<AffogatoWindow>
    with utils.StreamSubscriptionManager {
  final GlobalKey<AffogatoWindowState> windowKey = GlobalKey();
  final FocusNode keyboardListenerFocusNode = FocusNode();
  late final AffogatoAPI api;

  @override
  void initState() {
    // Set up the [AffogatoAPI], which should always be the first step
    api = AffogatoAPI(
      extensions: AffogatoExtensionsAPI(
        extensionsEngine: AffogatoExtensionsEngine(
          workspaceConfigs: widget.workspaceConfigs,
        ),
      ),
      window: AffogatoWindowAPI(
        panes: AffogatoPanesAPI(),
      ),
      editor: AffogatoEditorAPI(),
      vfs: AffogatoVFSAPI(),
      workspace:
          AffogatoWorkspaceAPI(workspaceConfigs: widget.workspaceConfigs),
    );
    api.init();

    // Request for attention to the global [KeyboardListener] that catches
    // non-editor keyboard shortcuts
    keyboardListenerFocusNode.requestFocus();

    // Register built-in keyboard shortcuts
    registerBuiltInKeyboardShortcuts();

    // since the editor must always have at least one pane

    api.window.panes
        .addDefaultPane(api.workspace.workspaceConfigs.panesData.keys.first);

    // in order to show our own context menu, this achieves the `e.preventDefault()`
    // behaviour for every right-click action
    BrowserContextMenu.disableContextMenu();

    // initialise the virtual file system
    api.vfs.createEntity(
      AffogatoVFSEntity.dir(
        entityId: utils.generateId(),
        name: 'Dir_1',
        files: [
          AffogatoVFSEntity.file(
            entityId: utils.generateId(),
            doc: AffogatoDocument(
              docName: 'main.dart',
              srcContent: '// this is a comment',
              maxVersioningLimit: 5,
            ),
          ),
        ],
        subdirs: [
          AffogatoVFSEntity.dir(
            entityId: utils.generateId(),
            name: 'inside',
            files: [
              AffogatoVFSEntity.file(
                entityId: utils.generateId(),
                doc: AffogatoDocument(
                  docName: 'MyDoc.md',
                  srcContent: '# Hello',
                  maxVersioningLimit: 5,
                ),
              ),
              AffogatoVFSEntity.file(
                entityId: utils.generateId(),
                doc: AffogatoDocument(
                  docName: 'some_script.js',
                  srcContent: 'function f() => 2;',
                  maxVersioningLimit: 5,
                ),
              ),
            ],
            subdirs: [],
          ),
        ],
      ),
    );

    // finally, notify that the window has been started up
    AffogatoEvents.windowStartupFinishedEventsController
        .add(const WindowStartupFinishedEvent());

    // AffogatoEvents.editorInstanceSetActiveEvents.stream
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: windowKey,
      child: KeyboardListener(
        focusNode: keyboardListenerFocusNode,
        onKeyEvent: (event) => AffogatoEvents.windowKeyboardEventsController
            .add(WindowKeyboardEvent(event)),
        child: GestureDetector(
          onTap: () => ContextMenuController.removeAny(),
          child: Container(
            width: widget.workspaceConfigs.stylingConfigs.windowWidth,
            height: widget.workspaceConfigs.stylingConfigs.windowHeight,
            decoration: BoxDecoration(
              color: widget
                  .workspaceConfigs.themeBundle.editorTheme.panelBackground,
              border: Border.all(
                color: widget
                        .workspaceConfigs.themeBundle.editorTheme.panelBorder ??
                    Colors.red,
              ),
            ),
            child: SizedBox(
              width: widget.workspaceConfigs.stylingConfigs.windowWidth,
              height: widget.workspaceConfigs.stylingConfigs.windowHeight,
              child: Column(
                children: [
                  SizedBox(
                    width: widget.workspaceConfigs.stylingConfigs.windowWidth,
                    height:
                        widget.workspaceConfigs.stylingConfigs.windowHeight -
                            utils.AffogatoConstants.statusBarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PrimaryBar(api: api),
                        PaneLayoutCellWidget(
                          api: api,
                          cellId: api.workspace.workspaceConfigs.panesLayout.id,
                          performanceConfigs: widget.performanceConfigs,
                          windowKey: windowKey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: utils.AffogatoConstants.statusBarHeight,
                    child: StatusBar(
                      api: api,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    BrowserContextMenu.enableContextMenu();
    AffogatoEvents.windowClosedEventsController.add(const WindowClosedEvent());
    cancelSubscriptions();
    await AffogatoEvents.windowStartupFinishedEventsController.close();
    await AffogatoEvents.windowPaneCellLayoutChangedEventsController.close();
    await AffogatoEvents.windowPaneCellRequestReloadEventsController.close();
    await AffogatoEvents.windowPaneRequestReloadEventsController.close();
    await AffogatoEvents.windowInstanceDidSetActiveEventsController.close();
    await AffogatoEvents.windowInstanceDidUnsetActiveEventsController.close();
    await AffogatoEvents.windowRequestDocumentSetActiveEventsController.close();
    await AffogatoEvents.windowKeyboardEventsController.close();
    await AffogatoEvents.editorInstanceLoadedEventsController.close();
    await AffogatoEvents.editorInstanceClosedEventsController.close();
    await AffogatoEvents.editorKeyEventsController.close();
    await AffogatoEvents.editorInstanceRequestReloadEventsController.close();
    await AffogatoEvents
        .editorInstanceRequestToggleSearchOverlayEventsController
        .close();
    await AffogatoEvents.vfsDocumentChangedEventsController.close();
    await AffogatoEvents.vfsDocumentRequestChangeEventsController.close();
    await AffogatoEvents.vfsStructureChangedEventsController.close();
    await AffogatoEvents.windowClosedEventsController.close();
    super.dispose();
  }

  void registerBuiltInKeyboardShortcuts() {
    api.extensions.engine.shortcutsDispatcher
      ..overrideShortcut(
        [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyB],
        api.editor.requestCurrentInstanceToggleSearchOverlay,
      )
      ..overrideShortcut(
        [LogicalKeyboardKey.metaRight, LogicalKeyboardKey.keyB],
        api.editor.requestCurrentInstanceToggleSearchOverlay,
      );
  }
}

final List<AffogatoExtension> affogatoCoreExtensions = [
  PairMatcherExtension(),
  AutoIndenterExtension(),
];

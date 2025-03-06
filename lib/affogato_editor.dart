library affogato.editor;

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:affogato_editor/apis/affogato_apis.dart';
import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';

part './editor_core/configs.dart';
part './editor_core/events.dart';
part './editor_core/editor_actions.dart';
part './editor_core/pane_instance_data.dart';
part './editor_core/pane_data.dart';
part './editor_core/pane_layout_cell.dart';
part './editor_core/virtual_file_system.dart';
part './editor_core/core_extensions.dart';
part './editor_core/keyboard_shortcuts.dart';

part './components/shared/context_menu_region.dart';
part './components/shared/search_and_replace_widget.dart';
part './components/shared/button.dart';

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
  late final AffogatoExtensionsEngine extensionsEngine;
  late final AffogatoExtensionsAPI extensionsApi;
  late final AffogatoAPI api;

  @override
  void initState() {
    keyboardListenerFocusNode.requestFocus();

    extensionsEngine = AffogatoExtensionsEngine(
      vfs: widget.workspaceConfigs.vfs,
      workspaceConfigs: widget.workspaceConfigs,
    );
    // Register built-in keyboard shortcuts
    registerBuiltInKeyboardShortcuts();

    extensionsApi = AffogatoExtensionsAPI(extensionsEngine: extensionsEngine);
    api = AffogatoAPI(
      extensions: extensionsApi,
    );

    widget.workspaceConfigs.paneLayoutData = PaneLayoutCell.horizontal(
      horizontalChildren: [],
      width: widget.workspaceConfigs.stylingConfigs.windowWidth -
          utils.AffogatoConstants.primaryBarWidth -
          1,
      height: widget.workspaceConfigs.stylingConfigs.windowHeight -
          utils.AffogatoConstants.statusBarHeight,
    );

    BrowserContextMenu.disableContextMenu();
    widget.workspaceConfigs.vfs.createEntity(
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

    registerListener(
      AffogatoEvents.windowEditorPaneRequestAddEvents.stream,
      (event) {
        setState(() {
          final String paneId = utils.generateId();
          widget.workspaceConfigs.panesData[paneId] =
              PaneData(instances: event.instanceIds);
        });
      },
    );
    // initial set up of the editor based on the workspace configs
    if (widget.workspaceConfigs.panesData.isEmpty) {
      AffogatoEvents.windowEditorPaneAddedEvents.add(
        WindowEditorPaneAddedEvent(PaneData(instances: [])),
      );
    } else {
      for (final entry in widget.workspaceConfigs.panesData.entries) {
        AffogatoEvents.windowEditorPaneAddedEvents
            .add(WindowEditorPaneAddedEvent(entry.value));
      }
    }

    registerListener(
      AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.stream,
      (event) {
        String? instanceIdWithDocument;
        for (final entry in widget.workspaceConfigs.instancesData.entries) {
          // whereType<MapEntry<String, AffogatoEditorInstanceData>>()
          if (entry.value is AffogatoEditorInstanceData) {
            final value = entry.value as AffogatoEditorInstanceData;

            if (value.documentId == event.documentId) {
              instanceIdWithDocument = entry.key;
              break;
            }
          }
        }
        if (instanceIdWithDocument == null) {
          instanceIdWithDocument = utils.generateId();
          widget.workspaceConfigs.instancesData[instanceIdWithDocument] =
              AffogatoEditorInstanceData(
            documentId: event.documentId,
            languageBundle: widget.workspaceConfigs.detectLanguage(widget
                .workspaceConfigs.vfs
                .accessEntity(event.documentId)!
                .document!
                .extension),
            themeBundle: widget.workspaceConfigs.themeBundle,
          );

          if (widget.workspaceConfigs.panesData.isEmpty) {
            final String paneId = utils.generateId();
            widget.workspaceConfigs.addPane(
              paneId: paneId,
              paneData: PaneData(instances: [instanceIdWithDocument]),
              layoutCell: PaneLayoutCell.horizontal(
                horizontalChildren: [(null, paneId)],
                width: widget.workspaceConfigs.stylingConfigs.windowWidth -
                    utils.AffogatoConstants.primaryBarWidth -
                    1,
                height: widget.workspaceConfigs.stylingConfigs.windowHeight -
                    utils.AffogatoConstants.statusBarHeight -
                    2,
              ),
            );
          } else {
            widget.workspaceConfigs.panesData.entries.first.value.instances
                .add(instanceIdWithDocument);
          }
        }
        AffogatoEvents.editorInstanceSetActiveEvents.add(
            WindowEditorInstanceSetActiveEvent(
                instanceId: instanceIdWithDocument));
        setState(() {});
      },
    );

    registerListener(
      AffogatoEvents.editorDocumentChangedEvents.stream,
      (event) {
        widget.workspaceConfigs.vfs
            .accessEntity(event.documentId)!
            .document!
            .addVersion(event.newContent);
      },
    );

    // listen to pane removal events
    registerListener(
      AffogatoEvents.windowEditorPaneRemoveEvents.stream,
      (_) {
        bool hasRemovedPane = false;
        // maintain the pane ID which has the least # of docs in it
        String paneWithLeastDocs =
            widget.workspaceConfigs.panesData.entries.first.key;
        int paneDocsCount = widget
            .workspaceConfigs.panesData.entries.first.value.instances.length;
        for (final pane in widget.workspaceConfigs.panesData.entries) {
          if (pane.value.instances.isEmpty) {
            hasRemovedPane = true;
            for (final instanceId in pane.value.instances) {
              AffogatoEvents.windowEditorInstanceClosedEvents.add(
                WindowEditorInstanceClosedEvent(
                    instanceId: instanceId, paneId: pane.key),
              );
            }
            widget.workspaceConfigs.removePane(pane.key);
            break;
          } else {
            if (pane.value.instances.length < paneDocsCount) {
              paneDocsCount = pane.value.instances.length;
              paneWithLeastDocs = pane.key;
            }
          }
        }
        if (!hasRemovedPane) {
          for (final docId in widget
              .workspaceConfigs.panesData[paneWithLeastDocs]!.instances) {
            AffogatoEvents.windowEditorInstanceClosedEvents.add(
              WindowEditorInstanceClosedEvent(
                  instanceId: docId, paneId: paneWithLeastDocs),
            );
          }
          // remove the pane with the least number of docs
          widget.workspaceConfigs.removePane(paneWithLeastDocs);
        }
        setState(() {});
      },
    );

    // listen to document closing events
    registerListener(
      AffogatoEvents.windowEditorInstanceClosedEvents.stream,
      (event) {
        widget.workspaceConfigs.panesData[event.paneId]!.instances
            .remove(event.instanceId);
        AffogatoEvents.windowEditorInstanceUnsetActiveEvents.add(
          WindowEditorInstanceUnsetActiveEvent(
            paneId: event.paneId,
            instanceId: event.instanceId,
          ),
        );
      },
    );

    // finally, register the extensions bound to the onStartupFinished trigger
    for (final ext in widget.workspaceConfigs.extensions.where(
      (e) => e.bindTriggers
          .contains(const AffogatoBindTriggers.onStartupFinished().id),
    )) {
      api.extensions.register(ext);
      ext.loadExtension(
        vfs: widget.workspaceConfigs.vfs,
        workspaceConfigs: widget.workspaceConfigs,
      );
    }

    // AffogatoEvents.editorInstanceSetActiveEvents.stream
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: windowKey,
      child: KeyboardListener(
        focusNode: keyboardListenerFocusNode,
        onKeyEvent: (event) =>
            AffogatoEvents.windowKeyboardEvents.add(WindowKeyboardEvent(event)),
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
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: utils.AffogatoConstants.primaryBarWidth,
                        child: PrimaryBar(
                          expandedWidth:
                              utils.AffogatoConstants.primaryBarWidth,
                          workspaceConfigs: widget.workspaceConfigs,
                          editorTheme:
                              widget.workspaceConfigs.themeBundle.editorTheme,
                        ),
                      ),
                      PaneLayoutCellWidget(
                        cell: widget.workspaceConfigs.paneLayoutData,
                        workspaceConfigs: widget.workspaceConfigs,
                        extensionsEngine: extensionsEngine,
                        performanceConfigs: widget.performanceConfigs,
                        windowKey: windowKey,
                      ), /* Row(
                          children: [
                            for (final pane
                                in widget.workspaceConfigs.panesData.entries)
                              EditorPane(
                                key: ValueKey('${pane.key}${pane.value}'),
                                paneId: pane.key,
                                stylingConfigs:
                                    widget.workspaceConfigs.stylingConfigs,
                                layoutConfigs: LayoutConfigs(
                                  width: double.infinity,
                                  height: widget.workspaceConfigs.stylingConfigs
                                          .windowHeight -
                                      utils.AffogatoConstants.statusBarHeight -
                                      2,
                                ),
                                extensionsEngine: extensionsEngine,
                                performanceConfigs: widget.performanceConfigs,
                                workspaceConfigs: widget.workspaceConfigs,
                                windowKey: windowKey,
                              ),
                          ],
                        ), */
                    ],
                  ),
                ),
                SizedBox(
                  height: utils.AffogatoConstants.statusBarHeight,
                  child: StatusBar(
                    stylingConfigs: widget.workspaceConfigs.stylingConfigs,
                    workspaceConfigs: widget.workspaceConfigs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    BrowserContextMenu.enableContextMenu();
    AffogatoEvents.windowCloseEvents.add(const WindowCloseEvent());
    cancelSubscriptions();
    extensionsEngine.deinit();
    await AffogatoEvents.windowEditorPaneRequestAddEvents.close();
    await AffogatoEvents.windowEditorPaneAddedEvents.close();
    await AffogatoEvents.editorInstanceSetActiveEvents.close();
    await AffogatoEvents.windowEditorPaneRemoveEvents.close();
    await AffogatoEvents.editorInstanceSetActiveEvents.close();
    await AffogatoEvents.windowEditorInstanceUnsetActiveEvents.close();
    await AffogatoEvents.windowKeyboardEvents.close();
    await AffogatoEvents.editorInstanceCreateEvents.close();
    await AffogatoEvents.editorInstanceLoadedEvents.close();
    await AffogatoEvents.editorKeyEvents.close();
    await AffogatoEvents.editorDocumentChangedEvents.close();
    await AffogatoEvents.editorDocumentRequestChangeEvents.close();
    await AffogatoEvents.windowEditorInstanceClosedEvents.close();
    await AffogatoEvents.editorPaneAddInstanceEvents.close();
    await AffogatoEvents.editorInstanceRequestReloadEvents.close();
    await AffogatoEvents.editorInstanceRequestToggleSearchOverlayEvents.close();
    await AffogatoEvents.vfsStructureChangedEvents.close();
    await AffogatoEvents.windowCloseEvents.close();
    super.dispose();
  }

  void registerBuiltInKeyboardShortcuts() {
    extensionsEngine.shortcutsDispatcher
      ..overrideShortcut(
        [LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.keyB],
        requestEditorInstanceShowFindOverlay,
      )
      ..overrideShortcut(
        [LogicalKeyboardKey.metaRight, LogicalKeyboardKey.keyB],
        requestEditorInstanceShowFindOverlay,
      );
  }

  void requestEditorInstanceShowFindOverlay() async {
    if (widget.workspaceConfigs.activeDocument == null) {
      return;
    } else {
      AffogatoEvents.editorInstanceRequestToggleSearchOverlayEvents.add(
        EditorInstanceRequestToggleSearchOverlayEvent(
          widget.workspaceConfigs.activeDocument!,
        ),
      );
    }
  }

/*   PaneData computeNewPaneLayout({
    required WindowEditorPaneRequestAddEvent request,
    required double panesAreaWidth,
    required double panesAreaHeight,
  }) {
    if (widget.workspaceConfigs.panesData.isEmpty) {
      return PaneData(
        instances: request.instanceIds,
        position: const Offset(0, 0),
        width: panesAreaWidth,
        height: panesAreaHeight,
      );
    } else {
      switch (request.areaSegment) {
        case DragAreaSegment.top:
          return;
        case DragAreaSegment.bottom:
          return;
        case DragAreaSegment.left:
          return;
        case DragAreaSegment.right:
          return;
        case DragAreaSegment.center:
          return;
      }
    }
  } */
}

final List<AffogatoExtension> affogatoCoreExtensions = [
  PairMatcherExtension(),
  AutoIndenterExtension(),
];

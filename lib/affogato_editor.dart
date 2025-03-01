library affogato.editor;

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/status.dart' as WSStatus;

import 'package:affogato_editor/apis/affogato_apis.dart';
import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';

part './editor_core/configs.dart';
part './editor_core/events.dart';
part './editor_core/editor_actions.dart';
part './editor_core/instance_state.dart';
part './editor_core/virtual_file_system.dart';
part './editor_core/core_extensions.dart';

part './components/editor_pane.dart';
part './components/file_tab_bar.dart';
part './components/editor_instance.dart';
part './components/editor_field_controller.dart';
part './components/primary_bar.dart';
part './components/file_browser_button.dart';
part './components/status_bar.dart';
part './components/shared/context_menu_region.dart';
part './components/completions.dart';

part './syntax_highlighter/syntax_highlighter.dart';

part './lsp/lsp.dart';

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

  late final AffogatoExtensionsEngine extensionsEngine;
  late final AffogatoExtensionsAPI extensionsApi;
  late final AffogatoAPI api;

  @override
  void initState() {
    extensionsEngine = AffogatoExtensionsEngine(
      vfs: widget.workspaceConfigs.vfs,
      workspaceConfigs: widget.workspaceConfigs,
    );
    extensionsApi = AffogatoExtensionsAPI(extensionsEngine: extensionsEngine);
    api = AffogatoAPI(
      extensions: extensionsApi,
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
      AffogatoEvents.windowEditorPaneAddEvents.stream,
      (event) {
        setState(() {
          final String paneId = utils.generateId();
          widget.workspaceConfigs.paneDocumentData[paneId] = event.documentIds;
        });
      },
    );
    // initial set up of the editor based on the workspace configs
    if (widget.workspaceConfigs.paneDocumentData.isEmpty) {
      AffogatoEvents.windowEditorPaneAddEvents
          .add(WindowEditorPaneAddEvent([]));
    } else {
      for (final entry in widget.workspaceConfigs.paneDocumentData.entries) {
        AffogatoEvents.windowEditorPaneAddEvents
            .add(WindowEditorPaneAddEvent(entry.value));
      }
    }
    // listens to requests to focus the instance containing the specified document
    // and creates the instance if it doesn't yet exist
    registerListener(
      AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.stream,
      (event) {
        final LanguageBundle languageBundle;
        bool hasBeenSetActive = false;
        for (final entry in widget.workspaceConfigs.paneDocumentData.entries) {
          if (entry.value.contains(event.documentId)) {
            hasBeenSetActive = true;
            // Respond by emitting the event that triggers the corresponding pane
            // to make the specified document active
            AffogatoEvents.editorInstanceSetActiveEvents.add(
              WindowEditorInstanceSetActiveEvent(
                paneId: entry.key,
                documentId: event.documentId,
                languageBundle: widget.workspaceConfigs.detectLanguage(widget
                    .workspaceConfigs.vfs
                    .accessEntity(event.documentId)!
                    .document!
                    .extension),
              ),
            );
          }
        }

        // if no current panes contain the document
        if (!hasBeenSetActive) {
          final MapEntry<String, List<String>> firstPane =
              widget.workspaceConfigs.paneDocumentData.entries.first;
          // modify the first pane's document list to include the new document
          firstPane.value.add(event.documentId);
          // trigger the event to make said pane activate the document
          AffogatoEvents.editorInstanceSetActiveEvents.add(
            WindowEditorInstanceSetActiveEvent(
              paneId: firstPane.key,
              documentId: event.documentId,
              languageBundle: widget.workspaceConfigs.detectLanguage(widget
                  .workspaceConfigs.vfs
                  .accessEntity(event.documentId)!
                  .document!
                  .extension),
            ),
          );
        }
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
            widget.workspaceConfigs.paneDocumentData.entries.first.key;
        int paneDocsCount =
            widget.workspaceConfigs.paneDocumentData.entries.first.value.length;
        for (final pane in widget.workspaceConfigs.paneDocumentData.entries) {
          if (pane.value.isEmpty) {
            hasRemovedPane = true;
            for (final docId in pane.value) {
              AffogatoEvents.editorDocumentClosedEvents.add(
                EditorDocumentClosedEvent(documentId: docId, paneId: pane.key),
              );
            }
            widget.workspaceConfigs.paneDocumentData.remove(pane.key);
            break;
          } else {
            if (pane.value.length < paneDocsCount) {
              paneDocsCount = pane.value.length;
              paneWithLeastDocs = pane.key;
            }
          }
        }
        if (!hasRemovedPane) {
          for (final docId
              in widget.workspaceConfigs.paneDocumentData[paneWithLeastDocs]!) {
            AffogatoEvents.editorDocumentClosedEvents.add(
              EditorDocumentClosedEvent(
                  documentId: docId, paneId: paneWithLeastDocs),
            );
          }
          // remove the pane with the least number of docs
          widget.workspaceConfigs.paneDocumentData.remove(paneWithLeastDocs);
        }
        setState(() {});
      },
    );

    // listen to document closing events
    registerListener(
      AffogatoEvents.editorDocumentClosedEvents.stream,
      (event) {
        widget.workspaceConfigs.paneDocumentData[event.paneId]!
            .remove(event.documentId);
        AffogatoEvents.windowEditorInstanceUnsetActiveEvents.add(
          WindowEditorInstanceUnsetActiveEvent(
            paneId: event.paneId,
            documentId: event.documentId,
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: windowKey,
      child: GestureDetector(
        onTap: () => ContextMenuController.removeAny(),
        child: Container(
          width: widget.workspaceConfigs.stylingConfigs.windowWidth,
          height: widget.workspaceConfigs.stylingConfigs.windowHeight,
          decoration: BoxDecoration(
            color:
                widget.workspaceConfigs.themeBundle.editorTheme.panelBackground,
            border: Border.all(
              color:
                  widget.workspaceConfigs.themeBundle.editorTheme.panelBorder ??
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
                        expandedWidth: utils.AffogatoConstants.primaryBarWidth,
                        workspaceConfigs: widget.workspaceConfigs,
                        editorTheme:
                            widget.workspaceConfigs.themeBundle.editorTheme,
                      ),
                    ),
                    SizedBox(
                      width:
                          widget.workspaceConfigs.stylingConfigs.windowWidth -
                              utils.AffogatoConstants.primaryBarWidth -
                              1,
                      child: Row(
                        children: [
                          for (final pane in widget
                              .workspaceConfigs.paneDocumentData.entries)
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
                              documentIds: pane.value,
                              windowKey: windowKey,
                            ),
                        ],
                      ),
                    ),
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
    );
  }

  @override
  void dispose() async {
    BrowserContextMenu.enableContextMenu();
    cancelSubscriptions();
    AffogatoEvents.windowCloseEvents.add(const WindowCloseEvent());
    extensionsEngine.deinit();
    await AffogatoEvents.windowEditorPaneAddEvents.close();
    await AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.close();
    // ... //
    await AffogatoEvents.windowCloseEvents.close();
    super.dispose();
  }
}

final List<AffogatoExtension> affogatoCoreExtensions = [
  PairMatcherExtension(),
  AutoIndenterExtension(),
];

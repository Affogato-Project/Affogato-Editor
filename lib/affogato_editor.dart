library affogato.editor;

import 'dart:async';

import 'package:affogato_editor/apis/affogato_apis.dart';
import 'package:affogato_editor/battery_themes/affogato_classic/theme_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;

part './editor_core/configs.dart';
part './editor_core/events.dart';
part './editor_core/editor_actions.dart';
part './editor_core/instance_state.dart';
part './editor_core/file_manager.dart';
part './editor_core/core_extensions.dart';

part './components/editor_pane.dart';
part './components/file_tab_bar.dart';
part './components/editor_instance.dart';
part './components/editor_field_controller.dart';
part './components/primary_bar.dart';
part './components/file_browser_button.dart';
part './components/status_bar.dart';

part './components/shared/context_menu_region.dart';

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

  final Map<String, List<StreamSubscription>> extensionListeners = {};
  final AffogatoExtensionsAPI _extensionsApi = AffogatoExtensionsAPI();
  late final AffogatoAPI api = AffogatoAPI(
    extensions: _extensionsApi,
  );

  @override
  void initState() {
    BrowserContextMenu.disableContextMenu();
    widget.workspaceConfigs.fileManager
      ..buildIndex()
      ..createDir('Dir_1/')
      ..createDir('Dir_1/inside/')
      ..createDoc(
        path: './Dir_1/inside/',
        AffogatoDocument(
          docName: 'MyDoc.md',
          srcContent: '# Hello',
          maxVersioningLimit: 5,
        ),
      )
      ..createDoc(
        path: './Dir_1/inside/',
        AffogatoDocument(
          docName: 'some_script.js',
          srcContent: 'function f() => 2;',
          maxVersioningLimit: 5,
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
                    .workspaceConfigs.fileManager
                    .getDoc(event.documentId)
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
                  .workspaceConfigs.fileManager
                  .getDoc(event.documentId)
                  .extension),
            ),
          );
        }
      },
    );

    registerListener(
      AffogatoEvents.editorDocumentChangedEvents.stream,
      (event) {
        widget.workspaceConfigs.fileManager
            .getDoc(event.documentId)
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
      ext.loadExtension(fileManager: widget.workspaceConfigs.fileManager);
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
    for (final listeners in extensionListeners.values) {
      for (final hook in listeners) {
        await hook.cancel();
      }
    }
    await AffogatoEvents.windowEditorPaneAddEvents.close();
    await AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.close();
    // ... //
    await AffogatoEvents.windowCloseEvents.close();
    super.dispose();
  }
}

final List<AffogatoExtension> affogatoCoreExtensions = [PairMatcherExtension()];

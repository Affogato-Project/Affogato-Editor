library affogato.editor;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;

part './configs.dart';
part './events.dart';
part './instance_state.dart';
part './components/editor_pane.dart';
part './components/file_tab_bar.dart';
part './components/editor_instance.dart';
part './components/text_selection_controls.dart';
part './components/primary_bar.dart';
part './components/file_browser_button.dart';
part './components/status_bar.dart';

class AffogatoWindow extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;
  final AffogatoWorkspaceConfigs workspaceConfigs;

  const AffogatoWindow({
    required this.stylingConfigs,
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

  @override
  void initState() {
    widget.workspaceConfigs.buildDirStructure();

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
            ),
          );
        }
      },
    );

    registerListener(
      AffogatoEvents.editorDocumentChangedEvents.stream,
      (event) {
        widget.workspaceConfigs.documentsRegistry[event.documentId]!
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: windowKey,
      color: widget.stylingConfigs.themeBundle.editorTheme.windowColor,
      child: SizedBox(
        width: widget.stylingConfigs.windowWidth,
        height: widget.stylingConfigs.windowHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: PrimaryBar(
                      expandedWidth: 300,
                      items: [
                        for (final key
                            in widget.workspaceConfigs.documentsRegistry.keys)
                          AffogatoDocumentItem(key)
                      ],
                      workspaceConfigs: widget.workspaceConfigs,
                      editorTheme:
                          widget.stylingConfigs.themeBundle.editorTheme,
                    ),
                  ),
                  SizedBox(
                    width: widget.stylingConfigs.windowWidth - 300,
                    child: Row(
                      children: [
                        for (final pane
                            in widget.workspaceConfigs.paneDocumentData.entries)
                          EditorPane(
                            key: ValueKey('${pane.key}${pane.value}'),
                            paneId: pane.key,
                            stylingConfigs: widget.stylingConfigs,
                            layoutConfigs: LayoutConfigs(
                              width: double.infinity,
                              height: widget.stylingConfigs.windowHeight -
                                  utils.AffogatoConstants.statusBarHeight,
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
              child: StatusBar(stylingConfigs: widget.stylingConfigs),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    AffogatoEvents.windowCloseEvents.add(const WindowCloseEvent());
    await AffogatoEvents.windowEditorPaneAddEvents.close();
    await AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.close();
    // ... //
    await AffogatoEvents.windowCloseEvents.close();
    super.dispose();
  }
}

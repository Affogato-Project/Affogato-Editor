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
  final List<EditorPane> editorPanes = [];
  final Map<AffogatoDocument, AffogatoInstanceState> savedStates = {};

  @override
  void initState() {
    registerListener(
      AffogatoEvents.editorPaneAddEvents.stream,
      (event) {
        setState(() {
          editorPanes.add(event.editorPane);
        });
      },
    );
    // initial set up of the editor based on the workspace configs
    if (widget.workspaceConfigs.paneDocumentData.isEmpty) {
      AffogatoEvents.editorPaneAddEvents.add(
        WindowEditorPaneAddEvent(
          EditorPane(
            stylingConfigs: widget.stylingConfigs,
            layoutConfigs: LayoutConfigs(
              width: 0,
              height: widget.stylingConfigs.windowHeight,
            ),
            performanceConfigs: widget.performanceConfigs,
            workspaceConfigs: widget.workspaceConfigs,
            documents: [],
            windowKey: windowKey,
          ),
        ),
      );
    } else {
      for (final entry in widget.workspaceConfigs.paneDocumentData.entries) {
        AffogatoEvents.editorPaneAddEvents.add(
          WindowEditorPaneAddEvent(
            EditorPane(
              stylingConfigs: widget.stylingConfigs,
              layoutConfigs: LayoutConfigs(
                width: 0,
                height: widget.stylingConfigs.windowHeight,
              ),
              performanceConfigs: widget.performanceConfigs,
              workspaceConfigs: widget.workspaceConfigs,
              documents: entry.value,
              windowKey: windowKey,
            ),
          ),
        );
      }
    }

    // listens to requests to focus the instance containing the specified document
    // and creates the instance if it doesn't yet exist
    bool hasBeenSetActive = false;
    registerListener(
      AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.stream,
      (event) {
        for (final entry in widget.workspaceConfigs.paneDocumentData.entries) {
          if (entry.value.contains(event.document)) {
            hasBeenSetActive = true;
            // Respond by emitting the event that triggers the corresponding pane
            // to make the specified document active
            AffogatoEvents.editorInstanceSetActiveEvents.add(
              WindowEditorInstanceSetActiveEvent(
                paneId: entry.key,
                document: event.document,
              ),
            );
          }
        }

        // if no current panes contain the document
        if (!hasBeenSetActive) {
          final MapEntry<String, List<AffogatoDocument>> firstPane =
              widget.workspaceConfigs.paneDocumentData.entries.first;
          // modify the first pane's document list to include the new document
          firstPane.value.add(event.document);
          // trigger the event to make said pane activate the document
          AffogatoEvents.editorInstanceSetActiveEvents.add(
            WindowEditorInstanceSetActiveEvent(
              paneId: firstPane.key,
              document: event.document,
            ),
          );
        }
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PrimaryBar(
              expandedWidth: 300,
              items: widget.workspaceConfigs.codebase,
              editorTheme: widget.stylingConfigs.themeBundle.editorTheme,
            ),
            // Status bar
            ...editorPanes,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    cancelSubscriptions();
    AffogatoEvents.windowCloseEvents.add(const WindowCloseEvent());
    await AffogatoEvents.editorPaneAddEvents.close();
    await AffogatoEvents.windowEditorRequestDocumentSetActiveEvents.close();
    // ... //
    await AffogatoEvents.windowCloseEvents.close();
    super.dispose();
  }
}

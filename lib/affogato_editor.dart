library affogato.editor;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';

part './configs.dart';
part './events.dart';
part './instance_state.dart';
part './components/editor_pane.dart';
part './components/file_tab_bar.dart';
part './components/editor_instance.dart';

class AffogatoWindow extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;
  final AffogatoPerformanceConfigs performanceConfigs;

  const AffogatoWindow({
    required this.stylingConfigs,
    required this.performanceConfigs,
    super.key,
  });

  @override
  State<AffogatoWindow> createState() => AffogatoWindowState();
}

class AffogatoWindowState extends State<AffogatoWindow> {
  final GlobalKey<AffogatoWindowState> windowKey = GlobalKey();
  final List<EditorPane> editorPanes = [];
  final Map<AffogatoDocument, AffogatoInstanceState> savedStates = {};

  @override
  void initState() {
    AffogatoEvents.editorPaneAddEvents.stream.listen((event) {
      editorPanes.add(
        EditorPane(
          documents: [],
          layoutConfigs: event.layoutConfigs,
          stylingConfigs: widget.stylingConfigs,
          performanceConfigs: widget.performanceConfigs,
          windowKey: windowKey,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: windowKey,
      child: Container(
        width: widget.stylingConfigs.windowWidth,
        height: widget.stylingConfigs.windowHeight,
        child: Stack(
          children: [
            // File browser,
            // Status bar
            ...[
              for (final pane in editorPanes)
                Positioned(
                  top: pane.layoutConfigs.y,
                  left: pane.layoutConfigs.x,
                  width: pane.layoutConfigs.width,
                  height: pane.layoutConfigs.height,
                  child: pane,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

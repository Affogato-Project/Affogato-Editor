library affogato.editor;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:affogato_core/affogato_core.dart';

part './configs.dart';
part './events.dart';
part './components/editor_pane.dart';
part './components/file_tab_bar.dart';
part './components/editor_instance.dart';

class AffogatoWindow extends StatefulWidget {
  final AffogatoStylingConfigs stylingConfigs;

  const AffogatoWindow({
    required this.stylingConfigs,
    super.key,
  });

  @override
  State<AffogatoWindow> createState() => AffogatoWindowState();
}

class AffogatoWindowState extends State<AffogatoWindow> {
  final List<EditorPane> editorPanes = [];

  @override
  void initState() {
    AffogatoEvents.editorPaneAddEvents.stream.listen((event) {
      editorPanes.add(
        EditorPane(
          documents: [AffogatoDocument(srcContent: '', docName: 'Untitled')],
          layoutConfigs: event.layoutConfigs,
          stylingConfigs: widget.stylingConfigs,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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

import 'package:flutter/material.dart';
import 'package:affogato_editor/affogato_editor.dart';

void main(List<String> args) {
  runApp(
    const MaterialApp(
      home: AffogatoWindow(
        stylingConfigs: AffogatoStylingConfigs(
          windowWidth: 1100,
          windowHeight: 800,
          tabBarHeight: 40,
          windowColor: Colors.black,
          editorColor: Colors.grey,
          borderColor: Colors.green,
        ),
        performanceConfigs: AffogatoPerformanceConfigs(
          rendererType: InstanceRendererType.adHoc,
        ),
      ),
    ),
  );
}

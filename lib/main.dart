import 'package:flutter/material.dart';
import 'package:affogato_editor/affogato_editor.dart';

void main(List<String> args) {
  runApp(
    const AffogatoWindow(
      stylingConfigs: AffogatoStylingConfigs(
        windowWidth: 1100,
        windowHeight: 800,
        tabBarHeight: 80,
      ),
      performanceConfigs: AffogatoPerformanceConfigs(
        rendererType: InstanceRendererType.adHoc,
      ),
    ),
  );
}

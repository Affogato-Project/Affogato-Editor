import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';
import 'package:affogato_editor/battery_langs/markdown/language_bundle.dart';
import 'package:flutter/material.dart';
import 'package:affogato_editor/affogato_editor.dart';
import 'package:affogato_editor/battery_themes/affogato_classic/theme_bundle.dart'
    as affogato_classic_theme;

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AffogatoWindow(
        stylingConfigs: AffogatoStylingConfigs(
          windowWidth: 1100,
          windowHeight: 800,
          tabBarHeight: 40,
          editorFontSize: 14,
          themeBundle: affogato_classic_theme.themeBundle,
        ),
        performanceConfigs: const AffogatoPerformanceConfigs(
          rendererType: InstanceRendererType.adHoc,
        ),
        workspaceConfigs: AffogatoWorkspaceConfigs(
          projectName: 'My First Project',
          themeBundle: affogato_classic_theme.themeBundle,
          languageBundleDetector: (extension) => switch (extension) {
            'js' => genericLB,
            'md' => markdownLB,
            String() => genericLB,
          },
          paneDocumentData: {},
        ),
      ),
    ),
  );
}

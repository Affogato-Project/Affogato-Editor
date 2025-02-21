import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_langs/generic/language_bundle.dart';
import 'package:affogato_editor/battery_langs/markdown/language_bundle.dart';
import 'package:affogato_editor/battery_themes/vscode_modern_dark/theme_bundle.dart';
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
          // Possible to mix-and-match editor themes and syntax highlighting themes
          // from different ThemeBundles
          themeBundle: ThemeBundle(
            synaxHighlighter:
                affogato_classic_theme.themeBundle.synaxHighlighter,
            editorTheme: vscodeModernDarkEditorTheme,
          ),
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

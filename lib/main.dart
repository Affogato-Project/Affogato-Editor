import 'package:affogato_core/affogato_core.dart';
import 'package:affogato_editor/battery_themes/vscode_modern_dark/theme_bundle.dart';
import 'package:flutter/material.dart';
import 'package:affogato_editor/affogato_editor.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AffogatoWindow(
        performanceConfigs: const AffogatoPerformanceConfigs(
          rendererType: InstanceRendererType.adHoc,
        ),
        workspaceConfigs: AffogatoWorkspaceConfigs(
          projectName: 'My First Project',
          // Possible to mix-and-match editor themes and syntax highlighting themes
          // from different ThemeBundles
          themeBundle: ThemeBundle(
            editorTheme: vscodeModernDarkEditorTheme,
            tokenMapping: vscodeModernDarkTokenMapping,
          ),
          languageBundles: const {
            LanguageBundle(
              bundleName: 'dart',
              fileAssociationContributions: [],
            ): ['dart'],
            LanguageBundle(
              bundleName: 'javascript',
              fileAssociationContributions: [],
            ): ['js'],
          },
          paneDocumentData: {},
          stylingConfigs: const AffogatoStylingConfigs(
            windowWidth: 1100,
            windowHeight: 800,
            tabBarHeight: 40,
            editorFontSize: 14,
          ),
          extensions: [
            ...affogatoCoreExtensions,
          ],
        ),
      ),
    ),
  );
}

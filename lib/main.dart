import 'package:affogato_core/affogato_core.dart';
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
          paneDocumentData: {},
          initStructure: [
            FileDirectoryItem(
              dirName: 'MyDir',
              entries: [
                FileDocumentItem(
                  document: AffogatoDocument(
                    docName: 'MyDoc1',
                    srcContent: 'Hello',
                    maxVersioningLimit: 5,
                  ),
                ),
                FileDocumentItem(
                  document: AffogatoDocument(
                    docName: 'MyDoc2',
                    srcContent: 'ge',
                    maxVersioningLimit: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

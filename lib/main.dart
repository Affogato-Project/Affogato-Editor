import 'package:affogato_editor/battery_themes/vscode_modern_dark/theme_bundle.dart';
import 'package:flutter/material.dart';
import 'package:affogato_editor/affogato_editor.dart';
import 'package:affogato_editor/apis/affogato_apis.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;

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
            LanguageBundle(
              bundleName: 'markdown',
              fileAssociationContributions: [],
            ): ['md'],
          },
          instancesData: {},
          rootDirectory: AffogatoVFSEntity.dir(
            entityId: utils.generateId(),
            name: 'Dir_1',
            files: [
              AffogatoVFSEntity.file(
                entityId: utils.generateId(),
                doc: AffogatoDocument(
                  docName: 'main.dart',
                  srcContent: '// this is a comment',
                  maxVersioningLimit: 5,
                ),
              ),
            ],
            subdirs: [
              AffogatoVFSEntity.dir(
                entityId: utils.generateId(),
                name: 'inside',
                files: [
                  AffogatoVFSEntity.file(
                    entityId: utils.generateId(),
                    doc: AffogatoDocument(
                      docName: 'MyDoc.md',
                      srcContent: '# Hello',
                      maxVersioningLimit: 5,
                    ),
                  ),
                  AffogatoVFSEntity.file(
                    entityId: utils.generateId(),
                    doc: AffogatoDocument(
                      docName: 'some_script.js',
                      srcContent: 'function f() => 2;',
                      maxVersioningLimit: 5,
                    ),
                  ),
                ],
                subdirs: [],
              ),
            ],
          ),
          stylingConfigs: const AffogatoStylingConfigs(
            windowWidth: 1100,
            windowHeight: 786,
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

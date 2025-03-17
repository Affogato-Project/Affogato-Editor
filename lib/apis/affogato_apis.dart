library affogato.apis;

import 'dart:async';
import 'dart:convert';

import 'package:affogato_editor/affogato_editor.dart';
import 'package:affogato_editor/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part './editor/editor_api.dart';
part './editor/language_bundle/language_bundle.dart';
part './editor/language_bundle/tokeniser/tokeniser.dart';
part './editor/language_bundle/tokeniser/token_type.dart';
part './editor/language_bundle/tokeniser/cursor.dart';
part './editor/language_bundle/tokeniser/token.dart';
part './editor/language_bundle/parser/ast.dart';
part './editor/language_bundle/parser/parser.dart';
part './editor/language_bundle/parser/token_cursor.dart';
part './editor/language_bundle/interpreter/interpreter.dart';
part './editor/theme_bundle/editor_theme.dart';
part './editor/theme_bundle/highlight_renderer.dart';
part './editor/theme_bundle/syntax_highlighter.dart';
part './editor/theme_bundle/theme_bundle.dart';
part './editor/theme_bundle/token_mapping.dart';
part './editor/utils/utils.dart';

part './window/window_api.dart';
part './window/panes_api.dart';

part './workspace/workspace_api.dart';

part './vfs/vfs_api.dart';
part './vfs/affogato_document.dart';

part './extensions/extension_api.dart';
part './extensions/extensions_engine.dart';
part './extensions/affogato_extension.dart';

abstract class AffogatoAPIComponent {
  late final AffogatoAPI api;

  AffogatoAPIComponent();

  void init();
}

/// An abstraction over the [AffogatoEvents] class and over commonly-accessed objects
/// such as [AffogatoWorkspaceConfigs]. Each API in [AffogatoAPI] has to be instantiated
/// by the user, since each API has its own configurations.
class AffogatoAPI {
  final AffogatoExtensionsAPI extensions;
  final AffogatoWindowAPI window;
  final AffogatoEditorAPI editor;
  final AffogatoVFSAPI vfs;
  final AffogatoWorkspaceAPI workspace;

  AffogatoAPI({
    required this.extensions,
    required this.window,
    required this.editor,
    required this.vfs,
    required this.workspace,
  });

  void init() {
    extensions
      ..api = this
      ..init();
    window
      ..api = this
      ..init();
    editor
      ..api = this
      ..init();
    vfs
      ..api = this
      ..init();
    workspace
      ..api = this
      ..init();
  }

  void deinit() {
    extensions.deinit();
  }
}

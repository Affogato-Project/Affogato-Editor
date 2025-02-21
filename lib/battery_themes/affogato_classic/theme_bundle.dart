library affogato.editor.battery.themes.affogato;

import 'package:affogato_core/affogato_core.dart';
import 'package:flutter/material.dart';

part './synax_highlighter.dart';
part './render_token.dart';

final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter, Color,
    TextStyle> themeBundle = ThemeBundle(
  synaxHighlighter: AffogatoSyntaxHighlighter(),
  editorTheme: EditorTheme<Color, TextStyle>(
    panelBackground: const Color(0xFF2B0504),
    editorBackground: const Color(0xFF663000),
    editorGroupBorder: const Color(0xFF64432B),
    statusBarBackground: const Color(0xFF2B0504),
    editorForeground: const Color(0xFFFDCC9B),
    defaultTextStyle: const TextStyle(
      fontFamily: 'IBMPlexMono',
      color: Color(0xFFFDCC9B),
    ),
  ),
);

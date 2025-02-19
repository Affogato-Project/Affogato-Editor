library affogato.editor.battery.themes.affogato;

import 'package:affogato_core/affogato_core.dart';
import 'package:flutter/material.dart';

part './synax_highlighter.dart';
part './render_token.dart';

final ThemeBundle<AffogatoRenderToken, AffogatoSyntaxHighlighter, Color,
    TextStyle> themeBundle = ThemeBundle(
  synaxHighlighter: AffogatoSyntaxHighlighter(),
  editorTheme: const EditorTheme<Color, TextStyle>(
    windowColor: Color(0xFF2B0504),
    editorColor: Color(0xFF663000),
    borderColor: Color(0xFF64432B),
    primaryBarColor: Color(0xFF522600),
    statusBarColor: Color(0xFF2B0504),
    defaultTextColor: Color(0xFFFDCC9B),
    defaultTextStyle: TextStyle(
      fontFamily: 'IBMPlexMono',
      color: Color(0xFFFDCC9B),
    ),
  ),
);

library affogato.editor.battery.langs.markdown;

import 'package:affogato_core/affogato_core.dart';

part './tokeniser.dart';
part './parser.dart';
part './interpreter.dart';

final LanguageBundle markdownLB = LanguageBundle(
  bundleName: 'Markdown',
  tokeniser: MarkdownTokeniser(),
  parser: MarkdownParser(),
  interpreter: MarkdownInterpreter(),
);

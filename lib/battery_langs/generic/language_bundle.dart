library affogato.editor.battery.generic;

import 'package:xml/xml.dart';
import 'package:highlight/highlight.dart';
import 'package:affogato_core/affogato_core.dart';

part './tokeniser.dart';
part './parser.dart';

final LanguageBundle genericLB = LanguageBundle(
  bundleName: 'Generic',
  tokeniser: GenericTokeniser(),
  parser: GenericParser(),
  interpreter: GenericInterpreter(),
  fileAssociationContributions: const [],
);

class GenericInterpreter extends Interpreter {
  @override
  void interpret(AST ast) {
    // TODO: implement interpret
    throw UnimplementedError();
  }
}

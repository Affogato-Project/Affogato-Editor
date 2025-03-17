part of affogato.apis;

class LanguageBundle {
  final String bundleName;
  final Tokeniser? tokeniser;
  final Parser? parser;
  final Interpreter? interpreter;
  final List<String> fileAssociationContributions;

  const LanguageBundle({
    required this.bundleName,
    required this.fileAssociationContributions,
    this.tokeniser,
    this.parser,
    this.interpreter,
  });
}
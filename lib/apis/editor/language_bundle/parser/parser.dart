part of affogato.apis;

abstract class Parser {
  ParseResult parse(List<Token> tokens);
}

class ParseResult {
  final List<ParseException> exceptions = [];
  final AST ast = AST(nodes: []);

  void reportException(ParseException exception) => exceptions.add(exception);
}

enum ExceptionType {
  hint('HINT'),
  warn('WARN'),
  error(' ERR');

  final String label;
  const ExceptionType(this.label);
}

class ParseException {
  final ExceptionType exceptionType;
  final Token token;
  final String message;
  final String? description;
  final StackTrace? stackTrace;

  ParseException({
    required this.exceptionType,
    required this.token,
    required this.message,
    this.description,
    this.stackTrace,
  });

  String presentExceptionLong() =>
      "|${exceptionType.label} ${token.start}| $message" +
      ((description != null) ? "\n          $description" : '') +
      ((stackTrace != null)
          ? "\n${stackTrace.toString().padLeft(10, '')}"
          : '');
  String presentExceptionShort() =>
      "|${exceptionType.label} ${token.start}| $message";
}

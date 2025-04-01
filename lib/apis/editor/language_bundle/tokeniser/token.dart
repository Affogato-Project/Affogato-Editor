part of affogato.apis;

class Token {
  final CursorLocation start;
  final CursorLocation end;
  final String lexeme;
  final TokenType tokenType;
  final Object? literal;

  const Token({
    required this.tokenType,
    required this.lexeme,
    required this.start,
    required this.end,
    this.literal,
  });

  bool containsChar(CursorLocation location) =>
      start <= location && location <= end;

  String toPrettyString() =>
      "[${tokenType.value}] $start..$end $lexeme (${literal ?? ''})";

  @override
  bool operator ==(Object other) =>
      (other is Token) &&
      start == other.start &&
      end == other.end &&
      lexeme == other.lexeme &&
      tokenType == other.tokenType;
}

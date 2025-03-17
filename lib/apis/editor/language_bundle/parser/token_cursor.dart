part of affogato.apis;

class TokenCursor {
  /// The last [Token] must be an EOF token for the [TokenCursor] to work.
  /// Always add a [Token] with the [TokenType.eof] type at the end of the tokenisation process.
  final List<Token> tokens;
  final Token eofToken;
  int counter = 0;

  TokenCursor(this.tokens) : eofToken = tokens.last;

  Token get current => tokens[counter];
  bool get reachedEOF => counter == tokens.length - 1;

  T _nextTokOrElse<T>({
    required T Function(Token) withNextTok,
    required T Function() orElse,
    bool updateState = false,
  }) {
    if (reachedEOF) {
      return orElse();
    } else {
      if (updateState) counter += 1;
      return withNextTok(tokens[counter]);
    }
  }

  List<Token> peek({int lookAhead = 1}) {
    final List<Token> res = [];

    for (int i = 1; i < lookAhead + 1; i++) {
      res.add(counter + i < tokens.length ? tokens[counter + i] : eofToken);
    }
    return res;
  }

  Token advance() => _nextTokOrElse(
        withNextTok: (Token tok) => tok,
        orElse: () => tokens.last,
        updateState: true,
      );

  /// This method is strictly used to skip insignificant tokens, typically whitespace,
  /// which will not end up in the actual AST.
  void skip(ParseResult parseResult) {
    if (current.tokenType != TokenType.eof()) {
      parseResult.ast.nodes.add(InsignificantASTNode()..tokens.add(current));
    }
    advance();
  }

  void errorToken(ParseResult parseResult) {
    if (current.tokenType != TokenType.eof()) {
      parseResult.ast.nodes.add(ErroneousASTNode()..tokens.add(current));
    }
    advance();
  }

  bool nextMatchesType(TokenType type) => _nextTokOrElse(
        withNextTok: (Token t) => t.tokenType == type,
        orElse: () => false,
      );

  bool nextMatchesAnyType(List<TokenType> types) => _nextTokOrElse(
        withNextTok: (Token t) => types.contains(t.tokenType),
        orElse: () => false,
      );
}

part of affogato.editor.battery.langs.markdown;

class MarkdownParser extends Parser {
  ParseResult result = ParseResult();

  late TokenCursor cursor;

  @override
  ParseResult parse(List<Token> tokens) {
    result = ParseResult();
    cursor = TokenCursor(tokens);

    while (!cursor.reachedEOF) {
      result.ast.nodes.add(parseStatement());
    }

    return result;
  }

  ASTNode parseStatement() {
    if (cursor.current.tokenType == const TokenType.numberSign()) {
      switch (cursor.peek().first.tokenType) {
        case const TokenType.space():
          return parseHeaderOne();
        case const TokenType.numberSign():
          final nextTwoTokens = cursor.peek(lookAhead: 2);
          if (nextTwoTokens[1].tokenType == const TokenType.numberSign()) {
            final nextThreeTokens = cursor.peek(lookAhead: 3);
            if (nextThreeTokens[2].tokenType == const TokenType.space()) {
              return parseHeaderThree();
            } else {
              return parseBody();
            }
          } else if (nextTwoTokens[1].tokenType == const TokenType.space()) {
            return parseHeaderTwo();
          } else {
            return parseBody();
          }
        default:
          return parseBody();
      }
    } else {
      return parseBody();
    }
  }

  HeaderOneNode parseHeaderOne() {
    final node = HeaderOneNode()
      ..tokens.addAll([cursor.current, cursor.advance()]);
    cursor.advance();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }

    if (cursor.current.tokenType == const TokenType.newline()) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    return node;
  }

  HeaderTwoNode parseHeaderTwo() {
    final node = HeaderTwoNode()
      ..tokens.addAll([cursor.current, cursor.advance()]);
    cursor.advance();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }

    if (cursor.current.tokenType == const TokenType.newline()) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    return node;
  }

  HeaderThreeNode parseHeaderThree() {
    final node = HeaderThreeNode()
      ..tokens.addAll([cursor.current, cursor.advance()]);
    cursor.advance();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }

    if (cursor.current.tokenType == const TokenType.newline()) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    return node;
  }

  BodyNode parseBody() {
    final node = BodyNode();
    while (cursor.current.tokenType != const TokenType.newline() &&
        !cursor.reachedEOF) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    if (cursor.current.tokenType == const TokenType.newline()) {
      node.tokens.add(cursor.current);
      cursor.advance();
    }
    return node;
  }
}

class HeaderOneNode extends TerminalASTNode {
  HeaderOneNode() : super('HeaderOneNode', scopes: ['heading', 'heading.one']);
}

class HeaderTwoNode extends TerminalASTNode {
  HeaderTwoNode() : super('HeaderTwoNode', scopes: ['heading', 'heading.two']);
}

class HeaderThreeNode extends TerminalASTNode {
  HeaderThreeNode()
      : super('HeaderThreeNode', scopes: ['heading', 'heading.three']);
}

class BodyNode extends TerminalASTNode {
  BodyNode() : super('BodyNode', scopes: ['string']);
}

part of affogato.editor.battery.generic;

class GenericParser extends Parser {
  late TokenCursor cursor;
  ParseResult result = ParseResult();

  @override
  ParseResult parse(List<Token> tokens) {
    result = ParseResult();
    cursor = TokenCursor(tokens);

    while (!cursor.reachedEOF) {
      parseStatement();
    }

    return result;
  }

  ASTNode parseStatement() {
    final TerminalASTNode node = switch (cursor.current.tokenType.value) {
      'keyword' => HLJSKeywordNode()..tokens.add(cursor.current),
      'built_in' => HLJSBuiltInNode()..tokens.add(cursor.current),
      'comment' => HLJSCommentNode()..tokens.add(cursor.current),
      'string' => HLJSStringNode()..tokens.add(cursor.current),
      'number' => HLJSNumberNode()..tokens.add(cursor.current),
      'class' => HLJSClassNode()..tokens.add(cursor.current),
      ' ' => InsignificantASTNode()..tokens.add(cursor.current),
      '\n' => InsignificantASTNode()..tokens.add(cursor.current),
      String() => GenericUnkownNode()..tokens.add(cursor.current),
    };
    /* if (!node.lexeme.isWhitespace) {
      print(!node.lexeme.isWhitespace);

      result.addNode(node);
    } else {
      print(false);
    }
    final TerminalASTNode? cskip = cursor.skip();
    print("skipped '${cskip?.lexeme}'");
    result.addNode(cskip); */
    result.ast.nodes.add(node);
    cursor.advance();
    return node;
  }
}

class HLJSKeywordNode extends TerminalASTNode {
  HLJSKeywordNode() : super('HLJSKeywordNode', scopes: ['keyword']);
}

class HLJSBuiltInNode extends TerminalASTNode {
  HLJSBuiltInNode() : super('HLJSBuiltInNode', scopes: ['built_in']);
}

class HLJSCommentNode extends TerminalASTNode {
  HLJSCommentNode() : super('HLJSCommentNode', scopes: ['comment']);
}

class HLJSStringNode extends TerminalASTNode {
  HLJSStringNode() : super('HLJSStringNode', scopes: ['string']);
}

class HLJSNumberNode extends TerminalASTNode {
  HLJSNumberNode() : super('HLJSNumberNode', scopes: ['number']);
}

class HLJSClassNode extends TerminalASTNode {
  HLJSClassNode() : super('HLJSClassNode', scopes: ['class']);
}

class GenericUnkownNode extends TerminalASTNode {
  GenericUnkownNode() : super('GenericUnkownNode', scopes: ['unkown']);
}

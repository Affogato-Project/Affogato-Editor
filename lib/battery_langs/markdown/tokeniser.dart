part of affogato.editor.battery.langs.markdown;

class MarkdownTokeniser extends Tokeniser {
  final List<Token> tokens = [];
  late Cursor cursor;
  CursorLocation? offset;

  @override
  List<Token> tokenise(
    String source, {
    List<Token> precedingTokens = const [],
    List<Token> succeedingTokens = const [],
  }) {
    tokens.clear();
    cursor = Cursor(source);

    if (precedingTokens.isNotEmpty) {
      offset = precedingTokens.last.end;
    }

    tokenisingLoop();
    offset = null;
    return tokens;
  }

  void tokenisingLoop() {
    do {
      tokens.add(
        switch (cursor.current) {
          '#' => Token(
              tokenType: const TokenType.numberSign(),
              lexeme: const TokenType.numberSign().value,
              start: cursor.location() + offset,
              end: cursor.location() + offset),
          ' ' => Token(
              tokenType: const TokenType.space(),
              lexeme: const TokenType.space().value,
              start: cursor.location() + offset,
              end: cursor.location() + offset),
          '\n' => Token(
              tokenType: const TokenType.newline(),
              lexeme: const TokenType.newline().value,
              start: cursor.location(),
              end: cursor.location()),
          String() => Token(
              tokenType: const TokenType.string(),
              lexeme: cursor.current,
              start: cursor.location() + offset,
              end: cursor.location() + offset),
        },
      );
    } while (!cursor.advance().isEOF);

    tokens.add(Token(
      tokenType: const TokenType.eof(),
      lexeme: const TokenType.eof().value,
      start: cursor.location(),
      end: cursor.location(),
    ));
  }
}

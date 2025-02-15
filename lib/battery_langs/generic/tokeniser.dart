part of affogato.editor.battery.generic;

class GenericTokeniser extends Tokeniser {
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
    final parsedSpans = highlight.parse(source, language: 'dart').toHtml();
    if (parsedSpans.startsWith('<span')) {
      final doc = XmlDocument.parse("<primary>$parsedSpans</primary>");
      final root = doc.rootElement;
      for (final span in root.childElements) {
        final List<String> scopes = span.attributes
            .where((a) => a.name.local == 'class')
            .map((e) => e.value.replaceAll('hljs-', ''))
            .toList();
        tokens.add(Token(
            tokenType: TokenType(scopes.join('-')),
            lexeme: span.innerText,
            start: const CursorLocation(rowNum: 0, colNum: 0),
            end: const CursorLocation(rowNum: 0, colNum: 0)));
        if (span.following.isNotEmpty &&
            !span.following.first.toString().startsWith('<span')) {
          tokens.add(Token(
              tokenType: const TokenType.unkown(),
              lexeme: span.following.first.toString(),
              start: const CursorLocation(rowNum: 0, colNum: 0),
              end: const CursorLocation(rowNum: 0, colNum: 0)));
        }
      }
    } else {
      for (final char in source.chars) {
        if (char == ' ' || char == '\n') {
          tokens.add(Token(
              tokenType: char == ' '
                  ? const TokenType.space()
                  : const TokenType.newline(),
              lexeme: char,
              start: const CursorLocation(rowNum: 0, colNum: 0),
              end: const CursorLocation(rowNum: 0, colNum: 0)));
        } else {
          tokens.add(Token(
              tokenType: const TokenType.unkown(),
              lexeme: char,
              start: const CursorLocation(rowNum: 0, colNum: 0),
              end: const CursorLocation(rowNum: 0, colNum: 0)));
        }
      }
    }
    tokens.add(Token(
        tokenType: const TokenType.eof(),
        lexeme: const TokenType.eof().value,
        start: const CursorLocation(rowNum: 0, colNum: 0),
        end: const CursorLocation(rowNum: 0, colNum: 0)));
    return tokens;
  }
}

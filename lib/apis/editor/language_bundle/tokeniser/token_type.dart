part of affogato.apis;

class TokenType {
  final String value;

  const TokenType(this.value);

  const TokenType.eof() : value = eofStr;
  const TokenType.leftParen() : value = '(';
  const TokenType.rightParen() : value = ')';
  const TokenType.leftBrack() : value = '[';
  const TokenType.rightBrack() : value = ']';
  const TokenType.leftBrace() : value = '{';
  const TokenType.rightBrace() : value = '}';
  const TokenType.leftAngled() : value = '<';
  const TokenType.rightAngled() : value = '>';
  const TokenType.ampersand() : value = '&';
  const TokenType.percent() : value = '%';
  const TokenType.caret() : value = '^';
  const TokenType.numberSign() : value = '#';
  const TokenType.atSign() : value = '@';
  const TokenType.dollarSign() : value = '\$';
  const TokenType.backtick() : value = '`';
  const TokenType.tilde() : value = '~';
  const TokenType.questionMark() : value = '?';
  const TokenType.comma() : value = ',';
  const TokenType.dot() : value = '.';
  const TokenType.colon() : value = ':';
  const TokenType.semicolon() : value = ';';
  const TokenType.slash() : value = '/';
  const TokenType.backslash() : value = '\\';
  const TokenType.pipe() : value = '|';
  const TokenType.plus() : value = '+';
  const TokenType.minus() : value = '-';
  const TokenType.asterisk() : value = '*';
  const TokenType.equal() : value = '=';
  const TokenType.bang() : value = '!';
  const TokenType.bangEqual() : value = '!=';
  const TokenType.equalEqual() : value = '==';
  const TokenType.lessThan() : value = '<';
  const TokenType.lessThanEqual() : value = '<=';
  const TokenType.greaterThan() : value = '>';
  const TokenType.greaterThanEqual() : value = '>=';
  const TokenType.space() : value = ' ';
  const TokenType.doubleQuote() : value = '"';
  const TokenType.singleQUote() : value = "'";
  const TokenType.string() : value = 'String';
  const TokenType.integer() : value = 'Integer';
  const TokenType.decimal() : value = 'Decimal';
  const TokenType.identifier() : value = 'Identifier';
  const TokenType.newline() : value = '\n';
  const TokenType.unkown() : value = 'Unknown';

  @override
  bool operator ==(Object? other) =>
      (other is TokenType) && (value == other.value);
}

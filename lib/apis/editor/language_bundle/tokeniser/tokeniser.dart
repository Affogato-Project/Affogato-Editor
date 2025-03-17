part of affogato.apis;

abstract class Tokeniser {
  List<Token> tokenise(
    String source, {
    List<Token> precedingTokens = const [],
    List<Token> succeedingTokens = const [],
  });
}

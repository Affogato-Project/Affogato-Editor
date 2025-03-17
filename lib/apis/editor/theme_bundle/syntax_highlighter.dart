part of affogato.apis;

/// The [SyntaxHighlighter] generates a sequence of highlight tokens. Each token
/// is a record of type `(String, T)`, where the first item is the text itself, and [T] is the
/// type of the highlighting format.
abstract class SyntaxHighlighter<T> {
  T createRenderTokens(String text);
}

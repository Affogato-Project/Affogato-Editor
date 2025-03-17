part of affogato.apis;

/// This is what the type generics mean:
/// - [S] is the type of the syntax highlighting tokens generated by the [SyntaxHighlighter]
/// - [C] represents the colour class being used. On Flutter, this should be [Color]
/// - [Y] represents the text styling class being used. On Flutter, this should be [TextStyle]
/// - [D] represents the output of the [SyntaxTokenRenderer]. Affogato Editor uses an underlying TextField, and therefore,
/// requires [D] to be a [TextSpan].
/// - The [EditorTheme] should therefore represent colours with [C] and text styles with [Y]
class ThemeBundle<S, C, Y, D> {
  // final SyntaxHighlighter<S> syntaxHighlighter;
  // final SyntaxTokenRenderer<S, D> highlightRenderer;
  final EditorTheme<C, Y> editorTheme;
  final Map<String, Y> tokenMapping;

  const ThemeBundle({
    // required this.syntaxHighlighter,
    // required this.highlightRenderer,
    required this.editorTheme,
    required this.tokenMapping,
  });
}

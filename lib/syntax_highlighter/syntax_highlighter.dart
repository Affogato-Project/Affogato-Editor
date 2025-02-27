part of affogato.editor;

/// The default syntax highligher uses the HighlightJS equivalent in Dart, made possible
/// by the `re_highlight` package.
class AffogatoDefaultSyntaxHighlighter
    extends SyntaxHighlighter<HighlightResult> {
  final String? language;
  final Highlight highlight = Highlight();

  AffogatoDefaultSyntaxHighlighter(this.language) {
    highlight.registerLanguages(builtinAllLanguages);
  }

  @override
  HighlightResult createRenderTokens(String text) => language != null
      ? highlight.highlight(code: text, language: language!)
      : highlight.highlightAuto(text);
}

class AffogatoDefaultRenderer
    extends SyntaxTokenRenderer<HighlightResult, TextSpan?> {
  final TextStyle defaultStyle;
  final Map<String, TextStyle> mapping;
  final TextSpanRenderer renderer;

  AffogatoDefaultRenderer({
    required this.defaultStyle,
    required this.mapping,
  }) : renderer = TextSpanRenderer(defaultStyle, mapping);

  @override
  TextSpan? render(HighlightResult tokens) {
    tokens.render(renderer);
    return renderer.span;
  }
}

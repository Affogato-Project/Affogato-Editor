part of affogato.editor;

class AffogatoEditorFieldController<T extends AffogatoRenderToken,
    H extends SyntaxHighlighter<T>> extends TextEditingController {
  final LanguageBundle languageBundle;
  final ThemeBundle<T, H, Color, TextStyle> themeBundle;
  final AffogatoStylingConfigs stylingConfigs;
  final String? initialText;

  AffogatoEditorFieldController({
    required this.languageBundle,
    required this.themeBundle,
    required this.stylingConfigs,
    this.initialText,
  }) : super(text: initialText);

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty) {
      return TextSpan(
        text: text,
        style: themeBundle.editorTheme.defaultTextStyle.copyWith(
          height: utils.AffogatoConstants.lineHeight,
          fontSize: stylingConfigs.editorFontSize,
        ),
      );
    }

    try {
      final List<Token> tokens = languageBundle.tokeniser.tokenise(text);
      final ParseResult res = languageBundle.parser.parse(tokens);
      final List<AffogatoRenderToken> renderTokens =
          themeBundle.synaxHighlighter.createRenderTokens(res);
      return TextSpan(
        style: themeBundle.editorTheme.defaultTextStyle.copyWith(
          height: utils.AffogatoConstants.lineHeight,
          fontSize: stylingConfigs.editorFontSize,
        ),
        children: [
          for (final rt in renderTokens)
            TextSpan(
              text: (rt.node as TerminalASTNode).lexeme,
              style:
                  rt.render(themeBundle.editorTheme.defaultTextStyle).copyWith(
                        height: utils.AffogatoConstants.lineHeight,
                        fontSize: stylingConfigs.editorFontSize,
                      ),
            ),
        ],
      );
    } catch (e, _) {
      print(e);
      //print(st);
      return TextSpan(
        text: text,
        style: themeBundle.editorTheme.defaultTextStyle.copyWith(
          height: utils.AffogatoConstants.lineHeight,
          fontSize: stylingConfigs.editorFontSize,
        ),
      );
    }
  }
}

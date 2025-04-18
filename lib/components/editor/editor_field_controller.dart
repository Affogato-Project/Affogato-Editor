part of affogato.editor;

class AffogatoEditorFieldController<S, SyntaxHighlighter>
    extends TextEditingController {
  final LanguageBundle? languageBundle;
  final ThemeBundle<S, Color, TextStyle, TextSpan> themeBundle;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final String? initialText;
  final AffogatoDefaultSyntaxHighlighter syntaxHighlighter;

  AffogatoEditorFieldController({
    required this.languageBundle,
    required this.themeBundle,
    required this.workspaceConfigs,
    this.initialText,
  })  : syntaxHighlighter =
            AffogatoDefaultSyntaxHighlighter(languageBundle?.bundleName),
        super(text: initialText);

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
    return AffogatoDefaultRenderer(
          defaultStyle: themeBundle.editorTheme.defaultTextStyle,
          mapping: themeBundle.tokenMapping,
        ).render(syntaxHighlighter.createRenderTokens(text)) ??
        super.buildTextSpan(
          context: context,
          withComposing: withComposing,
        );
  }
}

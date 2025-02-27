part of affogato.editor;

class AffogatoInstanceState {
  final int cursorPos;
  final double scrollHeight;
  final LanguageBundle? languageBundle;

  const AffogatoInstanceState({
    required this.cursorPos,
    required this.scrollHeight,
    required this.languageBundle,
  });
}

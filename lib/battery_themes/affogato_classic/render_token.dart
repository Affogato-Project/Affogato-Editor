part of affogato.editor.battery.themes.affogato;

abstract class AffogatoRenderToken extends RenderToken<TextStyle, TextStyle> {
  AffogatoRenderToken(super.node);
}

class HeaderBoldRenderToken extends AffogatoRenderToken {
  HeaderBoldRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) => defaultStyle.copyWith(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      );
}

class HeaderOneRenderToken extends AffogatoRenderToken {
  HeaderOneRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) => defaultStyle.copyWith(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      );
}

class ClassRenderToken extends AffogatoRenderToken {
  ClassRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.green);
}

class CommentRenderToken extends AffogatoRenderToken {
  CommentRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.blueGrey);
}

class KeywordRenderToken extends AffogatoRenderToken {
  KeywordRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.purple);
}

class StringRenderToken extends AffogatoRenderToken {
  StringRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.brown);
}

class NumberRenderToken extends AffogatoRenderToken {
  NumberRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.yellow);
}

class BuiltInRenderToken extends AffogatoRenderToken {
  BuiltInRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.deepOrange);
}

class DefaultPlainTextRenderToken extends AffogatoRenderToken {
  DefaultPlainTextRenderToken(super.node);

  @override
  TextStyle render(TextStyle defaultStyle) =>
      defaultStyle.copyWith(color: Colors.white);
}

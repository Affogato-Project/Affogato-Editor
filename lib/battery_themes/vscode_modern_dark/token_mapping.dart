part of affogato.editor.battery.themes.vscode_modern_dark;

final Map<String, TextStyle> vscodeModernDarkTokenMapping = {
  // Default style, used as a base for others
  "default": vscodeModernDarkEditorTheme.defaultTextStyle,

  "entity.name.function": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFDCDCAA)),
  "meta.embedded": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "source.groovy.embedded": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "string meta.image.inline.markdown": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "variable.legacy.builtin.python": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),

  "emphasis": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(fontStyle: FontStyle.italic),
  "strong": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(fontWeight: FontWeight.bold),
  "header": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF000080)),
  "comment": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF6A9955)),
  "constant.language": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "constant.numeric": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "variable.other.enummember": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "keyword.operator.plus.exponent": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "keyword.operator.minus.exponent": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "constant.regexp": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF646695)),
  "entity.name.tag": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "entity.name.tag.css": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.name.tag.less": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.other.attribute-name": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "entity.other.attribute-name.class.css": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "source.css entity.other.attribute-name.class": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.other.attribute-name.id.css": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.other.attribute-name.parent-selector.css": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.other.attribute-name.parent.less": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "source.css entity.other.attribute-name.pseudo-class":
      vscodeModernDarkEditorTheme.defaultTextStyle
          .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.other.attribute-name.pseudo-element.css": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "source.css.less entity.other.attribute-name.id": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "entity.other.attribute-name.scss": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD7BA7D)),
  "invalid": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFF44747)),
  "markup.underline": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(decoration: TextDecoration.underline),
  "markup.bold": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF569CD6)),
  "markup.heading": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF569CD6)),
  "markup.italic": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(fontStyle: FontStyle.italic),
  "markup.strikethrough": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(decoration: TextDecoration.lineThrough),
  "markup.inserted": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "markup.deleted": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "markup.changed": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "punctuation.definition.quote.begin.markdown": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF6A9955)),
  "punctuation.definition.list.begin.markdown": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF6796E6)),
  "markup.inline.raw": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "brackets of XML/HTML tags": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF808080)),
  "meta.preprocessor": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "entity.name.function.preprocessor": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "meta.preprocessor.string": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "meta.preprocessor.numeric": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "meta.structure.dictionary.key.python": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "meta.diff.header": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "storage": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "storage.type": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "storage.modifier": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.noexcept": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "string": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "meta.embedded.assembly": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "string.tag": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "string.value": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFCE9178)),
  "string.regexp": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD16969)),
  "String interpolation": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "punctuation.definition.template-expression.begin":
      vscodeModernDarkEditorTheme.defaultTextStyle
          .copyWith(color: const Color(0xFF569CD6)),
  "punctuation.definition.template-expression.end": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "punctuation.section.embedded": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "Reset JavaScript string interpolation expression":
      vscodeModernDarkEditorTheme.defaultTextStyle
          .copyWith(color: const Color(0xFFD4D4D4)),
  "meta.template.expression": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "support.type.vendored.property-name": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "support.type.property-name": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "source.css variable": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "source.coffee.embedded": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "keyword": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.control": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "keyword.operator.new": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.expression": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.cast": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.sizeof": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.alignof": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.typeid": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.alignas": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.instanceof": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.logical.python": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.operator.wordlike": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "keyword.other.unit": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "punctuation.section.embedded.begin.php": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "punctuation.section.embedded.end.php": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "support.function.git-rebase": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF9CDCFE)),
  "constant.sha.git-rebase": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFB5CEA8)),
  "coloring of the Java import and package identifiers":
      vscodeModernDarkEditorTheme.defaultTextStyle
          .copyWith(color: const Color(0xFFD4D4D4)),
  "storage.modifier.import.java": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "variable.language.wildcard.java": vscodeModernDarkEditorTheme
      .defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "storage.modifier.package.java": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFFD4D4D4)),
  "this.self": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
  "variable.language": vscodeModernDarkEditorTheme.defaultTextStyle
      .copyWith(color: const Color(0xFF569CD6)),
};

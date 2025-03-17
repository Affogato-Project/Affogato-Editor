part of affogato.apis;

class CursorLocation {
  final int rowNum;
  final int colNum;

  const CursorLocation({
    required this.rowNum,
    required this.colNum,
  });

  @override
  bool operator ==(Object other) =>
      other is CursorLocation &&
      (rowNum == other.rowNum && colNum == other.colNum);

  bool operator <(CursorLocation other) =>
      rowNum < other.rowNum ||
      (rowNum == other.rowNum && colNum < other.colNum);

  bool operator >(CursorLocation other) =>
      rowNum > other.rowNum ||
      (rowNum == other.rowNum && colNum > other.colNum);

  bool operator <=(CursorLocation other) => (this < other) || (this == other);
  bool operator >=(CursorLocation other) => (this > other) || (this == other);

  CursorLocation operator +(CursorLocation? other) => CursorLocation(
      rowNum: rowNum + (other?.rowNum ?? 0),
      colNum: colNum + (other?.colNum ?? 0));

  CursorLocation operator -(CursorLocation other) => CursorLocation(
      rowNum: rowNum - other.rowNum, colNum: colNum - other.colNum);

  @override
  String toString() => "($rowNum, $colNum)";
}

extension StringUtils on String {
  List<String> get chars => split('');
  bool get isEOF => this == eofStr;
  bool get isWhitespace => this == '\n' || this == ' ';

  List<List<Char>> createCharMap() {
    final List<List<Char>> charMap = [[]];
    for (int i = 0; i < chars.length; i++) {
      charMap.last.add(chars[i]);
      if (chars[i] == '\n') charMap.add([]);
    }
    charMap.last.add(eofStr);
    return charMap;
  }
}

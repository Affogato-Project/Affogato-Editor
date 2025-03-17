part of affogato.apis;

typedef Char = String;

const String eofStr = '<EOF>';

class Cursor {
  final String source;
  final List<List<Char>> charMap;
  int col = 0;
  int row = 0;

  Cursor(this.source) : charMap = source.createCharMap();

  CursorLocation location() => CursorLocation(rowNum: row, colNum: col);

  Char get current => charMap[row][col];
  bool get reachedEOF {
    return row == charMap.length - 1 && col == charMap[row].length - 1;
  }

  T _nextCharOrElse<T>({
    required T Function(String) withNextChar,
    required T Function() orElse,
    bool updateState = false,
  }) {
    int newRow = row;
    int newCol = col;

    if (col == charMap[row].length - 1) {
      if (row == charMap.length - 1) {
        return orElse();
      } else {
        newRow = newRow + 1;
        newCol = 0;
      }
    } else {
      newCol += 1;
    }

    if (updateState) {
      row = newRow;
      col = newCol;
    }

    return withNextChar(charMap[newRow][newCol]);
  }

  List<Char> peek({int lookAhead = 1, int? r, int? c}) {
    final Char res;
    if ((r ?? row) == charMap.length - 1 &&
        (c ?? col) == charMap[(r ?? row)].length - 1) {
      res = TokenType.eof().value;
    } else {
      if ((c ?? col) == charMap[(r ?? row)].length - 1) {
        c = 0;
        r = (r ?? row) + 1;
      } else {
        c = (c ?? col) + 1;
      }
      res = charMap[(r ?? row)][(c)];
    }

    if ((lookAhead -= 1) > 0) {
      return [res, ...peek(lookAhead: lookAhead, r: r, c: c)];
    } else {
      return [res];
    }
  }

  Char advance() => _nextCharOrElse(
        withNextChar: (Char c) => c,
        orElse: () => TokenType.eof().value,
        updateState: true,
      );

  void skip() => _nextCharOrElse(
        withNextChar: (Char c) => c,
        orElse: () => TokenType.eof().value,
        updateState: true,
      );

  bool nextMatches(Char target) => _nextCharOrElse(
        withNextChar: (Char c) => c == target,
        orElse: () => false,
      );

  bool nextMatchesAny(List<Char> targets) => _nextCharOrElse(
        withNextChar: (Char c) => targets.contains(c),
        orElse: () => false,
      );
}

library affogato.lsp_client;

// Generated using Google AI Studio based on https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/

/// Represents a Position in a text document (zero-based).
class Position {
  /// Line position in a document (zero-based).
  final int line;

  /// Character offset on a line in a document (zero-based).
  final int character;

  Position({
    required this.line,
    required this.character,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      line: json['line'] as int,
      character: json['character'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line': line,
      'character': character,
    };
  }

  @override
  String toString() => 'Position: line=$line, char=$character';
}

/// Represents a range in a text document.
class Range {
  /// The range's start position.
  final Position start;

  /// The range's end position.
  final Position end;

  Range({
    required this.start,
    required this.end,
  });

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      start: Position.fromJson(json['start'] as Map<String, dynamic>),
      end: Position.fromJson(json['end'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }

  @override
  String toString() => 'Range: start=$start, end=$end';
}

/// Represents a location in a resource, such as a text document.
class Location {
  /// The URI of the document representing the location.
  final String uri;

  /// The range of the location.
  final Range range;

  Location({
    required this.uri,
    required this.range,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      uri: json['uri'] as String,
      range: Range.fromJson(json['range'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      'range': range.toJson(),
    };
  }

  @override
  String toString() => 'Location: uri=$uri, range=$range';
}

/// Represents a diagnostic, such as a compiler error or warning.
class Diagnostic {
  /// The range at which the diagnostic applies.
  final Range range;

  /// The diagnostic's severity.
  final DiagnosticSeverity? severity;

  /// The diagnostic's code, which might appear in the user interface.
  final dynamic code; // Can be int or string

  /// A human-readable string describing the diagnostic.
  final String? message;

  /// A source code or file if the message comes from an external resource
  final String? source;

  Diagnostic({
    required this.range,
    this.severity,
    this.code,
    this.message,
    this.source,
  });

  factory Diagnostic.fromJson(Map<String, dynamic> json) {
    return Diagnostic(
      range: Range.fromJson(json['range'] as Map<String, dynamic>),
      severity: json['severity'] != null
          ? DiagnosticSeverity.fromJson(json['severity'] as int)
          : null,
      code: json['code'],
      message: json['message'] as String?,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range.toJson(),
      'severity': severity?.toJson(),
      'code': code,
      'message': message,
      'source': source,
    };
  }

  @override
  String toString() =>
      'Diagnostic: range=$range, severity=$severity, code=$code, message=$message, source=$source';
}

/// The severity of a diagnostic.
class DiagnosticSeverity {
  static const int error = 1;
  static const int warning = 2;
  static const int information = 3;
  static const int hint = 4;

  final int value;

  DiagnosticSeverity(this.value);

  factory DiagnosticSeverity.fromJson(int json) {
    return DiagnosticSeverity(json);
  }

  int toJson() => value;

  @override
  String toString() => 'DiagnosticSeverity: $value';
}

/// Represents a command that can be executed in the editor.
class Command {
  /// A human-readable title of the command.
  final String title;

  /// The identifier of the actual command handler.
  final String command;

  /// Arguments that the command handler should be invoked with.
  final List<dynamic>? arguments;

  Command({
    required this.title,
    required this.command,
    this.arguments,
  });

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      title: json['title'] as String,
      command: json['command'] as String,
      arguments: json['arguments'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'command': command,
      'arguments': arguments,
    };
  }

  @override
  String toString() =>
      'Command: title=$title, command=$command, args=$arguments';
}

/// Represents a text edit which describes changes to a text document.
class TextEdit {
  /// The range of the text document to be manipulated. To delete text,
  /// the range.start must equal range.end.
  final Range range;

  /// The string to be inserted. For delete operations, the string must be empty.
  final String text;

  TextEdit({
    required this.range,
    required this.text,
  });

  factory TextEdit.fromJson(Map<String, dynamic> json) {
    return TextEdit(
      range: Range.fromJson(json['range'] as Map<String, dynamic>),
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range.toJson(),
      'text': text,
    };
  }

  @override
  String toString() => 'TextEdit: range=$range, text=$text';
}

/// Represents a workspace edit
class WorkspaceEdit {
  /// Holds changes to existing resources.
  final Map<String, List<TextEdit>>? changes;

  WorkspaceEdit({this.changes});

  factory WorkspaceEdit.fromJson(Map<String, dynamic> json) {
    final changesJson = json['changes'] as Map<String, dynamic>?;
    Map<String, List<TextEdit>>? changes;

    if (changesJson != null) {
      changes = changesJson.map((uri, edits) {
        return MapEntry(
          uri,
          (edits as List<dynamic>)
              .map((edit) => TextEdit.fromJson(edit as Map<String, dynamic>))
              .toList(),
        );
      });
    }

    return WorkspaceEdit(changes: changes);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? changesJson;
    if (changes != null) {
      changesJson = changes!.map((uri, edits) {
        return MapEntry(
          uri,
          edits.map((edit) => edit.toJson()).toList(),
        );
      });
    }
    return {'changes': changesJson};
  }

  @override
  String toString() => 'WorkspaceEdit: changes=$changes';
}

class TextDocumentItem {}

sealed class ServerResponse {
  ServerResponse.fromJson(Map<String, dynamic> json);
}

class CompletionRequestResponse extends ServerResponse {
  CompletionRequestResponse.fromJson(super.json) : super.fromJson();
}

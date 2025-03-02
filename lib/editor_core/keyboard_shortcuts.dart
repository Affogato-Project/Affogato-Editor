part of affogato.editor;

/// This class is responsible for detecting the start/end of keyboard shortcuts and for
/// firing callbacks for registered [shortcuts].
class KeyboardShortcutsDispatcher {
  final List<LogicalKeyboardKey> sequence = [];
  final Map<String, VoidCallback> shortcuts = {};

  KeyboardShortcutsDispatcher() {
    AffogatoEvents.windowKeyboardEvents.stream.listen((event) {
      if (event.keyEvent is KeyUpEvent) {
        sequence.clear();
        return;
      } else if (event.keyEvent is KeyRepeatEvent) {
        return;
      }
      if (sequence.isNotEmpty) {
        if (event.keyEvent.logicalKey == LogicalKeyboardKey.escape) {
          // handle aborts
          sequence.clear();
        } else if (sequence.length > 8) {
          // just in case we wrongly pick up normal text editing actions as key sequences
          sequence.clear();
        } else {
          sequence.add(event.keyEvent.logicalKey);
          final String signature = signatureOf(sequence);
          // dispatch the corresponding shortcut
          if (shortcuts.containsKey(signature)) {
            shortcuts[signature]!.call();
            sequence.clear();
          }
        }
      } else if ([
        LogicalKeyboardKey.metaLeft,
        LogicalKeyboardKey.metaRight,
        LogicalKeyboardKey.altLeft,
        LogicalKeyboardKey.altRight,
      ].contains(event.keyEvent.logicalKey)) {
        sequence.add(event.keyEvent.logicalKey);
      }
    });
  }

  void overrideShortcut(
    List<LogicalKeyboardKey> sequence,
    VoidCallback callback,
  ) =>
      shortcuts[signatureOf(sequence)] = callback;

  /// Generates a signature for a keyboard shortcut's key sequence
  String signatureOf(List<LogicalKeyboardKey> sequence) =>
      [for (final key in sequence) key.keyId].join(' ');
}

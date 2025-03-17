part of affogato.apis;

/// Generates a [Map] whose keys are of type [K] and values type [V].
/// This provides a better way to natively define token mappings, by allowing
/// token scopes to be grouped, named, and for text styles to be overriden.
abstract class TokenMapping<K, V> {
  final Map<K, V> mapping = {};
  final V defaultStyle;

  TokenMapping({
    required this.defaultStyle,
  });

  /// Adds a new scope setting
  void scope(List<K> names, {required V settings}) {
    for (final name in names) {
      mapping[name] = settings;
    }
  }
}

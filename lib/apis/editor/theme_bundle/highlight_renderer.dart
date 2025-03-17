part of affogato.apis;

/// A [SyntaxTokenRenderer]'s job is to take a sequence of highlighted tokens, each of type
/// [T], and produce an output object of type [D] that can be directly shown by the editor.
abstract class SyntaxTokenRenderer<T, D> {
  D render(T tokens);
}

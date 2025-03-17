part of affogato.apis;

class AST {
  final List<ASTNode> nodes;

  AST({required this.nodes});

  List<TerminalASTNode> get terminalNodes {
    final List<TerminalASTNode> res = [];
    for (final n in nodes) {
      if (n is TerminalASTNode) {
        res.add(n);
      } else {
        res.addAll((n as NonTerminalASTNode).findAllTerminals());
      }
    }
    return res
      ..sort((n1, n2) {
        if (n1.start < n2.start) {
          return -1;
        } else if (n1.start > n2.start) {
          return 1;
        } else {
          return 0;
        }
      });
  }

  String reconstructSource() => terminalNodes.map((e) => e.lexeme).join();
}

abstract class ASTNode {
  final String name;

  ASTNode(this.name);
  String lexemeRepresentation();
}

abstract class NonTerminalASTNode extends ASTNode {
  NonTerminalASTNode(super.name);

  CursorLocation get start;
  CursorLocation get end;

  List<TerminalASTNode> findAllTerminals();
  @override
  String lexemeRepresentation() =>
      findAllTerminals().map((t) => t.lexeme).join();
}

abstract class TerminalASTNode extends ASTNode {
  final List<String> scopes;
  final List<Token> tokens = [];

  TerminalASTNode(super.name, {required this.scopes});

  String get lexeme => [for (final tok in tokens) tok.lexeme].join();

  CursorLocation get start => tokens.first.start;
  CursorLocation get end => tokens.last.end;
  @override
  String lexemeRepresentation() => lexeme;
  String toPrettyString([int indent = 1]) =>
      "|- $name ${tokens.first.start}..${tokens.last.end} [${[
        for (final tok in tokens) tok.lexeme
      ].join(', ')}]";
}

class InsignificantASTNode extends TerminalASTNode {
  InsignificantASTNode()
      : super('InsignificantASTNode', scopes: ['insignificant']);
}

class ErroneousASTNode extends TerminalASTNode {
  ErroneousASTNode() : super('ErroneousASTNode', scopes: ['error']);
}

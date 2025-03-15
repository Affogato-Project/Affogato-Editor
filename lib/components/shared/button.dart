part of affogato.editor;

class AffogatoButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool isPrimary;
  final AffogatoAPI api;

  const AffogatoButton({
    required this.width,
    required this.height,
    required this.child,
    required this.onTap,
    required this.isPrimary,
    required this.api,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => AffogatoButtonState();
}

class AffogatoButtonState extends State<AffogatoButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    final Color? buttonColor;
    if (hovered) {
      if (widget.isPrimary) {
        buttonColor = widget.api.workspace.workspaceConfigs.themeBundle.editorTheme.buttonHoverBackground;
      } else {
        buttonColor = widget.api.workspace.workspaceConfigs.themeBundle.editorTheme.buttonSecondaryHoverBackground;
      }
    } else {
      buttonColor = Colors.transparent;
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        hovered = true;
      }),
      onExit: (_) => setState(() {
        hovered = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Center(
          child: Container(
            width: widget.width,
            height: widget.height,
            color: buttonColor ?? Colors.red,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

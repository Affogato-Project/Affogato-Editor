part of affogato.editor;

typedef FileTabDragData = ({String instanceId, String paneId});

class FileTab extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onClose;
  final double height;
  final EditorTheme<Color, TextStyle> editorTheme;
  final Color activeColor;
  final bool isCurrent;
  final String label;
  final String instanceId;
  final String paneId;

  const FileTab({
    required this.label,
    required this.paneId,
    required this.instanceId,
    required this.onTap,
    required this.onClose,
    required this.height,
    required this.editorTheme,
    required this.activeColor,
    required this.isCurrent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<FileTabDragData>(
      data: (instanceId: instanceId, paneId: paneId),
      feedback: Material(
        child: renderChild(context),
      ),
      child: renderChild(context),
    );
  }

  Widget renderChild(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: activeColor,
              border: Border(
                right: BorderSide(
                  color: editorTheme.tabBorder ?? Colors.red,
                ),
                top: BorderSide(
                  color: (isCurrent
                          ? editorTheme.tabActiveBorderTop
                          : editorTheme.tabBorder) ??
                      Colors.red,
                ),
                bottom: BorderSide(
                  color: isCurrent
                      ? activeColor
                      : editorTheme.editorGroupHeaderTabsBorder ?? Colors.red,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: utils.AffogatoConstants.tabBarPadding,
                bottom: utils.AffogatoConstants.tabBarPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isCurrent
                          ? editorTheme.tabActiveForeground
                          : editorTheme.tabInactiveForeground,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: onClose,
                    icon: Icon(
                      Icons.close,
                      size: 14,
                      color: isCurrent
                          ? editorTheme.tabActiveForeground
                          : editorTheme.tabInactiveForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

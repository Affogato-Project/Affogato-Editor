part of affogato.editor;

class SearchAndReplaceWidget extends StatefulWidget {
  final void Function(String) onSearchTextChanged;
  final void Function(String) onReplaceTextChanged;
  final double width;
  final EditorTheme<Color, TextStyle> editorTheme;
  final TextStyle textStyle;
  final List<Widget> searchActionItems;
  final List<Widget> replaceActionItems;

  const SearchAndReplaceWidget({
    required this.textStyle,
    required this.width,
    required this.onSearchTextChanged,
    required this.onReplaceTextChanged,
    required this.searchActionItems,
    required this.replaceActionItems,
    required this.editorTheme,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => SearchAndReplaceWidgetState();
}

class SearchAndReplaceWidgetState extends State<SearchAndReplaceWidget> {
  final FocusNode searchFieldFocusNode = FocusNode();
  final FocusNode replaceFieldFocusNode = FocusNode();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: isExpanded
          ? utils.AffogatoConstants.searchAndReplaceRowItemHeight * 2 +
              utils.AffogatoConstants.searchAndReplacePadding * 3
          : utils.AffogatoConstants.searchAndReplaceRowItemHeight +
              utils.AffogatoConstants.searchAndReplacePadding * 2,
      decoration: BoxDecoration(
        color: widget.editorTheme.editorBackground,
        border: Border(
          left: BorderSide(
            color: widget.editorTheme.tabBorder ?? Colors.red,
          ),
          right: BorderSide(
            color: widget.editorTheme.tabBorder ?? Colors.red,
          ),
          bottom: BorderSide(
            color: widget.editorTheme.tabBorder ?? Colors.red,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          AffogatoButton(
            editorTheme: widget.editorTheme,
            isPrimary: false,
            width: 28,
            height: isExpanded
                ? utils.AffogatoConstants.searchAndReplaceRowItemHeight * 2 +
                    utils.AffogatoConstants.searchAndReplacePadding * 3
                : utils.AffogatoConstants.searchAndReplaceRowItemHeight +
                    utils.AffogatoConstants.searchAndReplacePadding * 2,
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Icon(
              isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
              size: utils.AffogatoConstants.searchAndReplaceRowItemHeight,
              color: Colors.grey,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: utils.AffogatoConstants.searchAndReplaceRowItemHeight,
                width: utils.AffogatoConstants.searchAndReplaceTextFieldWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: widget.textStyle,
                        onChanged: widget.onSearchTextChanged,
                        focusNode: searchFieldFocusNode,
                        decoration: InputDecoration(
                          fillColor: widget.editorTheme.inputBackground,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: (searchFieldFocusNode.hasFocus
                                      ? widget.editorTheme.inputBorder
                                      : Colors.green) ??
                                  Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: utils.AffogatoConstants.searchAndReplacePadding),
                    ...widget.searchActionItems,
                  ],
                ),
              ),
              if (isExpanded)
                SizedBox(
                  height: utils.AffogatoConstants.searchAndReplaceRowItemHeight,
                  width: utils.AffogatoConstants.searchAndReplaceTextFieldWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: widget.editorTheme.inputBackground,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (searchFieldFocusNode.hasFocus
                                        ? widget.editorTheme.inputBorder
                                        : Colors.green) ??
                                    Colors.red,
                              ),
                            ),
                          ),
                          style: widget.textStyle,
                          focusNode: replaceFieldFocusNode,
                          onChanged: widget.onReplaceTextChanged,
                        ),
                      ),
                      const SizedBox(
                          width:
                              utils.AffogatoConstants.searchAndReplacePadding),
                      ...widget.replaceActionItems,
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

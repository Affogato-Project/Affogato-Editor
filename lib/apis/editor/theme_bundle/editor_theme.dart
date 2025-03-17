part of affogato.apis;

class EditorTheme<C, Y> {
  final Y defaultTextStyle;
  final C? checkboxBorder;
  final C? editorBackground;
  final C? editorForeground;
  final C?
      editorInactiveSelectionBackgroundAndTerminalInactiveSelectionBackground;
  final C? editorIndentGuideBackground1;
  final C? editorIndentGuideActiveBackground1;
  final C? editorSelectionHighlightBackground;
  final C? listDropBackground;
  final C? activityBarBadgeBackground;
  final C? sideBarTitleForeground;
  final C? inputPlaceholderForeground;
  final C? menuBackground;
  final C? menuForeground;
  final C? menuSeparatorAndBorderBackground;
  final C? menuSelectionBackground;
  final C? statusBarItemRemoteForeground;
  final C? statusBarItemRemoteBackground;
  final C? portsIconRunningProcessForeground;
  final C? sideBarSectionHeaderBackground;
  final C? sideBarSectionHeaderBorder;
  final C? tabSelectedBackground;
  final C? tabSelectedForeground;
  final C? tabLastPinnedBorder;
  final C? listActiveSelectionIconForeground;
  final C? widgetBorder;
  final C? actionBarToggledBackground;
  final C? activityBarActiveBorder;
  final C? activityBarBackground;
  final C? activityBarBorder;
  final C? activityBarForeground;
  final C? activityBarInactiveForeground;
  final C? activityBarBadgeForeground;
  final C? badgeBackground;
  final C? badgeForeground;
  final C? buttonBackground;
  final C? buttonBorder;
  final C? buttonForeground;
  final C? buttonHoverBackground;
  final C? buttonSecondaryBackground;
  final C? buttonSecondaryForeground;
  final C? buttonSecondaryHoverBackground;
  final C? chatSlashCommandBackground;
  final C? chatSlashCommandForeground;
  final C? chatEditedFileForeground;
  final C? checkboxBackground;
  final C? debugToolBarBackground;
  final C? descriptionForeground;
  final C? dropdownBackground;
  final C? dropdownBorder;
  final C? dropdownForeground;
  final C? dropdownListBackground;
  final C? editorFindMatchBackground;
  final C? editorGroupBorder;
  final C? editorGroupHeaderTabsBackground;
  final C? editorGroupHeaderTabsBorder;
  final C? editorGutterAddedBackground;
  final C? editorGutterDeletedBackground;
  final C? editorGutterModifiedBackground;
  final C? editorLineNumberActiveForeground;
  final C? editorLineNumberForeground;
  final C? editorOverviewRulerBorder;
  final C? editorWidgetBackground;
  final C? errorForeground;
  final C? focusBorder;
  final C? foreground;
  final C? iconForeground;
  final C? inputBackground;
  final C? inputBorder;
  final C? inputForeground;
  final C? inputOptionActiveBackground;
  final C? inputOptionActiveBorder;
  final C? keybindingLabelForeground;
  final C? notificationCenterHeaderBackground;
  final C? notificationCenterHeaderForeground;
  final C? notificationsBackground;
  final C? notificationsBorder;
  final C? notificationsForeground;
  final C? panelBackground;
  final C? panelBorder;
  final C? panelInputBorder;
  final C? panelTitleActiveBorder;
  final C? panelTitleActiveForeground;
  final C? panelTitleInactiveForeground;
  final C? peekViewEditorBackground;
  final C? peekViewEditorMatchHighlightBackground;
  final C? peekViewResultBackground;
  final C? peekViewResultMatchHighlightBackground;
  final C? pickerGroupBorder;
  final C? progressBarBackground;
  final C? quickInputBackground;
  final C? quickInputForeground;
  final C? settingsDropdownBackground;
  final C? settingsDropdownBorder;
  final C? settingsHeaderForeground;
  final C? settingsModifiedItemIndicator;
  final C? sideBarBackground;
  final C? sideBarBorder;
  final C? sideBarForeground;
  final C? sideBarSectionHeaderForeground;
  final C? statusBarBackground;
  final C? statusBarBorder;
  final C? statusBarDebuggingBackground;
  final C? statusBarDebuggingForeground;
  final C? statusBarFocusBorder;
  final C? statusBarForeground;
  final C? statusBarNoFolderBackground;
  final C? statusBarItemFocusBorder;
  final C? statusBarItemProminentBackground;
  final C? tabActiveBackground;
  final C? tabActiveBorder;
  final C? tabActiveBorderTop;
  final C? tabActiveForeground;
  final C? tabSelectedBorderTop;
  final C? tabBorder;
  final C? tabHoverBackground;
  final C? tabInactiveBackground;
  final C? tabInactiveForeground;
  final C? tabUnfocusedActiveBorder;
  final C? tabUnfocusedActiveBorderTop;
  final C? tabUnfocusedHoverBackground;
  final C? terminalForeground;
  final C? terminalTabActiveBorder;
  final C? textBlockQuoteBackground;
  final C? textBlockQuoteBorder;
  final C? textCodeBlockBackground;
  final C? textLinkActiveForeground;
  final C? textLinkForeground;
  final C? textPreformatForeground;
  final C? textPreformatBackground;
  final C? textSeparatorForeground;
  final C? titleBarActiveBackground;
  final C? titleBarActiveForeground;
  final C? titleBarBorder;
  final C? titleBarInactiveBackground;
  final C? titleBarInactiveForeground;
  final C? welcomePageTileBackground;
  final C? welcomePageProgressForeground;

  EditorTheme({
    required this.defaultTextStyle,
    this.checkboxBorder,
    this.editorBackground,
    this.editorForeground,
    this.editorInactiveSelectionBackgroundAndTerminalInactiveSelectionBackground,
    this.editorIndentGuideBackground1,
    this.editorIndentGuideActiveBackground1,
    this.editorSelectionHighlightBackground,
    this.listDropBackground,
    this.activityBarBadgeBackground,
    this.sideBarTitleForeground,
    this.inputPlaceholderForeground,
    this.menuBackground,
    this.menuForeground,
    this.menuSeparatorAndBorderBackground,
    this.menuSelectionBackground,
    this.statusBarItemRemoteForeground,
    this.statusBarItemRemoteBackground,
    this.portsIconRunningProcessForeground,
    this.sideBarSectionHeaderBackground,
    this.sideBarSectionHeaderBorder,
    this.tabSelectedBackground,
    this.tabSelectedForeground,
    this.tabLastPinnedBorder,
    this.listActiveSelectionIconForeground,
    this.widgetBorder,
    this.actionBarToggledBackground,
    this.activityBarActiveBorder,
    this.activityBarBackground,
    this.activityBarBorder,
    this.activityBarForeground,
    this.activityBarInactiveForeground,
    this.activityBarBadgeForeground,
    this.badgeBackground,
    this.badgeForeground,
    this.buttonBackground,
    this.buttonBorder,
    this.buttonForeground,
    this.buttonHoverBackground,
    this.buttonSecondaryBackground,
    this.buttonSecondaryForeground,
    this.buttonSecondaryHoverBackground,
    this.chatSlashCommandBackground,
    this.chatSlashCommandForeground,
    this.chatEditedFileForeground,
    this.checkboxBackground,
    this.debugToolBarBackground,
    this.descriptionForeground,
    this.dropdownBackground,
    this.dropdownBorder,
    this.dropdownForeground,
    this.dropdownListBackground,
    this.editorFindMatchBackground,
    this.editorGroupBorder,
    this.editorGroupHeaderTabsBackground,
    this.editorGroupHeaderTabsBorder,
    this.editorGutterAddedBackground,
    this.editorGutterDeletedBackground,
    this.editorGutterModifiedBackground,
    this.editorLineNumberActiveForeground,
    this.editorLineNumberForeground,
    this.editorOverviewRulerBorder,
    this.editorWidgetBackground,
    this.errorForeground,
    this.focusBorder,
    this.foreground,
    this.iconForeground,
    this.inputBackground,
    this.inputBorder,
    this.inputForeground,
    this.inputOptionActiveBackground,
    this.inputOptionActiveBorder,
    this.keybindingLabelForeground,
    this.notificationCenterHeaderBackground,
    this.notificationCenterHeaderForeground,
    this.notificationsBackground,
    this.notificationsBorder,
    this.notificationsForeground,
    this.panelBackground,
    this.panelBorder,
    this.panelInputBorder,
    this.panelTitleActiveBorder,
    this.panelTitleActiveForeground,
    this.panelTitleInactiveForeground,
    this.peekViewEditorBackground,
    this.peekViewEditorMatchHighlightBackground,
    this.peekViewResultBackground,
    this.peekViewResultMatchHighlightBackground,
    this.pickerGroupBorder,
    this.progressBarBackground,
    this.quickInputBackground,
    this.quickInputForeground,
    this.settingsDropdownBackground,
    this.settingsDropdownBorder,
    this.settingsHeaderForeground,
    this.settingsModifiedItemIndicator,
    this.sideBarBackground,
    this.sideBarBorder,
    this.sideBarForeground,
    this.sideBarSectionHeaderForeground,
    this.statusBarBackground,
    this.statusBarBorder,
    this.statusBarDebuggingBackground,
    this.statusBarDebuggingForeground,
    this.statusBarFocusBorder,
    this.statusBarForeground,
    this.statusBarNoFolderBackground,
    this.statusBarItemFocusBorder,
    this.statusBarItemProminentBackground,
    this.tabActiveBackground,
    this.tabActiveBorder,
    this.tabActiveBorderTop,
    this.tabActiveForeground,
    this.tabSelectedBorderTop,
    this.tabBorder,
    this.tabHoverBackground,
    this.tabInactiveBackground,
    this.tabInactiveForeground,
    this.tabUnfocusedActiveBorder,
    this.tabUnfocusedActiveBorderTop,
    this.tabUnfocusedHoverBackground,
    this.terminalForeground,
    this.terminalTabActiveBorder,
    this.textBlockQuoteBackground,
    this.textBlockQuoteBorder,
    this.textCodeBlockBackground,
    this.textLinkActiveForeground,
    this.textLinkForeground,
    this.textPreformatForeground,
    this.textPreformatBackground,
    this.textSeparatorForeground,
    this.titleBarActiveBackground,
    this.titleBarActiveForeground,
    this.titleBarBorder,
    this.titleBarInactiveBackground,
    this.titleBarInactiveForeground,
    this.welcomePageTileBackground,
    this.welcomePageProgressForeground,
  });
}

class VSCodeEditorTheme<C, Y> extends EditorTheme<C, Y> {
  final C? Function(String?) parseColor;
  final String? Function(C?) colorToString;

  VSCodeEditorTheme({
    required this.parseColor,
    required this.colorToString,
    required super.defaultTextStyle,
  });

  VSCodeEditorTheme.fromJson(
    Map<String, dynamic> json, {
    required this.parseColor,
    required this.colorToString,
    required super.defaultTextStyle,
  }) : super(
          checkboxBorder: parseColor(json['checkbox.border']),
          editorBackground: parseColor(json['editor.background']),
          editorForeground: parseColor(json['editor.foreground']),
          editorInactiveSelectionBackgroundAndTerminalInactiveSelectionBackground:
              parseColor(json['editor.inactiveSelectionBackground'] ??
                  json['terminal.inactiveSelectionBackground']),
          editorIndentGuideBackground1:
              parseColor(json['editorIndentGuide.background1']),
          editorIndentGuideActiveBackground1:
              parseColor(json['editorIndentGuide.activeBackground1']),
          editorSelectionHighlightBackground:
              parseColor(json['editor.selectionHighlightBackground']),
          listDropBackground: parseColor(json['list.dropBackground']),
          activityBarBadgeBackground:
              parseColor(json['activityBarBadge.background']),
          sideBarTitleForeground: parseColor(json['sideBarTitle.foreground']),
          inputPlaceholderForeground:
              parseColor(json['input.placeholderForeground']),
          menuBackground: parseColor(json['menu.background']),
          menuForeground: parseColor(json['menu.foreground']),
          menuSeparatorAndBorderBackground: parseColor(
              json['menu.separatorBackground'] ?? json['menu.border']),
          menuSelectionBackground: parseColor(json['menu.selectionBackground']),
          statusBarItemRemoteForeground:
              parseColor(json['statusBarItem.remoteForeground']),
          statusBarItemRemoteBackground:
              parseColor(json['statusBarItem.remoteBackground']),
          portsIconRunningProcessForeground:
              parseColor(json['ports.iconRunningProcessForeground']),
          sideBarSectionHeaderBackground:
              parseColor(json['sideBarSectionHeader.background']),
          sideBarSectionHeaderBorder:
              parseColor(json['sideBarSectionHeader.border']),
          tabSelectedBackground: parseColor(json['tab.selectedBackground']),
          tabSelectedForeground: parseColor(json['tab.selectedForeground']),
          tabLastPinnedBorder: parseColor(json['tab.lastPinnedBorder']),
          listActiveSelectionIconForeground:
              parseColor(json['list.activeSelectionIconForeground']),
          widgetBorder: parseColor(json['widget.border']),
          actionBarToggledBackground:
              parseColor(json['actionBar.toggledBackground']),
          activityBarActiveBorder: parseColor(json['activityBar.activeBorder']),
          activityBarBackground: parseColor(json['activityBar.background']),
          activityBarBorder: parseColor(json['activityBar.border']),
          activityBarForeground: parseColor(json['activityBar.foreground']),
          activityBarInactiveForeground:
              parseColor(json['activityBar.inactiveForeground']),
          activityBarBadgeForeground:
              parseColor(json['activityBarBadge.foreground']),
          badgeBackground: parseColor(json['badge.background']),
          badgeForeground: parseColor(json['badge.foreground']),
          buttonBackground: parseColor(json['button.background']),
          buttonBorder: parseColor(json['button.border']),
          buttonForeground: parseColor(json['button.foreground']),
          buttonHoverBackground: parseColor(json['button.hoverBackground']),
          buttonSecondaryBackground:
              parseColor(json['button.secondaryBackground']),
          buttonSecondaryForeground:
              parseColor(json['button.secondaryForeground']),
          buttonSecondaryHoverBackground:
              parseColor(json['button.secondaryHoverBackground']),
          chatSlashCommandBackground:
              parseColor(json['chat.slashCommandBackground']),
          chatSlashCommandForeground:
              parseColor(json['chat.slashCommandForeground']),
          chatEditedFileForeground:
              parseColor(json['chat.editedFileForeground']),
          checkboxBackground: parseColor(json['checkbox.background']),
          debugToolBarBackground: parseColor(json['debugToolBar.background']),
          descriptionForeground: parseColor(json['descriptionForeground']),
          dropdownBackground: parseColor(json['dropdown.background']),
          dropdownBorder: parseColor(json['dropdown.border']),
          dropdownForeground: parseColor(json['dropdown.foreground']),
          dropdownListBackground: parseColor(json['dropdown.listBackground']),
          editorFindMatchBackground:
              parseColor(json['editor.findMatchBackground']),
          editorGroupBorder: parseColor(json['editorGroup.border']),
          editorGroupHeaderTabsBackground:
              parseColor(json['editorGroupHeader.tabsBackground']),
          editorGroupHeaderTabsBorder:
              parseColor(json['editorGroupHeader.tabsBorder']),
          editorGutterAddedBackground:
              parseColor(json['editorGutter.addedBackground']),
          editorGutterDeletedBackground:
              parseColor(json['editorGutter.deletedBackground']),
          editorGutterModifiedBackground:
              parseColor(json['editorGutter.modifiedBackground']),
          editorLineNumberActiveForeground:
              parseColor(json['editorLineNumber.activeForeground']),
          editorLineNumberForeground:
              parseColor(json['editorLineNumber.foreground']),
          editorOverviewRulerBorder:
              parseColor(json['editorOverviewRuler.border']),
          editorWidgetBackground: parseColor(json['editorWidget.background']),
          errorForeground: parseColor(json['errorForeground']),
          focusBorder: parseColor(json['focusBorder']),
          foreground: parseColor(json['foreground']),
          iconForeground: parseColor(json['icon.foreground']),
          inputBackground: parseColor(json['input.background']),
          inputBorder: parseColor(json['input.border']),
          inputForeground: parseColor(json['input.foreground']),
          inputOptionActiveBackground:
              parseColor(json['inputOption.activeBackground']),
          inputOptionActiveBorder: parseColor(json['inputOption.activeBorder']),
          keybindingLabelForeground:
              parseColor(json['keybindingLabel.foreground']),
          notificationCenterHeaderBackground:
              parseColor(json['notificationCenterHeader.background']),
          notificationCenterHeaderForeground:
              parseColor(json['notificationCenterHeader.foreground']),
          notificationsBackground: parseColor(json['notifications.background']),
          notificationsBorder: parseColor(json['notifications.border']),
          notificationsForeground: parseColor(json['notifications.foreground']),
          panelBackground: parseColor(json['panel.background']),
          panelBorder: parseColor(json['panel.border']),
          panelInputBorder: parseColor(json['panelInput.border']),
          panelTitleActiveBorder: parseColor(json['panelTitle.activeBorder']),
          panelTitleActiveForeground:
              parseColor(json['panelTitle.activeForeground']),
          panelTitleInactiveForeground:
              parseColor(json['panelTitle.inactiveForeground']),
          peekViewEditorBackground:
              parseColor(json['peekViewEditor.background']),
          peekViewEditorMatchHighlightBackground:
              parseColor(json['peekViewEditor.matchHighlightBackground']),
          peekViewResultBackground:
              parseColor(json['peekViewResult.background']),
          peekViewResultMatchHighlightBackground:
              parseColor(json['peekViewResult.matchHighlightBackground']),
          pickerGroupBorder: parseColor(json['pickerGroup.border']),
          progressBarBackground: parseColor(json['progressBar.background']),
          quickInputBackground: parseColor(json['quickInput.background']),
          quickInputForeground: parseColor(json['quickInput.foreground']),
          settingsDropdownBackground:
              parseColor(json['settings.dropdownBackground']),
          settingsDropdownBorder: parseColor(json['settings.dropdownBorder']),
          settingsHeaderForeground:
              parseColor(json['settings.headerForeground']),
          settingsModifiedItemIndicator:
              parseColor(json['settings.modifiedItemIndicator']),
          sideBarBackground: parseColor(json['sideBar.background']),
          sideBarBorder: parseColor(json['sideBar.border']),
          sideBarForeground: parseColor(json['sideBar.foreground']),
          sideBarSectionHeaderForeground:
              parseColor(json['sideBarSectionHeader.foreground']),
          statusBarBackground: parseColor(json['statusBar.background']),
          statusBarBorder: parseColor(json['statusBar.border']),
          statusBarDebuggingBackground:
              parseColor(json['statusBar.debuggingBackground']),
          statusBarDebuggingForeground:
              parseColor(json['statusBar.debuggingForeground']),
          statusBarFocusBorder: parseColor(json['statusBar.focusBorder']),
          statusBarForeground: parseColor(json['statusBar.foreground']),
          statusBarNoFolderBackground:
              parseColor(json['statusBar.noFolderBackground']),
          statusBarItemFocusBorder:
              parseColor(json['statusBarItem.focusBorder']),
          statusBarItemProminentBackground:
              parseColor(json['statusBarItem.prominentBackground']),
          tabActiveBackground: parseColor(json['tab.activeBackground']),
          tabActiveBorder: parseColor(json['tab.activeBorder']),
          tabActiveBorderTop: parseColor(json['tab.activeBorderTop']),
          tabActiveForeground: parseColor(json['tab.activeForeground']),
          tabSelectedBorderTop: parseColor(json['tab.selectedBorderTop']),
          tabBorder: parseColor(json['tab.border']),
          tabHoverBackground: parseColor(json['tab.hoverBackground']),
          tabInactiveBackground: parseColor(json['tab.inactiveBackground']),
          tabInactiveForeground: parseColor(json['tab.inactiveForeground']),
          tabUnfocusedActiveBorder:
              parseColor(json['tab.unfocusedActiveBorder']),
          tabUnfocusedActiveBorderTop:
              parseColor(json['tab.unfocusedActiveBorderTop']),
          tabUnfocusedHoverBackground:
              parseColor(json['tab.unfocusedHoverBackground']),
          terminalForeground: parseColor(json['terminal.foreground']),
          terminalTabActiveBorder:
              parseColor(json['terminal.tab.activeBorder']),
          textBlockQuoteBackground:
              parseColor(json['textBlockQuote.background']),
          textBlockQuoteBorder: parseColor(json['textBlockQuote.border']),
          textCodeBlockBackground: parseColor(json['textCodeBlock.background']),
          textLinkActiveForeground:
              parseColor(json['textLink.activeForeground']),
          textLinkForeground: parseColor(json['textLink.foreground']),
          textPreformatForeground: parseColor(json['textPreformat.foreground']),
          textPreformatBackground: parseColor(json['textPreformat.background']),
          textSeparatorForeground: parseColor(json['textSeparator.foreground']),
          titleBarActiveBackground:
              parseColor(json['titleBar.activeBackground']),
          titleBarActiveForeground:
              parseColor(json['titleBar.activeForeground']),
          titleBarBorder: parseColor(json['titleBar.border']),
          titleBarInactiveBackground:
              parseColor(json['titleBar.inactiveBackground']),
          titleBarInactiveForeground:
              parseColor(json['titleBar.inactiveForeground']),
          welcomePageTileBackground:
              parseColor(json['welcomePage.tileBackground']),
          welcomePageProgressForeground:
              parseColor(json['welcomePage.progress.foreground']),
        );

  Map<String, dynamic> toJson() => {
        'checkbox.border': colorToString(checkboxBorder),
        'editor.background': colorToString(editorBackground),
        'editor.foreground': colorToString(editorForeground),
        'editor.inactiveSelectionBackground': colorToString(
            editorInactiveSelectionBackgroundAndTerminalInactiveSelectionBackground),
        'terminal.inactiveSelectionBackground': colorToString(
            editorInactiveSelectionBackgroundAndTerminalInactiveSelectionBackground),
        'editorIndentGuide.background1':
            colorToString(editorIndentGuideBackground1),
        'editorIndentGuide.activeBackground1':
            colorToString(editorIndentGuideActiveBackground1),
        'editor.selectionHighlightBackground':
            colorToString(editorSelectionHighlightBackground),
        'list.dropBackground': colorToString(listDropBackground),
        'activityBarBadge.background':
            colorToString(activityBarBadgeBackground),
        'sideBarTitle.foreground': colorToString(sideBarTitleForeground),
        'input.placeholderForeground':
            colorToString(inputPlaceholderForeground),
        'menu.background': colorToString(menuBackground),
        'menu.foreground': colorToString(menuForeground),
        'menu.separatorBackground':
            colorToString(menuSeparatorAndBorderBackground),
        'menu.border': colorToString(menuSeparatorAndBorderBackground),
        'menu.selectionBackground': colorToString(menuSelectionBackground),
        'statusBarItem.remoteForeground':
            colorToString(statusBarItemRemoteForeground),
        'statusBarItem.remoteBackground':
            colorToString(statusBarItemRemoteBackground),
        'ports.iconRunningProcessForeground':
            colorToString(portsIconRunningProcessForeground),
        'sideBarSectionHeader.background':
            colorToString(sideBarSectionHeaderBackground),
        'sideBarSectionHeader.border':
            colorToString(sideBarSectionHeaderBorder),
        'tab.selectedBackground': colorToString(tabSelectedBackground),
        'tab.selectedForeground': colorToString(tabSelectedForeground),
        'tab.lastPinnedBorder': colorToString(tabLastPinnedBorder),
        'list.activeSelectionIconForeground':
            colorToString(listActiveSelectionIconForeground),
        'widget.border': colorToString(widgetBorder),
        'actionBar.toggledBackground':
            colorToString(actionBarToggledBackground),
        'activityBar.activeBorder': colorToString(activityBarActiveBorder),
        'activityBar.background': colorToString(activityBarBackground),
        'activityBar.border': colorToString(activityBarBorder),
        'activityBar.foreground': colorToString(activityBarForeground),
        'activityBar.inactiveForeground':
            colorToString(activityBarInactiveForeground),
        'activityBarBadge.foreground':
            colorToString(activityBarBadgeForeground),
        'badge.background': colorToString(badgeBackground),
        'badge.foreground': colorToString(badgeForeground),
        'button.background': colorToString(buttonBackground),
        'button.border': colorToString(buttonBorder),
        'button.foreground': buttonForeground,
        'button.hoverBackground': buttonHoverBackground,
        'button.secondaryBackground': buttonSecondaryBackground,
        'button.secondaryForeground': buttonSecondaryForeground,
        'button.secondaryHoverBackground': buttonSecondaryHoverBackground,
        'chat.slashCommandBackground':
            colorToString(chatSlashCommandBackground),
        'chat.slashCommandForeground':
            colorToString(chatSlashCommandForeground),
        'chat.editedFileForeground': colorToString(chatEditedFileForeground),
        'checkbox.background': colorToString(checkboxBackground),
        'debugToolBar.background': colorToString(debugToolBarBackground),
        'descriptionForeground': colorToString(descriptionForeground),
        'dropdown.background': colorToString(dropdownBackground),
        'dropdown.border': colorToString(dropdownBorder),
        'dropdown.foreground': colorToString(dropdownForeground),
        'dropdown.listBackground': colorToString(dropdownListBackground),
        'editor.findMatchBackground': colorToString(editorFindMatchBackground),
        'editorGroup.border': colorToString(editorGroupBorder),
        'editorGroupHeader.tabsBackground':
            colorToString(editorGroupHeaderTabsBackground),
        'editorGroupHeader.tabsBorder':
            colorToString(editorGroupHeaderTabsBorder),
        'editorGutter.addedBackground':
            colorToString(editorGutterAddedBackground),
        'editorGutter.deletedBackground':
            colorToString(editorGutterDeletedBackground),
        'editorGutter.modifiedBackground':
            colorToString(editorGutterModifiedBackground),
        'editorLineNumber.activeForeground':
            colorToString(editorLineNumberActiveForeground),
        'editorLineNumber.foreground':
            colorToString(editorLineNumberForeground),
        'editorOverviewRuler.border': colorToString(editorOverviewRulerBorder),
        'editorWidget.background': colorToString(editorWidgetBackground),
        'errorForeground': colorToString(errorForeground),
        'focusBorder': colorToString(focusBorder),
        'foreground': colorToString(foreground),
        'icon.foreground': colorToString(iconForeground),
        'input.background': colorToString(inputBackground),
        'input.border': colorToString(inputBorder),
        'input.foreground': colorToString(inputForeground),
        'inputOption.activeBackground':
            colorToString(inputOptionActiveBackground),
        'inputOption.activeBorder': colorToString(inputOptionActiveBorder),
        'keybindingLabel.foreground': colorToString(keybindingLabelForeground),
        'notificationCenterHeader.background':
            colorToString(notificationCenterHeaderBackground),
        'notificationCenterHeader.foreground':
            colorToString(notificationCenterHeaderForeground),
        'notifications.background': colorToString(notificationsBackground),
        'notifications.border': notificationsBorder,
        'notifications.foreground': notificationsForeground,
        'panel.background': panelBackground,
        'panel.border': panelBorder,
        'panelInput.border': panelInputBorder,
        'panelTitle.activeBorder': panelTitleActiveBorder,
        'panelTitle.activeForeground': panelTitleActiveForeground,
        'panelTitle.inactiveForeground': panelTitleInactiveForeground,
        'peekViewEditor.background': peekViewEditorBackground,
        'peekViewEditor.matchHighlightBackground':
            peekViewEditorMatchHighlightBackground,
        'peekViewResult.background': peekViewResultBackground,
        'peekViewResult.matchHighlightBackground':
            peekViewResultMatchHighlightBackground,
        'pickerGroup.border': pickerGroupBorder,
        'progressBar.background': progressBarBackground,
        'quickInput.background': quickInputBackground,
        'quickInput.foreground': quickInputForeground,
        'settings.dropdownBackground': settingsDropdownBackground,
        'settings.dropdownBorder': settingsDropdownBorder,
        'settings.headerForeground': settingsHeaderForeground,
        'settings.modifiedItemIndicator': settingsModifiedItemIndicator,
        'sideBar.background': sideBarBackground,
        'sideBar.border': sideBarBorder,
        'sideBar.foreground': sideBarForeground,
        'sideBarSectionHeader.foreground': sideBarSectionHeaderForeground,
        'statusBar.background': statusBarBackground,
        'statusBar.border': statusBarBorder,
        'statusBar.debuggingBackground': statusBarDebuggingBackground,
        'statusBar.debuggingForeground': statusBarDebuggingForeground,
        'statusBar.focusBorder': statusBarFocusBorder,
        'statusBar.foreground': statusBarForeground,
        'statusBar.noFolderBackground': statusBarNoFolderBackground,
        'statusBarItem.focusBorder': statusBarItemFocusBorder,
        'statusBarItem.prominentBackground': statusBarItemProminentBackground,
        'tab.activeBackground': tabActiveBackground,
        'tab.activeBorder': tabActiveBorder,
        'tab.activeBorderTop': tabActiveBorderTop,
        'tab.activeForeground': tabActiveForeground,
        'tab.selectedBorderTop': tabSelectedBorderTop,
        'tab.border': tabBorder,
        'tab.hoverBackground': tabHoverBackground,
        'tab.inactiveBackground': tabInactiveBackground,
        'tab.inactiveForeground': tabInactiveForeground,
        'tab.unfocusedActiveBorder': tabUnfocusedActiveBorder,
        'tab.unfocusedActiveBorderTop': tabUnfocusedActiveBorderTop,
        'tab.unfocusedHoverBackground': tabUnfocusedHoverBackground,
        'terminal.foreground': terminalForeground,
        'terminal.tab.activeBorder': terminalTabActiveBorder,
        'textBlockQuote.background': textBlockQuoteBackground,
        'textBlockQuote.border': textBlockQuoteBorder,
        'textCodeBlock.background': textCodeBlockBackground,
        'textLink.activeForeground': textLinkActiveForeground,
        'textLink.foreground': textLinkForeground,
        'textPreformat.foreground': textPreformatForeground,
        'textPreformat.background': textPreformatBackground,
        'textSeparator.foreground': textSeparatorForeground,
        'titleBar.activeBackground': titleBarActiveBackground,
        'titleBar.activeForeground': titleBarActiveForeground,
        'titleBar.border': titleBarBorder,
        'titleBar.inactiveBackground': titleBarInactiveBackground,
        'titleBar.inactiveForeground': titleBarInactiveForeground,
        'welcomePage.tileBackground': welcomePageTileBackground,
        'welcomePage.progress.foreground': welcomePageProgressForeground,
      };
}

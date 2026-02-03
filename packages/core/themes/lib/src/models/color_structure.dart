import 'package:flutter/material.dart';

/// Class defining base colors
/// Basic color definitions used throughout the application
class BaseColors {
  /// Basic text color, icon color
  final Color foreground;

  /// Main background color
  final Color background;

  /// Background color for text selection, list item selection (no transparency)
  final Color selection;

  /// Basic border, frame color
  final Color border;

  /// Divider color for horizontal and vertical lines
  final Color divider;

  /// Drop shadow, elevation effect color
  final Color shadow;

  const BaseColors({
    required this.foreground,
    required this.background,
    required this.selection,
    required this.border,
    required this.divider,
    required this.shadow,
  });

  BaseColors copyWith({
    Color? foreground,
    Color? background,
    Color? selection,
    Color? border,
    Color? divider,
    Color? shadow,
  }) {
    return BaseColors(
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      selection: selection ?? this.selection,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseColors &&
        other.foreground == foreground &&
        other.background == background &&
        other.selection == selection &&
        other.border == border &&
        other.divider == divider &&
        other.shadow == shadow;
  }

  @override
  int get hashCode {
    return Object.hash(
      foreground,
      background,
      selection,
      border,
      divider,
      shadow,
    );
  }
}

/// Class defining activity bar colors
class ActivityBarColors {
  /// Activity bar overall background
  final Color background;

  /// Selected item background color
  final Color activeItemBackground;

  /// Selected icon color
  final Color activeItem;

  /// Unselected icon color
  final Color inactiveItem;

  /// Icon color on mouse hover
  final Color hoverItem;

  /// Notification badge background color
  final Color badgeBackground;

  const ActivityBarColors({
    required this.background,
    required this.activeItemBackground,
    required this.activeItem,
    required this.inactiveItem,
    required this.hoverItem,
    required this.badgeBackground,
  });

  ActivityBarColors copyWith({
    Color? background,
    Color? activeItemBackground,
    Color? activeItem,
    Color? inactiveItem,
    Color? hoverItem,
    Color? badgeBackground,
  }) {
    return ActivityBarColors(
      background: background ?? this.background,
      activeItemBackground: activeItemBackground ?? this.activeItemBackground,
      activeItem: activeItem ?? this.activeItem,
      inactiveItem: inactiveItem ?? this.inactiveItem,
      hoverItem: hoverItem ?? this.hoverItem,
      badgeBackground: badgeBackground ?? this.badgeBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityBarColors &&
        other.background == background &&
        other.activeItemBackground == activeItemBackground &&
        other.activeItem == activeItem &&
        other.inactiveItem == inactiveItem &&
        other.hoverItem == hoverItem &&
        other.badgeBackground == badgeBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      activeItemBackground,
      activeItem,
      inactiveItem,
      hoverItem,
      badgeBackground,
    );
  }
}

/// Class defining sidebar colors
class SideBarColors {
  /// Sidebar overall background
  final Color background;

  /// Divider between sections
  final Color divider;

  /// Section header color
  final Color groupHeader;

  /// Selected item background
  final Color activeItemBackground;

  /// Selected item text
  final Color activeItemText;

  /// Unselected item text
  final Color inactiveItemText;

  /// Background on mouse hover
  final Color hoverBackground;

  const SideBarColors({
    required this.background,
    required this.divider,
    required this.groupHeader,
    required this.activeItemBackground,
    required this.activeItemText,
    required this.inactiveItemText,
    required this.hoverBackground,
  });

  SideBarColors copyWith({
    Color? background,
    Color? divider,
    Color? groupHeader,
    Color? activeItemBackground,
    Color? activeItemText,
    Color? inactiveItemText,
    Color? hoverBackground,
  }) {
    return SideBarColors(
      background: background ?? this.background,
      divider: divider ?? this.divider,
      groupHeader: groupHeader ?? this.groupHeader,
      activeItemBackground: activeItemBackground ?? this.activeItemBackground,
      activeItemText: activeItemText ?? this.activeItemText,
      inactiveItemText: inactiveItemText ?? this.inactiveItemText,
      hoverBackground: hoverBackground ?? this.hoverBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SideBarColors &&
        other.background == background &&
        other.divider == divider &&
        other.groupHeader == groupHeader &&
        other.activeItemBackground == activeItemBackground &&
        other.activeItemText == activeItemText &&
        other.inactiveItemText == inactiveItemText &&
        other.hoverBackground == hoverBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      divider,
      groupHeader,
      activeItemBackground,
      activeItemText,
      inactiveItemText,
      hoverBackground,
    );
  }
}

/// Class defining status bar colors
class StatusBarColors {
  /// Status bar background
  final Color background;

  /// Status text color
  final Color foreground;

  /// Status item background on hover
  final Color itemHoverBackground;

  /// Background for important status display (e.g., error)
  final Color prominentBackground;

  /// Text color for important status display
  final Color prominentForeground;

  const StatusBarColors({
    required this.background,
    required this.foreground,
    required this.itemHoverBackground,
    required this.prominentBackground,
    required this.prominentForeground,
  });

  StatusBarColors copyWith({
    Color? background,
    Color? foreground,
    Color? itemHoverBackground,
    Color? prominentBackground,
    Color? prominentForeground,
  }) {
    return StatusBarColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      itemHoverBackground: itemHoverBackground ?? this.itemHoverBackground,
      prominentBackground: prominentBackground ?? this.prominentBackground,
      prominentForeground: prominentForeground ?? this.prominentForeground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusBarColors &&
        other.background == background &&
        other.foreground == foreground &&
        other.itemHoverBackground == itemHoverBackground &&
        other.prominentBackground == prominentBackground &&
        other.prominentForeground == prominentForeground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      foreground,
      itemHoverBackground,
      prominentBackground,
      prominentForeground,
    );
  }
}

/// Class defining panel colors
class PanelColors {
  /// Panel background color
  final Color background;

  /// Panel border color
  final Color border;

  /// Panel text color
  final Color foreground;

  const PanelColors({
    required this.background,
    required this.border,
    required this.foreground,
  });

  PanelColors copyWith({Color? background, Color? border, Color? foreground}) {
    return PanelColors(
      background: background ?? this.background,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PanelColors &&
        other.background == background &&
        other.border == border &&
        other.foreground == foreground;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, foreground);
  }
}

/// Class defining title bar colors
class TitleBarColors {
  /// Title bar overall background color
  final Color background;

  /// Title bar border color (bottom)
  final Color border;

  /// Title bar text color
  final Color foreground;

  /// Title bar icon color
  final Color iconColor;

  /// Title bar button background on hover
  final Color buttonHoverBackground;

  /// Title bar button background when active
  final Color buttonActiveBackground;

  const TitleBarColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.iconColor,
    required this.buttonHoverBackground,
    required this.buttonActiveBackground,
  });

  TitleBarColors copyWith({
    Color? background,
    Color? border,
    Color? foreground,
    Color? iconColor,
    Color? buttonHoverBackground,
    Color? buttonActiveBackground,
  }) {
    return TitleBarColors(
      background: background ?? this.background,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
      iconColor: iconColor ?? this.iconColor,
      buttonHoverBackground:
          buttonHoverBackground ?? this.buttonHoverBackground,
      buttonActiveBackground:
          buttonActiveBackground ?? this.buttonActiveBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TitleBarColors &&
        other.background == background &&
        other.border == border &&
        other.foreground == foreground &&
        other.iconColor == iconColor &&
        other.buttonHoverBackground == buttonHoverBackground &&
        other.buttonActiveBackground == buttonActiveBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      border,
      foreground,
      iconColor,
      buttonHoverBackground,
      buttonActiveBackground,
    );
  }
}

/// Class defining quick input colors
class QuickInputColors {
  /// Input field background color
  final Color fieldBackground;

  /// Input field border color
  final Color fieldBorder;

  /// Border color when active
  final Color fieldActiveBorder;

  /// Placeholder text color
  final Color placeholderText;

  /// Input text color
  final Color inputText;

  /// Icon color
  final Color iconColor;

  /// Dropdown background color
  final Color dropdownBackground;

  /// Dropdown border color
  final Color dropdownBorder;

  /// Selected item background color
  final Color selectedItemBackground;

  /// Selected item text color
  final Color selectedItemText;

  /// Background color on hover
  final Color hoverBackground;

  /// Item text color
  final Color itemText;

  /// Item description text color
  final Color itemDescriptionText;

  const QuickInputColors({
    required this.fieldBackground,
    required this.fieldBorder,
    required this.fieldActiveBorder,
    required this.placeholderText,
    required this.inputText,
    required this.iconColor,
    required this.dropdownBackground,
    required this.dropdownBorder,
    required this.selectedItemBackground,
    required this.selectedItemText,
    required this.hoverBackground,
    required this.itemText,
    required this.itemDescriptionText,
  });

  QuickInputColors copyWith({
    Color? fieldBackground,
    Color? fieldBorder,
    Color? fieldActiveBorder,
    Color? placeholderText,
    Color? inputText,
    Color? iconColor,
    Color? dropdownBackground,
    Color? dropdownBorder,
    Color? selectedItemBackground,
    Color? selectedItemText,
    Color? hoverBackground,
    Color? itemText,
    Color? itemDescriptionText,
  }) {
    return QuickInputColors(
      fieldBackground: fieldBackground ?? this.fieldBackground,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      fieldActiveBorder: fieldActiveBorder ?? this.fieldActiveBorder,
      placeholderText: placeholderText ?? this.placeholderText,
      inputText: inputText ?? this.inputText,
      iconColor: iconColor ?? this.iconColor,
      dropdownBackground: dropdownBackground ?? this.dropdownBackground,
      dropdownBorder: dropdownBorder ?? this.dropdownBorder,
      selectedItemBackground:
          selectedItemBackground ?? this.selectedItemBackground,
      selectedItemText: selectedItemText ?? this.selectedItemText,
      hoverBackground: hoverBackground ?? this.hoverBackground,
      itemText: itemText ?? this.itemText,
      itemDescriptionText: itemDescriptionText ?? this.itemDescriptionText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuickInputColors &&
        other.fieldBackground == fieldBackground &&
        other.fieldBorder == fieldBorder &&
        other.fieldActiveBorder == fieldActiveBorder &&
        other.placeholderText == placeholderText &&
        other.inputText == inputText &&
        other.iconColor == iconColor &&
        other.dropdownBackground == dropdownBackground &&
        other.dropdownBorder == dropdownBorder &&
        other.selectedItemBackground == selectedItemBackground &&
        other.selectedItemText == selectedItemText &&
        other.hoverBackground == hoverBackground &&
        other.itemText == itemText &&
        other.itemDescriptionText == itemDescriptionText;
  }

  @override
  int get hashCode {
    return Object.hash(
      fieldBackground,
      fieldBorder,
      fieldActiveBorder,
      placeholderText,
      inputText,
      iconColor,
      dropdownBackground,
      dropdownBorder,
      selectedItemBackground,
      selectedItemText,
      hoverBackground,
      itemText,
      itemDescriptionText,
    );
  }
}

/// Class defining dialog colors
class DialogColors {
  /// Dialog background color
  final Color background;

  /// Dialog border color
  final Color border;

  /// Dialog text color
  final Color foreground;

  /// Dialog shadow color
  final Color shadow;

  /// Dialog background barrier color
  final Color barrier;

  const DialogColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.shadow,
    required this.barrier,
  });

  DialogColors copyWith({
    Color? background,
    Color? border,
    Color? foreground,
    Color? shadow,
    Color? barrier,
  }) {
    return DialogColors(
      background: background ?? this.background,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
      shadow: shadow ?? this.shadow,
      barrier: barrier ?? this.barrier,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DialogColors &&
        other.background == background &&
        other.border == border &&
        other.foreground == foreground &&
        other.shadow == shadow &&
        other.barrier == barrier;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, foreground, shadow, barrier);
  }
}

/// Class consolidating UI area colors
class UIAreaColors {
  /// Icon bar on the left edge
  final ActivityBarColors activityBar;

  /// File tree, search panel, etc.
  final SideBarColors sideBar;

  /// Status display area (connection status, progress, etc.)
  final StatusBarColors statusBar;

  /// Title bar (cross-platform toolbar)
  final TitleBarColors titleBar;

  /// Floating panel, tool panel
  final PanelColors panel;

  /// Modal dialog, settings screen
  final DialogColors dialog;

  const UIAreaColors({
    required this.activityBar,
    required this.sideBar,
    required this.statusBar,
    required this.titleBar,
    required this.panel,
    required this.dialog,
  });

  UIAreaColors copyWith({
    ActivityBarColors? activityBar,
    SideBarColors? sideBar,
    StatusBarColors? statusBar,
    TitleBarColors? titleBar,
    PanelColors? panel,
    DialogColors? dialog,
  }) {
    return UIAreaColors(
      activityBar: activityBar ?? this.activityBar,
      sideBar: sideBar ?? this.sideBar,
      statusBar: statusBar ?? this.statusBar,
      titleBar: titleBar ?? this.titleBar,
      panel: panel ?? this.panel,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UIAreaColors &&
        other.activityBar == activityBar &&
        other.sideBar == sideBar &&
        other.statusBar == statusBar &&
        other.titleBar == titleBar &&
        other.panel == panel &&
        other.dialog == dialog;
  }

  @override
  int get hashCode {
    return Object.hash(
      activityBar,
      sideBar,
      statusBar,
      titleBar,
      panel,
      dialog,
    );
  }
}

/// Class defining state-based colors
class StatefulColors {
  /// Default state
  final Color normal;

  /// On mouse hover
  final Color hover;

  /// On click, when selected
  final Color active;

  /// When disabled
  final Color disabled;

  /// On keyboard focus
  final Color focus;

  const StatefulColors({
    required this.normal,
    required this.hover,
    required this.active,
    required this.disabled,
    required this.focus,
  });

  StatefulColors copyWith({
    Color? normal,
    Color? hover,
    Color? active,
    Color? disabled,
    Color? focus,
  }) {
    return StatefulColors(
      normal: normal ?? this.normal,
      hover: hover ?? this.hover,
      active: active ?? this.active,
      disabled: disabled ?? this.disabled,
      focus: focus ?? this.focus,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatefulColors &&
        other.normal == normal &&
        other.hover == hover &&
        other.active == active &&
        other.disabled == disabled &&
        other.focus == focus;
  }

  @override
  int get hashCode {
    return Object.hash(normal, hover, active, disabled, focus);
  }
}

/// Class defining button colors
class ButtonColors {
  /// Button background color (state-based)
  final StatefulColors background;

  /// Button text color (state-based)
  final StatefulColors text;

  /// Button border color (state-based)
  final StatefulColors border;

  /// Primary button background color
  final Color primaryBackground;

  /// Primary button text color
  final Color primaryText;

  /// Primary button background on press
  final Color primaryPressedBackground;

  /// Destructive action button background color
  final Color destructiveBackground;

  /// Destructive action button text color
  final Color destructiveText;

  /// Destructive action button background on press
  final Color destructivePressedBackground;

  const ButtonColors({
    required this.background,
    required this.text,
    required this.border,
    required this.primaryBackground,
    required this.primaryText,
    required this.primaryPressedBackground,
    required this.destructiveBackground,
    required this.destructiveText,
    required this.destructivePressedBackground,
  });

  ButtonColors copyWith({
    StatefulColors? background,
    StatefulColors? text,
    StatefulColors? border,
    Color? primaryBackground,
    Color? primaryText,
    Color? primaryPressedBackground,
    Color? destructiveBackground,
    Color? destructiveText,
    Color? destructivePressedBackground,
  }) {
    return ButtonColors(
      background: background ?? this.background,
      text: text ?? this.text,
      border: border ?? this.border,
      primaryBackground: primaryBackground ?? this.primaryBackground,
      primaryText: primaryText ?? this.primaryText,
      primaryPressedBackground:
          primaryPressedBackground ?? this.primaryPressedBackground,
      destructiveBackground:
          destructiveBackground ?? this.destructiveBackground,
      destructiveText: destructiveText ?? this.destructiveText,
      destructivePressedBackground:
          destructivePressedBackground ?? this.destructivePressedBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ButtonColors &&
        other.background == background &&
        other.text == text &&
        other.border == border &&
        other.primaryBackground == primaryBackground &&
        other.primaryText == primaryText &&
        other.primaryPressedBackground == primaryPressedBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      text,
      border,
      primaryBackground,
      primaryText,
      primaryPressedBackground,
    );
  }
}

/// Class defining input field colors
class InputColors {
  /// Input field background color
  final Color background;

  /// Input field border color
  final Color border;

  /// Border color on focus
  final Color focusBorder;

  /// Placeholder text color
  final Color placeholder;

  /// Input text color
  final Color text;

  const InputColors({
    required this.background,
    required this.border,
    required this.focusBorder,
    required this.placeholder,
    required this.text,
  });

  InputColors copyWith({
    Color? background,
    Color? border,
    Color? focusBorder,
    Color? placeholder,
    Color? text,
  }) {
    return InputColors(
      background: background ?? this.background,
      border: border ?? this.border,
      focusBorder: focusBorder ?? this.focusBorder,
      placeholder: placeholder ?? this.placeholder,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputColors &&
        other.background == background &&
        other.border == border &&
        other.focusBorder == focusBorder &&
        other.placeholder == placeholder &&
        other.text == text;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, focusBorder, placeholder, text);
  }
}

/// Class defining list colors
class ListColors {
  /// List item background color (state-based)
  final StatefulColors itemBackground;

  /// List item text color (state-based)
  final StatefulColors itemText;

  /// Selected state background color
  final Color selectedBackground;

  /// Selected state text color
  final Color selectedText;

  const ListColors({
    required this.itemBackground,
    required this.itemText,
    required this.selectedBackground,
    required this.selectedText,
  });

  ListColors copyWith({
    StatefulColors? itemBackground,
    StatefulColors? itemText,
    Color? selectedBackground,
    Color? selectedText,
  }) {
    return ListColors(
      itemBackground: itemBackground ?? this.itemBackground,
      itemText: itemText ?? this.itemText,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedText: selectedText ?? this.selectedText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ListColors &&
        other.itemBackground == itemBackground &&
        other.itemText == itemText &&
        other.selectedBackground == selectedBackground &&
        other.selectedText == selectedText;
  }

  @override
  int get hashCode {
    return Object.hash(
      itemBackground,
      itemText,
      selectedBackground,
      selectedText,
    );
  }
}

/// Class defining dropdown colors
class DropdownColors {
  /// Dropdown menu background color
  final Color background;

  /// Dropdown menu border color
  final Color border;

  /// Menu item background color (state-based)
  final StatefulColors itemBackground;

  /// Menu item text color
  final Color itemText;

  const DropdownColors({
    required this.background,
    required this.border,
    required this.itemBackground,
    required this.itemText,
  });

  DropdownColors copyWith({
    Color? background,
    Color? border,
    StatefulColors? itemBackground,
    Color? itemText,
  }) {
    return DropdownColors(
      background: background ?? this.background,
      border: border ?? this.border,
      itemBackground: itemBackground ?? this.itemBackground,
      itemText: itemText ?? this.itemText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownColors &&
        other.background == background &&
        other.border == border &&
        other.itemBackground == itemBackground &&
        other.itemText == itemText;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, itemBackground, itemText);
  }
}

/// Class defining popover colors
class PopoverColors {
  /// Popover background color
  final Color background;

  /// Popover text color
  final Color text;

  /// Popover border color
  final Color border;

  /// Popover shadow color
  final Color shadow;

  /// Popover background barrier color
  final Color barrier;

  const PopoverColors({
    required this.background,
    required this.text,
    required this.border,
    required this.shadow,
    required this.barrier,
  });

  PopoverColors copyWith({
    Color? background,
    Color? text,
    Color? border,
    Color? shadow,
    Color? barrier,
  }) {
    return PopoverColors(
      background: background ?? this.background,
      text: text ?? this.text,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      barrier: barrier ?? this.barrier,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PopoverColors &&
        other.background == background &&
        other.text == text &&
        other.border == border &&
        other.shadow == shadow &&
        other.barrier == barrier;
  }

  @override
  int get hashCode {
    return Object.hash(background, text, border, shadow, barrier);
  }
}

/// Class defining action button colors
/// For overlay action buttons (e.g., ellipsis menu button in stack grid)
class ActionButtonColors {
  /// Action button background color
  final Color background;

  /// Action button icon color
  final Color iconColor;

  const ActionButtonColors({required this.background, required this.iconColor});

  ActionButtonColors copyWith({Color? background, Color? iconColor}) {
    return ActionButtonColors(
      background: background ?? this.background,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActionButtonColors &&
        other.background == background &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode {
    return Object.hash(background, iconColor);
  }
}

/// Class consolidating interactive element colors
class InteractiveColors {
  /// Various buttons (primary, secondary, danger, etc.)
  final ButtonColors button;

  /// Text input, search box
  final InputColors input;

  /// List item, tree item
  final ListColors list;

  /// Select box, menu
  final DropdownColors dropdown;

  /// Tooltip, context menu
  final PopoverColors popover;

  /// Quick input (pathfinder, etc.)
  final QuickInputColors quickInput;

  /// Overlay action button
  final ActionButtonColors actionButton;

  const InteractiveColors({
    required this.button,
    required this.input,
    required this.list,
    required this.dropdown,
    required this.popover,
    required this.quickInput,
    required this.actionButton,
  });

  InteractiveColors copyWith({
    ButtonColors? button,
    InputColors? input,
    ListColors? list,
    DropdownColors? dropdown,
    PopoverColors? popover,
    QuickInputColors? quickInput,
    ActionButtonColors? actionButton,
  }) {
    return InteractiveColors(
      button: button ?? this.button,
      input: input ?? this.input,
      list: list ?? this.list,
      dropdown: dropdown ?? this.dropdown,
      popover: popover ?? this.popover,
      quickInput: quickInput ?? this.quickInput,
      actionButton: actionButton ?? this.actionButton,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InteractiveColors &&
        other.button == button &&
        other.input == input &&
        other.list == list &&
        other.dropdown == dropdown &&
        other.popover == popover &&
        other.quickInput == quickInput &&
        other.actionButton == actionButton;
  }

  @override
  int get hashCode {
    return Object.hash(
      button,
      input,
      list,
      dropdown,
      popover,
      quickInput,
      actionButton,
    );
  }
}

/// Class defining status display colors
class StatusColors {
  /// Info message, help icon
  final Color info;

  /// Warning message, caution icon
  final Color warning;

  /// Error message, failure state
  final Color error;

  /// Success message, completion state
  final Color success;

  /// Progress bar, spinner
  final Color loading;

  /// Loading background color
  final Color loadingBackground;

  const StatusColors({
    required this.info,
    required this.warning,
    required this.error,
    required this.success,
    required this.loading,
    required this.loadingBackground,
  });

  StatusColors copyWith({
    Color? info,
    Color? warning,
    Color? error,
    Color? success,
    Color? loading,
    Color? loadingBackground,
  }) {
    return StatusColors(
      info: info ?? this.info,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      success: success ?? this.success,
      loading: loading ?? this.loading,
      loadingBackground: loadingBackground ?? this.loadingBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusColors &&
        other.info == info &&
        other.warning == warning &&
        other.error == error &&
        other.success == success &&
        other.loading == loading &&
        other.loadingBackground == loadingBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      info,
      warning,
      error,
      success,
      loading,
      loadingBackground,
    );
  }
}

/// Class defining graph colors
class GraphColors {
  /// Graph node base color
  final Color nodeBase;

  /// Text color inside node
  final Color nodeText;

  /// Icon color inside node
  final Color nodeIcon;

  /// Graph link base color
  final Color linkBase;

  /// Highlight color when selected
  final Color selectionHighlight;

  /// Background grid line color
  final Color gridLine;

  /// Graph area background color (main content area)
  final Color background;

  const GraphColors({
    required this.nodeBase,
    required this.nodeText,
    required this.nodeIcon,
    required this.linkBase,
    required this.selectionHighlight,
    required this.gridLine,
    required this.background,
  });

  GraphColors copyWith({
    Color? nodeBase,
    Color? nodeText,
    Color? nodeIcon,
    Color? linkBase,
    Color? selectionHighlight,
    Color? gridLine,
    Color? background,
  }) {
    return GraphColors(
      nodeBase: nodeBase ?? this.nodeBase,
      nodeText: nodeText ?? this.nodeText,
      nodeIcon: nodeIcon ?? this.nodeIcon,
      linkBase: linkBase ?? this.linkBase,
      selectionHighlight: selectionHighlight ?? this.selectionHighlight,
      gridLine: gridLine ?? this.gridLine,
      background: background ?? this.background,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GraphColors &&
        other.nodeBase == nodeBase &&
        other.nodeText == nodeText &&
        other.nodeIcon == nodeIcon &&
        other.linkBase == linkBase &&
        other.selectionHighlight == selectionHighlight &&
        other.gridLine == gridLine &&
        other.background == background;
  }

  @override
  int get hashCode {
    return Object.hash(
      nodeBase,
      nodeText,
      nodeIcon,
      linkBase,
      selectionHighlight,
      gridLine,
      background,
    );
  }
}

/// Class defining metadata colors
class MetadataColors {
  /// Property name color
  final Color propertyName;

  /// Property value color
  final Color propertyValue;

  /// Tag background color
  final Color tagBackground;

  /// Tag text color
  final Color tagText;

  /// Label background color
  final Color labelBackground;

  /// Label border color
  final Color labelBorder;

  /// Label text color
  final Color labelText;

  const MetadataColors({
    required this.propertyName,
    required this.propertyValue,
    required this.tagBackground,
    required this.tagText,
    required this.labelBackground,
    required this.labelBorder,
    required this.labelText,
  });

  MetadataColors copyWith({
    Color? propertyName,
    Color? propertyValue,
    Color? tagBackground,
    Color? tagText,
    Color? labelBackground,
    Color? labelBorder,
    Color? labelText,
  }) {
    return MetadataColors(
      propertyName: propertyName ?? this.propertyName,
      propertyValue: propertyValue ?? this.propertyValue,
      tagBackground: tagBackground ?? this.tagBackground,
      tagText: tagText ?? this.tagText,
      labelBackground: labelBackground ?? this.labelBackground,
      labelBorder: labelBorder ?? this.labelBorder,
      labelText: labelText ?? this.labelText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetadataColors &&
        other.propertyName == propertyName &&
        other.propertyValue == propertyValue &&
        other.tagBackground == tagBackground &&
        other.tagText == tagText &&
        other.labelBackground == labelBackground &&
        other.labelBorder == labelBorder &&
        other.labelText == labelText;
  }

  @override
  int get hashCode {
    return Object.hash(
      propertyName,
      propertyValue,
      tagBackground,
      tagText,
      labelBackground,
      labelBorder,
      labelText,
    );
  }
}

/// Class defining table colors
class TableColors {
  /// Table overall background color
  final Color background;

  /// Header row background color
  final Color headerBackground;

  /// Header text color
  final Color headerText;

  /// Odd row background color
  final Color oddRowBackground;

  /// Even row background color
  final Color evenRowBackground;

  /// Cell text color
  final Color cellText;

  /// Selected row background color
  final Color selectedRowBackground;

  /// Selected row text color
  final Color selectedRowText;

  /// Hover row background color
  final Color hoverRowBackground;

  /// Active row background color
  final Color activeRowBackground;

  /// Normal border color
  final Color border;

  /// Active border color
  final Color activeBorder;

  const TableColors({
    required this.background,
    required this.headerBackground,
    required this.headerText,
    required this.oddRowBackground,
    required this.evenRowBackground,
    required this.cellText,
    required this.selectedRowBackground,
    required this.selectedRowText,
    required this.hoverRowBackground,
    required this.activeRowBackground,
    required this.border,
    required this.activeBorder,
  });

  TableColors copyWith({
    Color? background,
    Color? headerBackground,
    Color? headerText,
    Color? oddRowBackground,
    Color? evenRowBackground,
    Color? cellText,
    Color? selectedRowBackground,
    Color? selectedRowText,
    Color? hoverRowBackground,
    Color? activeRowBackground,
    Color? border,
    Color? activeBorder,
  }) {
    return TableColors(
      background: background ?? this.background,
      headerBackground: headerBackground ?? this.headerBackground,
      headerText: headerText ?? this.headerText,
      oddRowBackground: oddRowBackground ?? this.oddRowBackground,
      evenRowBackground: evenRowBackground ?? this.evenRowBackground,
      cellText: cellText ?? this.cellText,
      selectedRowBackground:
          selectedRowBackground ?? this.selectedRowBackground,
      selectedRowText: selectedRowText ?? this.selectedRowText,
      hoverRowBackground: hoverRowBackground ?? this.hoverRowBackground,
      activeRowBackground: activeRowBackground ?? this.activeRowBackground,
      border: border ?? this.border,
      activeBorder: activeBorder ?? this.activeBorder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableColors &&
        other.background == background &&
        other.headerBackground == headerBackground &&
        other.headerText == headerText &&
        other.oddRowBackground == oddRowBackground &&
        other.evenRowBackground == evenRowBackground &&
        other.cellText == cellText &&
        other.selectedRowBackground == selectedRowBackground &&
        other.selectedRowText == selectedRowText &&
        other.hoverRowBackground == hoverRowBackground &&
        other.activeRowBackground == activeRowBackground &&
        other.border == border &&
        other.activeBorder == activeBorder;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      headerBackground,
      headerText,
      oddRowBackground,
      evenRowBackground,
      cellText,
      selectedRowBackground,
      selectedRowText,
      hoverRowBackground,
      activeRowBackground,
      border,
      activeBorder,
    );
  }
}

/// Class consolidating app-specific colors
class AppSpecificColors {
  /// Graph node, link, selection highlight
  final GraphColors graph;

  /// Property name, value, tag
  final MetadataColors metadata;

  /// Table view specific colors
  final TableColors table;

  const AppSpecificColors({
    required this.graph,
    required this.metadata,
    required this.table,
  });

  AppSpecificColors copyWith({
    GraphColors? graph,
    MetadataColors? metadata,
    TableColors? table,
  }) {
    return AppSpecificColors(
      graph: graph ?? this.graph,
      metadata: metadata ?? this.metadata,
      table: table ?? this.table,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSpecificColors &&
        other.graph == graph &&
        other.metadata == metadata &&
        other.table == table;
  }

  @override
  int get hashCode {
    return Object.hash(graph, metadata, table);
  }
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import '../color_extensions.dart';
import 'color_structure.dart';
import 'theme_color_scheme.dart';

/// Color constants class
/// Centralized management of hardcoded color values
/// Guideline: Complies with docs/design/guidelines/12-theme-color.md
class _AppColorConstants {
  // Guideline-compliant base colors
  // Light mode: background #F8F9FA, text #212529
  // Dark mode: background #212529, text #F8F9FA
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightForeground = Color(0xFF212529);
  static const Color darkBackground = Color(0xFF212529);
  static const Color darkForeground = Color(0xFFF8F9FA);

  // Dark mode background colors (for existing UI elements)
  static const Color darkNavigationBackground = Color(0xFF2C2C2E);
  static const Color darkSystemBackground = Color(0xFF2D2D30);
  static const Color darkActivityBarActiveBackground = Color(0xFF3C3C3E);
  static const Color darkSidebarHoverBackground = Color(0xFF3A3A3C);
  static const Color darkButtonHoverBackground = Color(0xFF3A3A3C);
  static const Color darkButtonActiveBackground = Color(0xFF48484A);
  static const Color darkInputBackground = Color(0xFF2A2A2A);
  static const Color darkDropdownBackground = Color(0xFF2A2A2A);
  static const Color darkDropdownItemHoverBackground = Color(0xFF3A3A3A);
  static const Color darkTableEvenRowBackground = Color(0xFF1E1E20);
  static const Color darkTableHoverRowBackground = Color(0xFF2A2A2C);
  static const Color darkLabelBackground = Color(0xFF2A2A2C);

  // Light mode background colors (for existing UI elements)
  static const Color lightNavigationBackground = Color(0xFFF2F2F7);
  static const Color lightSystemBackground = Color(0xFFF3F3F3);
  static const Color lightActivityBarActiveBackground = Color(0xFFE8E8ED);
  static const Color lightSidebarHoverBackground = Color(0xFFE5E5EA);
  static const Color lightButtonHoverBackground = Color(0xFFE5E5EA);
  static const Color lightButtonActiveBackground = Color(0xFFD1D1D6);
  static const Color lightInputBackground = Color(0xFFF5F5F7);
  static const Color lightDropdownBackground = Color(0xFFF5F5F7);
  static const Color lightDropdownItemHoverBackground = Color(0xFFE5E5EA);
  static const Color lightTableEvenRowBackground = Color(0xFFF8F8FA);
  static const Color lightTableHoverRowBackground = Color(0xFFF0F0F2);
  static const Color lightLabelBackground = Color(0xFFF0F0F2);

  // Common colors
  static const Color darkBorder = Color(0xFF38383A);
  static const Color lightBorder = Color(0xFFD1D1D6);
  static const Color darkInputBorder = Color(0xFF4A4A4A);
  static const Color lightInputBorder = Color(0xFFD1D1D6);
  static const Color darkButtonBorder = Color(0xFF48484A);
  static const Color lightButtonBorder = Color(0xFFD1D1D6);

  // Destructive action colors
  static const Color darkDestructiveBackground = Color(0xFFFF453A);
  static const Color lightDestructiveBackground = Color(0xFFFF3B30);
  static const Color destructivePressedBackground = Color(0xFFD70015);

  // Opacity constants
  static const int alpha128 = 128; // 50%
  static const int alpha204 = 204; // 80%
  static const int alpha179 = 179; // 70%
  static const int alpha153 = 153; // 60%
  static const int alpha77 = 77; // 30%
  static const int alpha51 = 51; // 20%
  static const int alpha26 = 26; // 10%
  static const int alpha13 = 13; // 5%
}

/// Class representing app-specific color configuration
///
/// Systematic color management system based on VSCode color theme structure
///
/// ## 3-Level Background Color System
/// Prioritizing accessibility and consistency with macOS standard apps, background colors are limited to 3 types:
/// - **Level 1: Main background** - Base, panel, dialog, graph view
/// - **Level 2: Navigation background** - Primary sidebar, secondary sidebar, activity bar
/// - **Level 3: System background** - Title bar, status bar
class AppColorScheme {
  /// Whether this color configuration is for dark mode
  final Brightness brightness;

  /// Base colors (foreground/background, etc.)
  final BaseColors base;

  /// UI area colors (activity bar, sidebar, etc.)
  final UIAreaColors uiAreas;

  /// Interactive element colors (button, input, etc.)
  final InteractiveColors interactive;

  /// Status display colors (info, warning, error, etc.)
  final StatusColors status;

  /// App-specific colors (graph, metadata, etc.)
  final AppSpecificColors appSpecific;

  /// Theme color configuration
  final ThemeColorScheme theme;

  const AppColorScheme({
    required this.brightness,
    required this.base,
    required this.uiAreas,
    required this.interactive,
    required this.status,
    required this.appSpecific,
    required this.theme,
  });

  /// Determine whether this color configuration is for dark mode
  bool get isDarkMode => brightness == Brightness.dark;

  /// Generate app-specific color configuration from standard ColorScheme
  factory AppColorScheme.fromColorScheme(
    ColorScheme colorScheme, {
    ThemeColorType themeType = ThemeColorType.blue,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;

    // Create theme color
    final themeColorScheme = ThemeColorScheme.create(
      themeType,
      colorScheme.brightness,
    );

    // Define 3-level background color system
    // Level 1: Main background (most frequently used)
    // Guideline compliant: Light #F8F9FA, Dark #212529
    final mainBackground =
        isDark
            ? _AppColorConstants.darkBackground
            : _AppColorConstants.lightBackground;

    // Level 2: Navigation background (primary sidebar, secondary sidebar, activity bar)
    final navigationBackground =
        isDark
            ? _AppColorConstants.darkNavigationBackground
            : _AppColorConstants.lightNavigationBackground;

    // Level 3: System background (title bar, status bar)
    final systemBackground =
        isDark
            ? _AppColorConstants.darkSystemBackground
            : _AppColorConstants.lightSystemBackground;

    // Define base colors
    final baseColors = BaseColors(
      foreground:
          isDark
              ? _AppColorConstants.darkForeground
              : _AppColorConstants.lightForeground,
      background: mainBackground, // Use Level 1
      selection: themeColorScheme.primaryColor,
      border:
          isDark
              ? _AppColorConstants.darkBorder
              : _AppColorConstants.lightBorder,
      divider:
          isDark
              ? _AppColorConstants.darkBorder
              : _AppColorConstants.lightBorder,
      shadow:
          isDark
              ? Colors.black.withAlpha(_AppColorConstants.alpha128)
              : Colors.black.withAlpha(_AppColorConstants.alpha77),
    );

    // Define activity bar colors (Level 2: Navigation background)
    // When selected, background is slightly brighter, icon is theme color (moderate emphasis)
    final activityBarActiveBackground =
        isDark
            ? _AppColorConstants.darkActivityBarActiveBackground
            : _AppColorConstants.lightActivityBarActiveBackground;

    final activityBarColors = ActivityBarColors(
      background: navigationBackground, // Use Level 2
      activeItemBackground: activityBarActiveBackground,
      activeItem: themeColorScheme.primaryColor, // Selected icon: theme color
      inactiveItem: baseColors.foreground, // Unselected: base text color
      hoverItem: themeColorScheme.primaryColor,
      badgeBackground: colorScheme.secondary,
    );

    // Define sidebar colors (Level 2: Navigation background)
    final sideBarColors = SideBarColors(
      background: navigationBackground, // Use Level 2
      divider: baseColors.divider,
      groupHeader: themeColorScheme.primaryColor,
      activeItemBackground: themeColorScheme.primaryColor.withAlpha(
        _AppColorConstants.alpha204,
      ),
      activeItemText: Colors.white,
      inactiveItemText: baseColors.foreground,
      hoverBackground:
          isDark
              ? _AppColorConstants.darkSidebarHoverBackground
              : _AppColorConstants.lightSidebarHoverBackground,
    );

    // Define status bar colors (Level 3: System background)
    final statusBarColors = StatusBarColors(
      background: systemBackground, // Use Level 3
      foreground: baseColors.foreground,
      itemHoverBackground:
          isDark
              ? colorScheme.onSurface.withAlpha(_AppColorConstants.alpha26)
              : themeColorScheme.primaryColor.withAlpha(
                _AppColorConstants.alpha13,
              ),
      prominentBackground: colorScheme.error,
      prominentForeground: colorScheme.onError,
    );

    // Define panel colors (Level 1: Main background)
    final panelColors = PanelColors(
      background: mainBackground, // Use Level 1
      border: baseColors.border,
      foreground: baseColors.foreground,
    );

    // Define dialog colors (Level 1: Main background)
    final dialogColors = DialogColors(
      background: mainBackground, // Use Level 1
      border: baseColors.foreground,
      foreground: baseColors.foreground,
      shadow: baseColors.shadow,
      barrier: Colors.black.withAlpha(_AppColorConstants.alpha77),
    );

    // Define title bar colors (Level 3: System background)
    final titleBarColors = TitleBarColors(
      background: systemBackground, // Use Level 3
      border: baseColors.divider,
      foreground: baseColors.foreground,
      iconColor: baseColors.foreground,
      buttonHoverBackground:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha26)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha13),
      buttonActiveBackground:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha51)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha26),
    );

    // Consolidate UI area colors
    final uiAreaColors = UIAreaColors(
      activityBar: activityBarColors,
      sideBar: sideBarColors,
      statusBar: statusBarColors,
      titleBar: titleBarColors,
      panel: panelColors,
      dialog: dialogColors,
    );

    // Define base state-based colors
    StatefulColors createStatefulColors(
      Color normal, {
      Color? hover,
      Color? active,
    }) {
      return StatefulColors(
        normal: normal,
        hover: hover ?? (isDark ? normal.lighten(0.1) : normal.darken(0.1)),
        active: active ?? (isDark ? normal.lighten(0.2) : normal.darken(0.2)),
        disabled: normal.withAlpha(_AppColorConstants.alpha128),
        focus: themeColorScheme.primaryColor,
      );
    }

    // Define button colors
    final buttonColors = ButtonColors(
      background: createStatefulColors(
        Colors.transparent,
        hover:
            isDark
                ? _AppColorConstants.darkButtonHoverBackground
                : _AppColorConstants.lightButtonHoverBackground,
        active:
            isDark
                ? _AppColorConstants.darkButtonActiveBackground
                : _AppColorConstants.lightButtonActiveBackground,
      ),
      text: createStatefulColors(baseColors.foreground),
      border: createStatefulColors(
        isDark
            ? _AppColorConstants.darkButtonBorder
            : _AppColorConstants.lightButtonBorder,
      ),
      primaryBackground: themeColorScheme.primaryColor,
      primaryText: colorScheme.onPrimary,
      primaryPressedBackground:
          isDark
              ? themeColorScheme.primaryColor.darken(0.15)
              : themeColorScheme.primaryColor.darken(0.1),
      // Destructive action button specific colors
      destructiveBackground:
          isDark
              ? _AppColorConstants.darkDestructiveBackground
              : _AppColorConstants.lightDestructiveBackground,
      destructiveText: Colors.white,
      destructivePressedBackground:
          _AppColorConstants.destructivePressedBackground,
    );

    // Define input colors
    final inputColors = InputColors(
      background:
          isDark
              ? _AppColorConstants.darkInputBackground
              : _AppColorConstants.lightInputBackground,
      border:
          isDark
              ? _AppColorConstants.darkInputBorder
              : _AppColorConstants.lightInputBorder,
      focusBorder: themeColorScheme.primaryColor,
      placeholder: baseColors.foreground.withAlpha(_AppColorConstants.alpha128),
      text: baseColors.foreground,
    );

    // Define list colors
    final listColors = ListColors(
      itemBackground: createStatefulColors(
        Colors.transparent,
        hover:
            isDark
                ? colorScheme.onSurface.withAlpha(_AppColorConstants.alpha51)
                : themeColorScheme.primaryColor.withAlpha(
                  _AppColorConstants.alpha26,
                ),
      ),
      itemText: createStatefulColors(baseColors.foreground),
      selectedBackground: sideBarColors.activeItemBackground,
      selectedText: sideBarColors.activeItemText,
    );

    // Define dropdown colors
    final dropdownColors = DropdownColors(
      background:
          isDark
              ? _AppColorConstants.darkDropdownBackground
              : _AppColorConstants.lightDropdownBackground,
      border:
          isDark
              ? _AppColorConstants.darkInputBorder
              : _AppColorConstants.lightInputBorder,
      itemBackground: createStatefulColors(
        Colors.transparent,
        hover:
            isDark
                ? _AppColorConstants.darkDropdownItemHoverBackground
                : _AppColorConstants.lightDropdownItemHoverBackground,
      ),
      itemText: baseColors.foreground,
    );

    // Define popover colors
    final popoverColors = PopoverColors(
      background: colorScheme.surface,
      text: baseColors.foreground,
      border: baseColors.border,
      shadow: baseColors.shadow,
      barrier: Colors.black.withAlpha(_AppColorConstants.alpha77),
    );

    // Define quick input colors
    final quickInputColors = QuickInputColors(
      fieldBackground: colorScheme.surfaceContainerHighest.withAlpha(
        _AppColorConstants.alpha128,
      ),
      fieldBorder: baseColors.border,
      fieldActiveBorder: themeColorScheme.primaryColor,
      placeholderText: baseColors.foreground.withAlpha(
        _AppColorConstants.alpha179,
      ),
      inputText: baseColors.foreground,
      iconColor: baseColors.foreground.withAlpha(_AppColorConstants.alpha179),
      dropdownBackground: colorScheme.surfaceContainer,
      dropdownBorder: baseColors.border,
      selectedItemBackground: colorScheme.primaryContainer,
      selectedItemText: colorScheme.onPrimaryContainer,
      hoverBackground:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha26)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha13),
      itemText: baseColors.foreground,
      itemDescriptionText: baseColors.foreground.withAlpha(
        _AppColorConstants.alpha153,
      ),
    );

    // Define action button colors
    final actionButtonColors = ActionButtonColors(
      background:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha51)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha26),
      iconColor: baseColors.foreground,
    );

    // Consolidate interactive colors
    final interactiveColors = InteractiveColors(
      button: buttonColors,
      input: inputColors,
      list: listColors,
      dropdown: dropdownColors,
      popover: popoverColors,
      quickInput: quickInputColors,
      actionButton: actionButtonColors,
    );

    // Define status display colors
    final statusColors = StatusColors(
      info: themeColorScheme.primaryColor,
      warning: isDark ? Colors.amber : Colors.orange,
      error: colorScheme.error,
      success: isDark ? Colors.green.shade400 : Colors.green.shade600,
      loading: themeColorScheme.primaryColor,
      loadingBackground: colorScheme.surface,
    );

    // Define graph colors (Level 1: Main background)
    final graphColors = GraphColors(
      nodeBase: themeColorScheme.primaryColor,
      nodeText: baseColors.foreground,
      nodeIcon: themeColorScheme.primaryColor,
      linkBase: colorScheme.tertiary,
      selectionHighlight: colorScheme.secondary,
      gridLine: colorScheme.onSurface.withAlpha(_AppColorConstants.alpha26),
      background: mainBackground, // Use Level 1
    );

    // Define metadata colors
    final metadataColors = MetadataColors(
      propertyName: themeColorScheme.primaryColor,
      propertyValue: baseColors.foreground,
      tagBackground: colorScheme.secondary.withAlpha(
        _AppColorConstants.alpha51,
      ),
      tagText: baseColors.foreground,
      labelBackground:
          isDark
              ? _AppColorConstants.darkLabelBackground
              : _AppColorConstants.lightLabelBackground,
      labelBorder:
          isDark
              ? _AppColorConstants.darkButtonBorder
              : _AppColorConstants.lightButtonBorder,
      labelText: baseColors.foreground,
    );

    // Define table colors
    final tableColors = TableColors(
      background: mainBackground, // Use Level 1
      headerBackground:
          navigationBackground, // Use Level 2 (distinguish header)
      headerText: baseColors.foreground,
      oddRowBackground: mainBackground, // Use Level 1
      evenRowBackground:
          isDark
              ? _AppColorConstants.darkTableEvenRowBackground
              : _AppColorConstants.lightTableEvenRowBackground,
      cellText: baseColors.foreground,
      selectedRowBackground: themeColorScheme.primaryColor,
      selectedRowText: Colors.white,
      hoverRowBackground:
          isDark
              ? _AppColorConstants.darkTableHoverRowBackground
              : _AppColorConstants.lightTableHoverRowBackground,
      activeRowBackground:
          isDark
              ? themeColorScheme.primaryColor.darken(0.2)
              : themeColorScheme.primaryColor.lighten(0.3),
      border: baseColors.border,
      activeBorder: themeColorScheme.primaryColor,
    );

    // Consolidate app-specific colors
    final appSpecificColors = AppSpecificColors(
      graph: graphColors,
      metadata: metadataColors,
      table: tableColors,
    );

    return AppColorScheme(
      brightness: colorScheme.brightness,
      base: baseColors,
      uiAreas: uiAreaColors,
      interactive: interactiveColors,
      status: statusColors,
      appSpecific: appSpecificColors,
      theme: themeColorScheme,
    );
  }

  /// Create a copy and modify specified properties
  AppColorScheme copyWith({
    Brightness? brightness,
    BaseColors? base,
    UIAreaColors? uiAreas,
    InteractiveColors? interactive,
    StatusColors? status,
    AppSpecificColors? appSpecific,
    ThemeColorScheme? theme,
  }) {
    return AppColorScheme(
      brightness: brightness ?? this.brightness,
      base: base ?? this.base,
      uiAreas: uiAreas ?? this.uiAreas,
      interactive: interactive ?? this.interactive,
      status: status ?? this.status,
      appSpecific: appSpecific ?? this.appSpecific,
      theme: theme ?? this.theme,
    );
  }

  /// Convert to Flutter's ColorScheme
  ColorScheme toColorScheme() {
    final isDark = brightness == Brightness.dark;

    return ColorScheme(
      brightness: brightness,

      // Primary color
      primary: appSpecific.graph.nodeBase,
      onPrimary: isDark ? Colors.white : Colors.black,
      primaryContainer: uiAreas.sideBar.activeItemBackground,
      onPrimaryContainer: uiAreas.sideBar.activeItemText,

      // Secondary color
      secondary: appSpecific.graph.selectionHighlight,
      onSecondary: isDark ? Colors.black : Colors.white,
      secondaryContainer: appSpecific.metadata.tagBackground,
      onSecondaryContainer: appSpecific.metadata.tagText,

      // Tertiary color
      tertiary: appSpecific.graph.linkBase,
      onTertiary: isDark ? Colors.black : Colors.white,
      tertiaryContainer: isDark ? Colors.teal.shade700 : Colors.teal.shade100,
      onTertiaryContainer: isDark ? Colors.white : Colors.black,

      // Error color
      error: status.error,
      onError: isDark ? Colors.black : Colors.white,
      errorContainer: isDark ? Colors.red.shade900 : Colors.red.shade100,
      onErrorContainer: isDark ? Colors.white : Colors.red.shade900,

      // Surface
      surface: base.background,
      onSurface: base.foreground,
      surfaceContainer: uiAreas.sideBar.background,
      surfaceContainerHighest: appSpecific.graph.background,
      onSurfaceVariant: isDark ? Colors.white70 : Colors.black87,

      // Others
      outline: base.border,
      outlineVariant: interactive.input.border,
      shadow: base.shadow,
      scrim: Colors.black54,
      inverseSurface: isDark ? Colors.white : Colors.black,
      onInverseSurface: isDark ? Colors.black : Colors.white,
      inversePrimary: isDark ? Colors.indigo.shade300 : Colors.indigo.shade700,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppColorScheme &&
        other.brightness == brightness &&
        other.base == base &&
        other.uiAreas == uiAreas &&
        other.interactive == interactive &&
        other.status == status &&
        other.appSpecific == appSpecific &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return Object.hash(
      brightness,
      base,
      uiAreas,
      interactive,
      status,
      appSpecific,
      theme,
    );
  }

  @override
  String toString() {
    return 'AppColorScheme('
        'brightness: $brightness, '
        'base: $base, '
        'uiAreas: $uiAreas, '
        'interactive: $interactive, '
        'status: $status, '
        'appSpecific: $appSpecific, '
        'theme: $theme'
        ')';
  }

  // Getters for backward compatibility
  @Deprecated('Use uiAreas.activityBar.background instead')
  Color get activityBarBackground => uiAreas.activityBar.background;

  @Deprecated('Use uiAreas.activityBar.activeItem instead')
  Color get activityBarActiveItem => uiAreas.activityBar.activeItem;

  @Deprecated('Use uiAreas.activityBar.inactiveItem instead')
  Color get activityBarInactiveItem => uiAreas.activityBar.inactiveItem;

  @Deprecated('Use uiAreas.activityBar.hoverItem instead')
  Color get activityBarHoverItem => uiAreas.activityBar.hoverItem;

  @Deprecated('Use uiAreas.sideBar.background instead')
  Color get sidebarBackground => uiAreas.sideBar.background;

  @Deprecated('Use uiAreas.sideBar.divider instead')
  Color get sidebarDivider => uiAreas.sideBar.divider;

  @Deprecated('Use uiAreas.sideBar.groupHeader instead')
  Color get sidebarGroupHeader => uiAreas.sideBar.groupHeader;

  @Deprecated('Use uiAreas.sideBar.activeItemBackground instead')
  Color get sidebarActiveItemBackground => uiAreas.sideBar.activeItemBackground;

  @Deprecated('Use uiAreas.sideBar.activeItemText instead')
  Color get sidebarActiveItemText => uiAreas.sideBar.activeItemText;

  @Deprecated('Use uiAreas.sideBar.inactiveItemText instead')
  Color get sidebarInactiveItemText => uiAreas.sideBar.inactiveItemText;

  @Deprecated('Use uiAreas.sideBar.hoverBackground instead')
  Color get sidebarHoverBackground => uiAreas.sideBar.hoverBackground;

  @Deprecated('Use appSpecific.graph.nodeBase instead')
  Color get graphNodeBase => appSpecific.graph.nodeBase;

  @Deprecated('Use appSpecific.graph.nodeText instead')
  Color get graphNodeText => appSpecific.graph.nodeText;

  @Deprecated('Use appSpecific.graph.nodeIcon instead')
  Color get graphNodeIcon => appSpecific.graph.nodeIcon;

  @Deprecated('Use appSpecific.graph.linkBase instead')
  Color get graphLinkBase => appSpecific.graph.linkBase;

  @Deprecated('Use appSpecific.graph.selectionHighlight instead')
  Color get graphSelectionHighlight => appSpecific.graph.selectionHighlight;

  @Deprecated('Use appSpecific.graph.gridLine instead')
  Color get graphGridLine => appSpecific.graph.gridLine;

  @Deprecated('Use appSpecific.graph.background instead')
  Color get graphBackground => appSpecific.graph.background;

  @Deprecated('Use appSpecific.metadata.propertyName instead')
  Color get metadataPropertyName => appSpecific.metadata.propertyName;

  @Deprecated('Use appSpecific.metadata.propertyValue instead')
  Color get metadataPropertyValue => appSpecific.metadata.propertyValue;

  @Deprecated('Use appSpecific.metadata.tagBackground instead')
  Color get metadataTagBackground => appSpecific.metadata.tagBackground;

  @Deprecated('Use appSpecific.metadata.tagText instead')
  Color get metadataTagText => appSpecific.metadata.tagText;

  @Deprecated('Use status.info instead')
  Color get notificationInfo => status.info;

  @Deprecated('Use status.warning instead')
  Color get notificationWarning => status.warning;

  @Deprecated('Use status.error instead')
  Color get notificationError => status.error;

  @Deprecated('Use status.success instead')
  Color get notificationSuccess => status.success;

  @Deprecated('Use status.loading instead')
  Color get statusLoading => status.loading;

  @Deprecated('Use status.loading instead')
  Color get statusProgress => status.loading;

  @Deprecated('Use status.loadingBackground instead')
  Color get statusLoadingBackground => status.loadingBackground;

  @Deprecated('Use base.border instead')
  Color get containerBorder => base.border;

  @Deprecated('Use base.border instead')
  Color get containerActiveBorder => base.border;

  @Deprecated('Use interactive.input.border instead')
  Color get controlBorder => interactive.input.border;

  @Deprecated('Use interactive.input.focusBorder instead')
  Color get controlFocusBorder => interactive.input.focusBorder;

  @Deprecated('Use interactive.button.border.disabled instead')
  Color get controlDisabledBorder => interactive.button.border.disabled;

  @Deprecated('Use base.border instead')
  Color get navigationItemBorder => base.border;

  @Deprecated('Use base.selection instead')
  Color get navigationSelectedBorder => base.selection;

  @Deprecated('Use base.divider instead')
  Color get dividerHorizontal => base.divider;

  @Deprecated('Use base.divider instead')
  Color get dividerVertical => base.divider;

  @Deprecated('Use base.background instead')
  Color get mainContentBackground => base.background;

  @Deprecated('Use interactive.list.selectedBackground instead')
  Color get segmentedButtonSelectedBackground =>
      interactive.list.selectedBackground;

  @Deprecated('Use interactive.list.selectedBackground instead')
  Color get selectedCardBackground => interactive.list.selectedBackground;

  @Deprecated('Use uiAreas.dialog.background instead')
  Color get dialogBackground => uiAreas.dialog.background;

  @Deprecated('Use interactive.dropdown.itemBackground.hover instead')
  Color get dropdownMenuItemHoverBackground =>
      interactive.dropdown.itemBackground.hover;

  @Deprecated('Use interactive.list.itemBackground.hover instead')
  Color get listTileHoverBackground => interactive.list.itemBackground.hover;

  @Deprecated('Use interactive.popover.background instead')
  Color get popoverBackground => interactive.popover.background;

  @Deprecated('Use interactive.popover.text instead')
  Color get popoverText => interactive.popover.text;

  @Deprecated('Use interactive.popover.shadow instead')
  Color get popoverShadow => interactive.popover.shadow;

  @Deprecated('Use interactive.popover.barrier instead')
  Color get popoverBarrier => interactive.popover.barrier;

  @Deprecated('Use uiAreas.panel.background instead')
  Color get floatingControlBackground => uiAreas.panel.background;

  @Deprecated('Use base.foreground instead')
  Color get floatingControlIcon => base.foreground;

  @Deprecated('Use base.shadow instead')
  Color get floatingControlShadow => base.shadow;

  @Deprecated('Use appSpecific.graph.nodeBase instead')
  Color get accentColor => appSpecific.graph.nodeBase;

  @Deprecated('Use base.selection instead')
  Color get selectionBackground => base.selection;

  @Deprecated('Use interactive.button.border.normal instead')
  Color get buttonBorderColor => interactive.button.border.normal;

  @Deprecated('Use interactive.button.background.active instead')
  Color get buttonPressedBackground => interactive.button.background.active;

  @Deprecated('Use interactive.button.primaryBackground instead')
  Color get primaryButtonBackground => interactive.button.primaryBackground;

  @Deprecated('Use interactive.button.primaryText instead')
  Color get primaryButtonText => interactive.button.primaryText;

  @Deprecated('Use interactive.button.primaryPressedBackground instead')
  Color get primaryButtonPressedBackground =>
      interactive.button.primaryPressedBackground;
}

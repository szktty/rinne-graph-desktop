import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'models/app_color_scheme.dart';
import 'providers/theme_providers.dart';

/// Standard color definitions provided by the color scope.
///
/// To improve component reusability and maintainability,
/// provides color abstraction based on context.
class ColorScope {
  /// Text color within the scope.
  final Color text;

  /// Background color within the scope.
  final Color background;

  /// Border color within the scope.
  final Color border;

  /// Selection color within the scope.
  final Color selection;

  /// Hover color within the scope.
  final Color hover;

  /// Accent color within the scope.
  final Color accent;

  /// Disabled state color within the scope.
  final Color disabled;

  const ColorScope({
    required this.text,
    required this.background,
    required this.border,
    required this.selection,
    required this.hover,
    required this.accent,
    required this.disabled,
  });

  /// Creates a copy of the ColorScope.
  ColorScope copyWith({
    Color? text,
    Color? background,
    Color? border,
    Color? selection,
    Color? hover,
    Color? accent,
    Color? disabled,
  }) {
    return ColorScope(
      text: text ?? this.text,
      background: background ?? this.background,
      border: border ?? this.border,
      selection: selection ?? this.selection,
      hover: hover ?? this.hover,
      accent: accent ?? this.accent,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorScope &&
        other.text == text &&
        other.background == background &&
        other.border == border &&
        other.selection == selection &&
        other.hover == hover &&
        other.accent == accent &&
        other.disabled == disabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      text,
      background,
      border,
      selection,
      hover,
      accent,
      disabled,
    );
  }

  @override
  String toString() {
    return 'ColorScope('
        'text: $text, '
        'background: $background, '
        'border: $border, '
        'selection: $selection, '
        'hover: $hover, '
        'accent: $accent, '
        'disabled: $disabled'
        ')';
  }
}

/// Provider that manages the system's theme mode.
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; // Follow system settings
});

/// Provider that determines the current light/dark mode.
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeModeProvider);

  // Use existing platformBrightnessProvider
  final platformBrightness = ref.watch(platformBrightnessProvider);

  return mode == ThemeMode.dark ||
      (mode == ThemeMode.system && platformBrightness == Brightness.dark);
});

/// Provider that manages the entire color scheme.
/// Automatically updated when the theme changes.
final appColorSchemeProvider = Provider<AppColorScheme>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  // Use existing platformBrightnessProvider
  final platformBrightness = ref.watch(platformBrightnessProvider);

  // Determine actual brightness mode
  final actualBrightness = switch (themeMode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => platformBrightness,
  };

  // Generate ColorScheme according to brightness mode
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: actualBrightness,
  );

  return AppColorScheme.fromColorScheme(colorScheme);
});

/// Default ColorScope Provider.
/// Provides the basic color scope for the entire application.
final defaultColorScopeProvider = Provider<ColorScope>((ref) {
  final colors = ref.watch(appColorSchemeProvider);

  return ColorScope(
    text: colors.base.foreground,
    background: colors.base.background,
    border: colors.base.border,
    selection: colors.base.selection,
    hover: colors.interactive.list.itemBackground.hover,
    accent: colors.appSpecific.graph.nodeBase,
    disabled: colors.base.foreground.withAlpha(128),
  );
});

/// ColorScope Provider specifically for the activity bar.
final activityBarColorScopeProvider = Provider<ColorScope>((ref) {
  final colors = ref.watch(appColorSchemeProvider);
  final activityBar = colors.uiAreas.activityBar;

  return ColorScope(
    text: activityBar.activeItem,
    background: activityBar.background,
    border: colors.base.border,
    selection: activityBar.activeItem,
    hover: activityBar.hoverItem,
    accent: activityBar.activeItem,
    disabled: activityBar.inactiveItem,
  );
});

/// ColorScope Provider specifically for the sidebar.
final sideBarColorScopeProvider = Provider<ColorScope>((ref) {
  final colors = ref.watch(appColorSchemeProvider);
  final sideBar = colors.uiAreas.sideBar;

  return ColorScope(
    text: sideBar.inactiveItemText,
    background: sideBar.background,
    border: sideBar.divider,
    selection: sideBar.activeItemBackground,
    hover: sideBar.hoverBackground,
    accent: sideBar.activeItemText,
    disabled: sideBar.inactiveItemText.withAlpha(128),
  );
});

/// ColorScope Provider specifically for the main content area.
final mainContentColorScopeProvider = Provider<ColorScope>((ref) {
  final colors = ref.watch(appColorSchemeProvider);
  final graph = colors.appSpecific.graph;

  return ColorScope(
    text: graph.nodeText,
    background: graph.background,
    border: colors.base.border,
    selection: graph.selectionHighlight,
    hover: graph.selectionHighlight.withAlpha(128),
    accent: graph.nodeBase,
    disabled: graph.nodeText.withAlpha(128),
  );
});

/// ColorScope Provider specifically for dialogs.
final dialogColorScopeProvider = Provider<ColorScope>((ref) {
  final colors = ref.watch(appColorSchemeProvider);
  final dialog = colors.uiAreas.dialog;

  return ColorScope(
    text: dialog.foreground,
    background: dialog.background,
    border: dialog.border,
    selection: colors.base.selection,
    hover: colors.interactive.list.itemBackground.hover,
    accent: colors.appSpecific.graph.nodeBase,
    disabled: dialog.foreground.withAlpha(128),
  );
});

/// Provider that gets the current ColorScope.
/// If overridden by ProviderScope, use that value.
final colorScopeProvider = Provider<ColorScope>((ref) {
  // Returns the default color scope.
  // Overridden by ProviderScope during actual use.
  return ref.watch(defaultColorScopeProvider);
});

/// Helper functions for managing ColorScope hierarchy.
class ColorScopeHelper {
  /// Wraps a widget with the activity bar's ColorScope.
  static Widget withActivityBarScope({required Widget child}) {
    return Consumer(
      builder: (context, ref, _) {
        final scope = ref.watch(activityBarColorScopeProvider);
        return ProviderScope(
          overrides: [colorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with the sidebar's ColorScope.
  static Widget withSideBarScope({
    required Widget child,
    bool isActive = false,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final baseScope = ref.watch(sideBarColorScopeProvider);
        final colors = ref.watch(appColorSchemeProvider);

        final scope =
            isActive
                ? baseScope.copyWith(
                  text: colors.uiAreas.sideBar.activeItemText,
                  background: colors.uiAreas.sideBar.activeItemBackground,
                )
                : baseScope;

        return ProviderScope(
          overrides: [colorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with the main content's ColorScope.
  static Widget withMainContentScope({required Widget child}) {
    return Consumer(
      builder: (context, ref, _) {
        final scope = ref.watch(mainContentColorScopeProvider);
        return ProviderScope(
          overrides: [colorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with the dialog's ColorScope.
  static Widget withDialogScope({required Widget child}) {
    return Consumer(
      builder: (context, ref, _) {
        final scope = ref.watch(dialogColorScopeProvider);
        return ProviderScope(
          overrides: [colorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with a custom ColorScope.
  static Widget withCustomScope({
    required Widget child,
    required ColorScope scope,
  }) {
    return ProviderScope(
      overrides: [colorScopeProvider.overrideWithValue(scope)],
      child: child,
    );
  }
}

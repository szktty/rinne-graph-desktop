# core_themes

A theme management package for the App application. It provides a hierarchical color system inspired by VSCode's color theme structure and a context-aware color scope system.

## Overview

This package provides the necessary functionality for theme management in the App application:

- **Hierarchical Color System**: Systematic color management through BaseColors, UIAreaColors, InteractiveColors, etc.
- **Color Scope System**: Context-aware color abstraction for each UI area
- **Automatic Theme Switching**: Automatic adaptation to light/dark/system settings
- **Theme Color System**: Dynamic theme color switching (blue, purple, etc.)
- **Riverpod Integration**: Efficient state management and reactive updates

## Import

```dart
import 'package:core_themes/core_themes.dart';
```

## Hierarchical Color System

The RinneGraph project adopts a hierarchical color system inspired by VSCode's color theme structure.

### Color Structure

```dart
final colorScheme = ref.watch(appColorSchemeProvider);

// Base colors
colorScheme.base.foreground          // Base text color
colorScheme.base.background          // Base background color
colorScheme.base.selection           // Selection highlight
colorScheme.base.border              // Border color

// UI area colors
colorScheme.uiAreas.activityBar.background     // Activity bar background
colorScheme.uiAreas.sideBar.background         // Sidebar background
colorScheme.uiAreas.dialog.background          // Dialog background

// Status colors
colorScheme.status.info              // Info color
colorScheme.status.warning           // Warning color
colorScheme.status.error             // Error color
colorScheme.status.success           // Success color

// App-specific colors
colorScheme.appSpecific.graph.nodeBase         // Graph node color
colorScheme.appSpecific.graph.linkBase         // Graph link color
colorScheme.appSpecific.graph.selectionHighlight  // Selection highlight

// Theme color
colorScheme.theme.primaryColor       // Current theme color

// Interactive colors
colorScheme.interactive.list.itemBackground.hover  // List hover color
```

## Theme Management Providers

### Basic Theme Providers

```dart
// Theme mode management
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final isDarkModeProvider = Provider<bool>((ref) => /* Light/dark mode detection */);

// Main color scheme provider
final appColorSchemeProvider = Provider<AppColorScheme>((ref) {
  // Auto-generate color scheme based on light/dark mode
});

// Theme color provider
final themeColorTypeProvider = StateNotifierProvider<ThemeColorNotifier, ThemeColorType>((ref) {
  // Select theme color (blue, purple, etc.)
});

final effectiveColorSchemeWithThemeProvider = Provider<AppColorScheme>((ref) {
  // Final color scheme combining theme color and base color scheme
});
```

### Color Scope Providers

```dart
// Current scope (overridable)
final colorScopeProvider = Provider<ColorScope>((ref) => /* Current scope */);

// Area-specific scopes
final defaultColorScopeProvider = Provider<ColorScope>((ref) => /* Base scope */);
final activityBarColorScopeProvider = Provider<ColorScope>((ref) => /* Activity bar */);
final sideBarColorScopeProvider = Provider<ColorScope>((ref) => /* Sidebar */);
final mainContentColorScopeProvider = Provider<ColorScope>((ref) => /* Main content */);
final dialogColorScopeProvider = Provider<ColorScope>((ref) => /* Dialog */);
```

## ColorScope Class

A class that provides context-aware color abstraction.

```dart
class ColorScope {
  final Color text;           // Text color within scope
  final Color background;     // Background color within scope
  final Color border;         // Border color within scope
  final Color selection;      // Selection color within scope
  final Color hover;          // Hover color within scope
  final Color accent;         // Accent color within scope
  final Color disabled;       // Disabled state color within scope
}
```

## ColorScopeHelper Usage

The `ColorScopeHelper` class provides helper functionality for managing color scope hierarchy.

### Basic Usage Examples

```dart
// Wrap widget with activity bar color scope
ColorScopeHelper.withActivityBarScope(
  child: AppButton(
    label: 'Button',
    onPressed: () {},
  ),
)

// Wrap widget with sidebar color scope
ColorScopeHelper.withSideBarScope(
  isActive: true,  // Can specify active state
  child: NavigationItem(title: 'Item Name'),
)

// Wrap widget with main content color scope
ColorScopeHelper.withMainContentScope(
  child: GraphView(),
)

// Wrap widget with dialog color scope
ColorScopeHelper.withDialogScope(
  child: SettingsDialog(),
)

// Wrap widget with custom color scope
ColorScopeHelper.withCustomScope(
  scope: ColorScope(
    text: Colors.white,
    background: Colors.blue,
    // ...
  ),
  child: CustomWidget(),
)
```

## Usage

### Switching Theme Mode

```dart
class ThemeSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(themeModeProvider.notifier).state = ThemeMode.light;
          },
          child: Text('Light'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
          },
          child: Text('Dark'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(themeModeProvider.notifier).state = ThemeMode.system;
          },
          child: Text('System'),
        ),
      ],
    );
  }
}
```

### Selecting Theme Color

```dart
class ThemeColorPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentType = ref.watch(themeColorTypeProvider);

    return Wrap(
      children: ThemeColorType.values.map((type) {
        return GestureDetector(
          onTap: () {
            ref.read(themeColorTypeProvider.notifier).setThemeColor(type);
          },
          child: Container(
            width: 50,
            height: 50,
            color: ThemeColorScheme.defaultColors[type]!.lightColor,
            child: type == currentType ? Icon(Icons.check) : null,
          ),
        );
      }).toList(),
    );
  }
}
```

### Getting Color Scheme

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Base color scheme
    final colorScheme = ref.watch(appColorSchemeProvider);

    // Theme color integrated color scheme
    final themeColorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);

    return Container(
      color: colorScheme.base.background,
      child: Text(
        'Hello World',
        style: TextStyle(color: colorScheme.base.foreground),
      ),
    );
  }
}
```

## Best Practices for Component Development

### 1. Using Color Scope (Required)

Components must use color scope in principle. Avoid explicit color specification:

```dart
class MyComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(colorScopeProvider);

    return Container(
      color: scope.background,
      child: Text(
        'Text',
        style: TextStyle(color: scope.text),
      ),
    );
  }
}

// ❌ Prohibited: Explicit color specification
class BadComponent extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,  // Direct color specification prohibited
      child: Text(
        'Text',
        style: TextStyle(color: Colors.white),  // Direct color specification prohibited
      ),
    );
  }
}
```

### 2. Creating Theme-Aware Components

Example of component integrated with theme color:

```dart
class ThemeAwareButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const ThemeAwareButton({
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
          ? colorScheme.theme.primaryColor
          : colorScheme.base.background,
        foregroundColor: isPrimary
          ? Colors.white
          : colorScheme.base.foreground,
      ),
      child: Text(label),
    );
  }
}
```

### 3. Scope Hierarchy Management (Required)

Always use appropriate scope for each UI area:

```dart
// Component within sidebar
ColorScopeHelper.withSideBarScope(
  child: NavigationItem(title: 'Item'),
)

// Component within main content
ColorScopeHelper.withMainContentScope(
  child: GraphView(),
)

// Component within dialog
ColorScopeHelper.withDialogScope(
  child: SettingsForm(),
)
```

## Color Scope Hierarchy Structure

```
Application (Base Scope)
├── Activity Bar (Dedicated Scope)
├── Sidebar (Dedicated Scope)
│   ├── Normal Item (Default)
│   └── Active Item (Override)
├── Main Content (Dedicated Scope)
│   └── Graph View (Dedicated Scope)
└── Dialog (Dedicated Scope)
```

## Actual Component Usage Examples

App UI components automatically integrate with the theme system:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

class ComponentShowcase extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Theme-aware button
        AppButton(
          label: 'Primary Button',
          onPressed: () {},
          isPrimary: true,  // Auto-apply theme color
        ),

        // Theme-aware text
        AppText(
          'Theme-aware text',
          variant: AppTextVariant.uiHeading2,
        ),

        // Theme-aware input field
        AppTextField(
          decoration: InputDecoration(
            hintText: 'Theme-aware input',
          ),
        ),

        // Theme-aware checkbox
        AppCheckbox(
          value: true,
          onChanged: (_) {},
        ),
      ],
    );
  }
}
```

## Debugging and Testing

### Verify Color Scheme Demo
You can verify the color scheme system operation in the catalog app (`apps/catalog`):

```bash
cd apps/catalog
flutter run
```

### Verify Color Values in Console
```dart
final colors = ref.watch(appColorSchemeProvider);
print('Current foreground: ${colors.base.foreground}');
print('Current background: ${colors.base.background}');
```

## Related Files

- `packages/core/themes/lib/src/color_scope.dart` - ColorScope implementation
- `packages/core/themes/lib/src/models/app_color_scheme.dart` - AppColorScheme definition
- `apps/catalog/lib/src/demos/theme_management/color_scheme_demo.dart` - Demo implementation
- `docs/design/app_desktop-color-scheme-refactor-plan.md` - Design documentation

## Available Theme Colors

Currently available theme colors:

```dart
enum ThemeColorType {
  blue,      // Default blue
  purple,    // Purple
  pink,      // Pink
  red,       // Red
  orange,    // Orange
  yellow,    // Yellow
  green,     // Green
  teal,      // Teal
  cyan,      // Cyan
}

// Usage example
ref.read(themeColorTypeProvider.notifier).setThemeColor(ThemeColorType.purple);
```

## Future Extensions

The color system has the following extensions planned:

1. **Custom Theme Support** - User-defined color themes
2. **High Contrast Theme** - Accessibility support
3. **Animation Support** - Smooth color changes during theme switching
4. **Preset Themes** - Multiple predefined color themes

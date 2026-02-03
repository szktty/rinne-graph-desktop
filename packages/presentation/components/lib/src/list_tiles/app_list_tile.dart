import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_themes/core_themes.dart';

part 'app_list_tile.g.dart';

/// Provider that supplies an effective AppColorScheme.
@riverpod
AppColorScheme effectiveAppColorSchemeForListTile(
  EffectiveAppColorSchemeForListTileRef ref,
) {
  return AppThemePresets.light.appColorScheme;
}

/// A list tile that handles selection state and applies appropriate theme colors.
class AppListTile extends ConsumerWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHover;
  final Color? hoverColor;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const AppListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    this.dense = false,
    this.contentPadding,
    this.enableHover = true,
    this.hoverColor,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get AppColorScheme and accessibility config
    final appColorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Determine hover color (temporary implementation)
    final theme = Theme.of(context);
    final effectiveHoverColor =
        enableHover ? (hoverColor ?? theme.hoverColor) : Colors.transparent;

    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      selected: isSelected,
      selectedTileColor: appColorScheme.interactive.list.selectedBackground,
      selectedColor: appColorScheme.interactive.list.selectedText,
      hoverColor: effectiveHoverColor,
      splashColor: Colors.transparent,
      //highlightColor: Colors.transparent,
      enabled: onTap != null,
      onTap: onTap,
      onLongPress: onLongPress,
      dense: dense,
      contentPadding:
          contentPadding != null ? contentPadding! * zoomScale : null,
    );
  }
}

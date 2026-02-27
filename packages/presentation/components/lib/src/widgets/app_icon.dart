/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_themes/core_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../accessibility/app_accessible_widget.dart';

/// Icon size presets.
enum AppIconSize {
  /// 16px - Inline icons, small buttons.
  small(16.0),

  /// 20px - Form fields, list items.
  medium(20.0),

  /// 24px - Standard buttons, navigation (default).
  standard(24.0),

  /// 32px - Large buttons, header icons.
  large(32.0),

  /// 48px - Main actions, landing elements.
  xlarge(48.0);

  final double value;
  const AppIconSize(this.value);
}

/// Icon widget compliant with App design system.
///
/// Automatically applies zoom support and theme colors.
///
/// ```dart
/// // 基本的な使用
/// AppIcon(AppIcons.search)
///
/// // Specify size and color
/// AppIcon(
///   AppIcons.settings,
///   size: AppIconSize.large,
///   color: AppIconColor.primary,
/// )
///
/// // Custom size and color
/// AppIcon(
///   AppIcons.check,
///   customSize: 28.0,
///   customColor: Colors.green,
/// )
/// ```
class AppIcon extends AppAccessibleWidget {
  /// Icon data (selected from AppIcons).
  final IconData icon;

  /// Preset size.
  final AppIconSize size;

  /// Custom size (takes precedence over preset).
  final double? customSize;

  /// Semantic color (automatically obtained from theme).
  final AppIconColor? color;

  /// Custom color (takes precedence over semantic color).
  final Color? customColor;

  /// Semantic label (for accessibility).
  final String? semanticLabel;

  /// Text direction.
  final TextDirection? textDirection;

  /// List of shadows.
  final List<Shadow>? shadows;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.standard,
    this.customSize,
    this.color,
    this.customColor,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
    super.disableZoom,
    super.disableSemantics,
  });

  @override
  Widget buildAccessibleWidget({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Determine size (custom > preset)
    final baseSize = customSize ?? size.value;
    final scaledSize = getScaledValue(baseSize, accessibilityConfig.zoomScale);

    // Determine color (custom > semantic > default)
    final iconColor =
        customColor ??
        (color != null ? _getSemanticColor(color!, appColorScheme) : null) ??
        appColorScheme.appSpecific.graph.nodeText;

    return Icon(
      icon,
      size: scaledSize,
      color: iconColor,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      shadows: shadows,
    );
  }

  @override
  Widget buildSemantics(BuildContext context, Widget child) {
    if (disableSemantics || semanticLabel == null) {
      return child;
    }

    return Semantics(label: semanticLabel, image: true, child: child);
  }

  /// Get AppColorScheme color from semantic color
  Color _getSemanticColor(AppIconColor color, AppColorScheme colorScheme) {
    switch (color) {
      case AppIconColor.primary:
        return colorScheme.appSpecific.graph.nodeBase;
      case AppIconColor.onSurface:
        return colorScheme.appSpecific.graph.nodeText;
      case AppIconColor.onSurfaceVariant:
        return colorScheme.appSpecific.metadata.propertyValue;
      case AppIconColor.error:
        return colorScheme.status.error;
      case AppIconColor.warning:
        return colorScheme.status.warning;
      case AppIconColor.success:
        return colorScheme.status.success;
      case AppIconColor.info:
        return colorScheme.status.info;
      case AppIconColor.inactive:
        return colorScheme.uiAreas.sideBar.inactiveItemText;
      case AppIconColor.active:
        return colorScheme.uiAreas.sideBar.activeItemText;
    }
  }
}

/// Semantic color for icons.
enum AppIconColor {
  /// Primary color (accent, important actions).
  primary,

  /// Standard content color.
  onSurface,

  /// Auxiliary content color.
  onSurfaceVariant,

  /// Error state.
  error,

  /// Warning state.
  warning,

  /// Success state.
  success,

  /// Information display.
  info,

  /// Inactive state (e.g., sidebar).
  inactive,

  /// Active state (e.g., sidebar).
  active,
}

/// Shortcut factory methods.
extension AppIconFactories on AppIcon {
  /// Small icon (16px).
  static AppIcon small(
    IconData icon, {
    Key? key,
    AppIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: AppIconSize.small,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Medium icon (20px).
  static AppIcon medium(
    IconData icon, {
    Key? key,
    AppIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: AppIconSize.medium,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Large icon (32px).
  static AppIcon large(
    IconData icon, {
    Key? key,
    AppIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: AppIconSize.large,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Extra large icon (48px).
  static AppIcon xlarge(
    IconData icon, {
    Key? key,
    AppIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: AppIconSize.xlarge,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Error icon.
  static AppIcon error(
    IconData icon, {
    Key? key,
    AppIconSize size = AppIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: size,
      color: AppIconColor.error,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Warning icon.
  static AppIcon warning(
    IconData icon, {
    Key? key,
    AppIconSize size = AppIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: size,
      color: AppIconColor.warning,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Success icon.
  static AppIcon success(
    IconData icon, {
    Key? key,
    AppIconSize size = AppIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: size,
      color: AppIconColor.success,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }
}

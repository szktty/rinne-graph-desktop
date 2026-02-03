import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

import '../typography/app_text.dart';
import '../icons/app_icons.dart';
import '../styling/app_border_radius.dart';
import 'app_rectangle_border.dart';
import 'app_icon.dart';

/// Enum defining snack bar types.
enum AppSnackBarType {
  /// Information notification (default).
  info,

  /// Success notification.
  success,

  /// Warning notification.
  warning,

  /// Error notification.
  error,
}

/// App-specific wrapper for ScaffoldMessenger + SnackBar.
///
/// Provides snack bars with app-specific UI and accessibility support.
/// Uses App design system and AppColorScheme,
/// and supports accessibility settings (zoom, high contrast).
class AppSnackBar {
  /// Displays a snack bar.
  ///
  /// [context] - ビルドコンテキスト
  /// [message] - Message to display.
  /// [type] - Type of snack bar (default: info).
  /// [icon] - Custom icon (default icon based on type if not specified).
  /// [duration] - Display duration (default: 4 seconds).
  /// [actionLabel] - Label for the action button (optional).
  /// [onActionPressed] - Callback when the action button is pressed.
  /// [showCloseButton] - Whether to show a close button (default: false).
  static void show({
    required BuildContext context,
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseButton = false,
  }) {
    // Check if ScaffoldMessenger is available
    ScaffoldMessengerState? scaffoldMessengerState;
    try {
      scaffoldMessengerState = ScaffoldMessenger.maybeOf(context);
    } catch (e) {
      // If ScaffoldMessenger is not found
      debugPrint('ScaffoldMessenger not found: $e');
    }

    if (scaffoldMessengerState != null) {
      // If ScaffoldMessenger is available, display a normal SnackBar
      scaffoldMessengerState.hideCurrentSnackBar();

      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: _AppSnackBarContent(
            message: message,
            type: type,
            icon: icon,
          ),
          duration: duration,
          backgroundColor:
              Colors
                  .transparent, // Control background color with custom content
          elevation: 0, // Control shadow with custom content
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.zero, // Control padding with custom content
          action:
              (actionLabel != null && onActionPressed != null)
                  ? SnackBarAction(
                    label: actionLabel,
                    onPressed: onActionPressed,
                    textColor:
                        Colors
                            .white, // Action button color will be adjusted later
                  )
                  : null,
          showCloseIcon: showCloseButton,
          closeIconColor:
              Colors.white, // Close icon color will be adjusted later
        ),
      );
    } else {
      // If ScaffoldMessenger is not available, use fallback method
      _showFallbackNotification(
        context: context,
        message: message,
        type: type,
        icon: icon,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
      );
    }
  }

  /// Convenience method to display a success message snack bar.
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: AppSnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method to display an error message snack bar.
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseButton = true,
  }) {
    show(
      context: context,
      message: message,
      type: AppSnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      showCloseButton: showCloseButton,
    );
  }

  /// Convenience method to display a warning message snack bar.
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: AppSnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method to display an info message snack bar.
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: AppSnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Fallback notification method when ScaffoldMessenger is not available.
  static void _showFallbackNotification({
    required BuildContext context,
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseButton = false,
  }) {
    // Display as debug output
    debugPrint('AppSnackBar (${type.name}): $message');

    // In the future, a custom notification system using Overlay can be implemented
    // Currently, only debug output is supported
  }
}

/// Widget that displays the snack bar content.
class _AppSnackBarContent extends ConsumerWidget {
  final String message;
  final AppSnackBarType type;
  final IconData? icon;

  const _AppSnackBarContent({
    required this.message,
    required this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    final zoomScale = accessibilityConfig.zoomScale;

    // Determine color and icon based on snack bar type
    final snackBarStyle = _getSnackBarStyle(colorScheme, type);
    final effectiveIcon = icon ?? _getDefaultIcon(type);

    return AppRectangleBorder(
      cornerRadius: AppBorderRadiusValues.small * zoomScale, // 6px
      color: snackBarStyle.backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0 * zoomScale,
        vertical: 14.0 * zoomScale,
      ),
      child: Row(
        children: [
          if (effectiveIcon != null) ...[
            AppIcon(
              effectiveIcon,
              customSize: 24.0,
              customColor: snackBarStyle.iconColor,
              disableZoom: true, // zoomScale already applied
            ),
            SizedBox(width: 12.0 * zoomScale),
          ],
          Expanded(
            child: AppText(
              message,
              variant: AppTextVariant.bodyText,
              color: snackBarStyle.textColor,
              disableZoom: true, // zoomScale already applied
            ),
          ),
        ],
      ),
    );
  }

  /// Gets the style corresponding to the snack bar type.
  _SnackBarStyle _getSnackBarStyle(dynamic colorScheme, AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return _SnackBarStyle(
          backgroundColor: colorScheme.status.success,
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground,
        );
      case AppSnackBarType.error:
        return _SnackBarStyle(
          backgroundColor: colorScheme.status.error,
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground,
        );
      case AppSnackBarType.warning:
        return _SnackBarStyle(
          backgroundColor: colorScheme.status.warning,
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground,
        );
      case AppSnackBarType.info:
        return _SnackBarStyle(
          backgroundColor: colorScheme.base.background,
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground.withValues(alpha: 0.7),
        );
    }
  }

  /// Gets the default icon corresponding to the snack bar type.
  IconData? _getDefaultIcon(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return AppIcons.check;
      case AppSnackBarType.error:
        return AppIcons.error;
      case AppSnackBarType.warning:
        return AppIcons.error; // Using error icon as no warning icon exists
      case AppSnackBarType.info:
        return AppIcons.info;
    }
  }
}

/// Class that holds snack bar style information.
class _SnackBarStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const _SnackBarStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  });
}

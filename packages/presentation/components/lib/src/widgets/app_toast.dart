import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popover/popover.dart';
import 'package:core_themes/core_themes.dart';

import '../typography/app_text.dart';
import '../icons/app_icons.dart';
import '../styling/app_border_radius.dart';
import 'app_rectangle_border.dart';
import 'app_icon.dart';
import 'app_popover.dart';

/// Enum defining toast types.
enum AppToastType {
  /// Information notification (default).
  info,

  /// Success notification.
  success,

  /// Warning notification.
  warning,

  /// Error notification.
  error,
}

/// A toast widget displayed briefly at a specified position.
///
/// Implements AppPopover.showToast as an independent widget,
/// supporting the app-specific design system and accessibility.
class AppToast {
  /// Displays a toast at the specified position.
  ///
  /// [context] - ビルドコンテキスト
  /// [targetKey] - GlobalKey of the target widget to display the toast.
  /// [message] - Message to display.
  /// [type] - Type of toast (default: info).
  /// [icon] - Custom icon (default icon based on type if not specified).
  /// [duration] - Display duration (default: 2 seconds).
  /// [direction] - Display direction (default: top).
  /// [animation] - Animation type (default: none).
  static void show({
    required BuildContext context,
    required GlobalKey targetKey,
    required String message,
    AppToastType type = AppToastType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    PopoverDirection direction = PopoverDirection.top,
    AppPopoverAnimation animation = AppPopoverAnimation.none,
  }) {
    // Get target position and display popover
    final renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      // Dynamically calculate toast size
      final hasIcon = icon != null || _hasDefaultIcon(type);
      final baseWidth = hasIcon ? 140.0 : 120.0;
      final messageLength = message.length;
      final estimatedWidth = (baseWidth + messageLength * 7.0).clamp(
        120.0,
        320.0,
      );

      AppPopover.show(
        context: context,
        bodyBuilder:
            (context) =>
                _AppToastContent(message: message, type: type, icon: icon),
        duration: duration,
        direction: direction,
        animation: animation,
        width: estimatedWidth,
        height: 80, // 少し高めに設定
        arrowHeight: 0, // Toast-like, without an arrow
        arrowWidth: 0,
        barrierColor: Colors.transparent, // Make barrier transparent
        barrierDismissible: true,
      );
    }
  }

  /// Displays a toast at the cursor position.
  ///
  /// マウスカーソルの現在位置にトーストを表示します。
  /// Can be used as an alternative when the GlobalKey of a button cannot be obtained.
  static void showAtCursor({
    required BuildContext context,
    required String message,
    AppToastType type = AppToastType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    PopoverDirection direction = PopoverDirection.top,
    AppPopoverAnimation animation = AppPopoverAnimation.none,
  }) {
    // Dynamically calculate toast size
    final hasIcon = icon != null || _hasDefaultIcon(type);
    final baseWidth = hasIcon ? 140.0 : 120.0;
    final messageLength = message.length;
    final estimatedWidth = (baseWidth + messageLength * 7.0).clamp(
      120.0,
      320.0,
    );

    AppPopover.show(
      context: context,
      duration: duration,
      direction: direction,
      animation: animation,
      width: estimatedWidth,
      height: 80, // 少し高めに設定
      arrowHeight: 0, // Toast-like, without an arrow
      arrowWidth: 0,
      barrierColor: Colors.transparent, // Make barrier transparent
      barrierDismissible: true,
      bodyBuilder:
          (context) =>
              _AppToastContent(message: message, type: type, icon: icon),
    );
  }

  /// Convenience method to display a success message toast.
  static void showSuccess({
    required BuildContext context,
    required GlobalKey targetKey,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context: context,
      targetKey: targetKey,
      message: message,
      type: AppToastType.success,
      duration: duration,
    );
  }

  /// Convenience method to display an error message toast.
  static void showError({
    required BuildContext context,
    required GlobalKey targetKey,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      targetKey: targetKey,
      message: message,
      type: AppToastType.error,
      duration: duration,
    );
  }

  /// Convenience method to display a warning message toast.
  static void showWarning({
    required BuildContext context,
    required GlobalKey targetKey,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      targetKey: targetKey,
      message: message,
      type: AppToastType.warning,
      duration: duration,
    );
  }

  /// Convenience method to display an info message toast.
  static void showInfo({
    required BuildContext context,
    required GlobalKey targetKey,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context: context,
      targetKey: targetKey,
      message: message,
      type: AppToastType.info,
      duration: duration,
    );
  }

  /// Determines if a toast type has a default icon.
  static bool _hasDefaultIcon(AppToastType type) {
    switch (type) {
      case AppToastType.success:
      case AppToastType.error:
      case AppToastType.warning:
      case AppToastType.info:
        return true;
    }
  }
}

/// Widget that displays the toast content.
class _AppToastContent extends ConsumerWidget {
  final String message;
  final AppToastType type;
  final IconData? icon;

  const _AppToastContent({
    required this.message,
    required this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    final zoomScale = accessibilityConfig.zoomScale;

    // Determine color and icon based on toast type
    final toastStyle = _getToastStyle(colorScheme, type);
    final effectiveIcon = icon ?? _getDefaultIcon(type);

    return IntrinsicWidth(
      child: AppRectangleBorder(
        cornerRadius: AppBorderRadiusValues.small * zoomScale, // 8px
        color: toastStyle.backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: 16.0 * zoomScale,
          vertical: 12.0 * zoomScale,
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 80.0 * zoomScale,
            maxWidth: 280.0 * zoomScale,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (effectiveIcon != null) ...[
                AppIcon(
                  effectiveIcon,
                  customSize: 20.0,
                  customColor: toastStyle.iconColor,
                  disableZoom: true, // zoomScale already applied
                ),
                SizedBox(width: 8.0 * zoomScale),
              ],
              Flexible(
                child: AppText(
                  message,
                  variant: AppTextVariant.bodyText,
                  color: toastStyle.textColor,
                  disableZoom: true, // zoomScale already applied
                  maxLines: 2, // Limit to a maximum of 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the style corresponding to the toast type.
  _ToastStyle _getToastStyle(dynamic colorScheme, AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return _ToastStyle(
          backgroundColor: colorScheme.status.success.withValues(alpha: 0.9),
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground,
        );
      case AppToastType.error:
        return _ToastStyle(
          backgroundColor: colorScheme.status.error.withValues(alpha: 0.9),
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground,
        );
      case AppToastType.warning:
        return _ToastStyle(
          backgroundColor: colorScheme.status.warning.withValues(alpha: 0.9),
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground,
        );
      case AppToastType.info:
        return _ToastStyle(
          backgroundColor: colorScheme.base.background.withValues(alpha: 0.95),
          textColor: colorScheme.base.foreground,
          iconColor: colorScheme.base.foreground.withValues(alpha: 0.7),
        );
    }
  }

  /// Gets the default icon corresponding to the toast type.
  IconData? _getDefaultIcon(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return AppIcons.check;
      case AppToastType.error:
        return AppIcons.error;
      case AppToastType.warning:
        return AppIcons.error; // Using error icon as no warning icon exists
      case AppToastType.info:
        return AppIcons.info;
    }
  }
}

/// Class that holds toast style information.
class _ToastStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const _ToastStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  });
}

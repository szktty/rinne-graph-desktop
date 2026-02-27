/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/src/spacing/app_spacing.dart';
import 'package:presentation_components/src/widgets/app_rectangle_border.dart';
import 'package:presentation_components/src/typography/app_text.dart';

/// Button role (Apple HIG compliant)
enum _AppButtonRole {
  /// Normal button - no special meaning
  normal,

  /// Primary button - default button that user is most likely to select
  primary,

  /// Cancel button - cancel current action
  cancel,

  /// Destructive operation button - operation that may lead to data destruction
  destructive,
}

/// Common Button for App app
///
/// Basic button component with design similar to AppDropdownMenu.
/// Achieves Figma-style rounded rectangle design using AppRectangleBorder,
/// and obtains theme colors via core_themes capsule.
class AppButton extends ConsumerWidget {
  /// Button label
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button leading icon (optional)
  final Widget? leadingIcon;

  /// Button trailing icon (optional)
  final Widget? trailingIcon;

  /// Button width
  final double? width;

  /// Button height
  final double? height;

  /// Text style
  final TextStyle? textStyle;

  /// Enabled/disabled state
  final bool enabled;

  /// Button background color
  final Color? backgroundColor;

  /// Button border color
  final Color? borderColor;

  /// Text color
  final Color? textColor;

  /// Background color on hover
  final Color? hoverBackgroundColor;

  /// Background color on press
  final Color? pressedBackgroundColor;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Whether to adjust height according to parent constraints
  final bool expandHeight;

  /// Button role (internal use)
  final _AppButtonRole _role;

  /// Basic constructor
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.textStyle,
    this.enabled = true,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hoverBackgroundColor,
    this.pressedBackgroundColor,
    this.disableZoom = false,
    this.expandHeight = false,
  }) : _role = _AppButtonRole.normal;

  /// Normal button (auto width, default color)
  const AppButton.normal({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.disableZoom = false,
    this.expandHeight = false,
  }) : width = null,
       height = null,
       textStyle = null,
       backgroundColor = null,
       borderColor = null,
       textColor = null,
       hoverBackgroundColor = null,
       pressedBackgroundColor = null,
       _role = _AppButtonRole.normal;

  /// Primary button (120px width, accent color)
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.disableZoom = false,
  }) : width = 120,
       height = null,
       leadingIcon = null,
       trailingIcon = null,
       textStyle = null,
       backgroundColor = null,
       borderColor = null,
       textColor = null,
       hoverBackgroundColor = null,
       pressedBackgroundColor = null,
       expandHeight = false,
       _role = _AppButtonRole.primary;

  /// Cancel button (100px width, secondary color)
  const AppButton.cancel({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.disableZoom = false,
  }) : width = 100,
       height = null,
       leadingIcon = null,
       trailingIcon = null,
       textStyle = null,
       backgroundColor = null,
       borderColor = null,
       textColor = null,
       hoverBackgroundColor = null,
       pressedBackgroundColor = null,
       expandHeight = false,
       _role = _AppButtonRole.cancel;

  /// Destructive operation button (120px width, red color)
  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.disableZoom = false,
  }) : width = 120,
       height = null,
       leadingIcon = null,
       trailingIcon = null,
       textStyle = null,
       backgroundColor = null,
       borderColor = null,
       textColor = null,
       hoverBackgroundColor = null,
       pressedBackgroundColor = null,
       expandHeight = false,
       _role = _AppButtonRole.destructive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme colors using core_themes API
    final appColorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);
    final themeData = ref.watch(effectiveThemeDataProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Get color scope (with fallback)
    final colorScope = ref.watch(defaultColorScopeProvider);

    // Use unified rectangular border with AppRectangleBorder
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // Build text style
    final effectiveTextStyle =
        textStyle ??
        themeData.textTheme.bodyMedium?.copyWith(color: colorScope.text);

    return _AppButtonWidget(
      label: label,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      width: width != null ? width! * zoomScale : null,
      height: height != null ? height! * zoomScale : null,
      textStyle: effectiveTextStyle,
      enabled: enabled,
      backgroundColor: _getEffectiveBackgroundColor(appColorScheme, colorScope),
      borderColor: _getEffectiveBorderColor(appColorScheme, colorScope),
      textColor: _getEffectiveTextColor(appColorScheme, colorScope),
      hoverBackgroundColor: hoverBackgroundColor ?? colorScope.hover,
      pressedBackgroundColor: _getEffectivePressedBackgroundColor(
        appColorScheme,
      ),
      zoomScale: zoomScale,
      borderScale: borderScale,
      role: _role,
      disableZoom: disableZoom,
      expandHeight: expandHeight,
    );
  }

  /// Get background color based on role
  Color _getEffectiveBackgroundColor(
    AppColorScheme appColorScheme,
    ColorScope colorScope,
  ) {
    if (backgroundColor != null) return backgroundColor!;

    switch (_role) {
      case _AppButtonRole.destructive:
        return enabled
            ? appColorScheme.interactive.button.destructiveBackground
            : appColorScheme.interactive.button.destructiveBackground
                .withValues(alpha: 0.38);
      case _AppButtonRole.primary:
        return enabled
            ? appColorScheme.theme.primaryColor
            : appColorScheme.base.background;
      case _AppButtonRole.cancel:
      case _AppButtonRole.normal:
        return appColorScheme.base.background;
    }
  }

  /// Get border color based on role
  Color _getEffectiveBorderColor(
    AppColorScheme appColorScheme,
    ColorScope colorScope,
  ) {
    if (borderColor != null) return borderColor!;

    switch (_role) {
      case _AppButtonRole.destructive:
        return enabled
            ? appColorScheme.interactive.button.destructiveBackground
            : appColorScheme.interactive.button.destructiveBackground
                .withValues(alpha: 0.38);
      case _AppButtonRole.primary:
        return enabled
            ? appColorScheme.theme.primaryColor
            : appColorScheme.base.border;
      case _AppButtonRole.cancel:
      case _AppButtonRole.normal:
        return appColorScheme.base.border;
    }
  }

  /// Get text color based on role
  Color _getEffectiveTextColor(
    AppColorScheme appColorScheme,
    ColorScope colorScope,
  ) {
    if (textColor != null) return textColor!;

    switch (_role) {
      case _AppButtonRole.destructive:
        return appColorScheme.interactive.button.destructiveText;
      case _AppButtonRole.primary:
        return enabled
            ? appColorScheme.interactive.button.primaryText
            : appColorScheme.base.foreground;
      case _AppButtonRole.cancel:
      case _AppButtonRole.normal:
        return appColorScheme.base.foreground;
    }
  }

  /// Get pressed background color based on role
  Color _getEffectivePressedBackgroundColor(AppColorScheme appColorScheme) {
    if (pressedBackgroundColor != null) return pressedBackgroundColor!;

    switch (_role) {
      case _AppButtonRole.destructive:
        return appColorScheme.interactive.button.destructivePressedBackground;
      case _AppButtonRole.primary:
        return enabled
            ? appColorScheme.theme.primaryColor.withValues(alpha: 0.8)
            : appColorScheme.interactive.button.background.active;
      case _AppButtonRole.cancel:
      case _AppButtonRole.normal:
        return appColorScheme.interactive.button.background.active;
    }
  }
}

// AppButton constants
class _AppButtonConstants {
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 4.0;
  static const double defaultHeight = 32.0;
  static const double spacing = 4.0;
}

/// Internal implementation widget for AppButton
class _AppButtonWidget extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final bool enabled;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color hoverBackgroundColor;
  final Color pressedBackgroundColor;
  final double zoomScale;
  final double borderScale;
  final _AppButtonRole role;
  final bool disableZoom;
  final bool expandHeight;

  const _AppButtonWidget({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.textStyle,
    this.enabled = true,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.hoverBackgroundColor,
    required this.pressedBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
    required this.role,
    required this.disableZoom,
    required this.expandHeight,
  });

  @override
  State<_AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<_AppButtonWidget> {
  bool _isPressed = false;

  Color get _currentBackgroundColor {
    if (!widget.enabled) {
      // Make transparent when disabled
      return Colors.transparent;
    }
    if (_isPressed) {
      return widget.pressedBackgroundColor;
    }
    // Use set background color normally
    return widget.backgroundColor;
  }

  Color get _currentTextColor {
    if (!widget.enabled) {
      // In disabled state, treat primary button same as normal button
      return widget.textColor.withValues(alpha: 0.38);
    }
    return widget.textColor;
  }

  Color get _currentBorderColor {
    if (!widget.enabled) {
      // In disabled state, treat primary button same as normal button
      return widget.borderColor.withValues(alpha: 0.12);
    }
    return widget.borderColor;
  }

  /// Get effective padding based on role
  EdgeInsets _getEffectivePadding() {
    // When fixed width is specified (cancel, primary, destructive), padding is 0
    if (widget.width != null) {
      return EdgeInsets.symmetric(
        vertical: _AppButtonConstants.verticalPadding * widget.zoomScale,
      );
    }

    // For auto width (normal), use normal padding
    return EdgeInsets.symmetric(
      horizontal: _AppButtonConstants.horizontalPadding * widget.zoomScale,
      vertical: _AppButtonConstants.verticalPadding * widget.zoomScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If expandHeight is true, don't specify height (follow parent constraints)
    final effectiveHeight =
        widget.expandHeight
            ? null
            : (widget.height ??
                _AppButtonConstants.defaultHeight * widget.zoomScale);

    Widget rectangleBorder = AppRectangleBorder(
      width: widget.width,
      height: effectiveHeight,
      color: _currentBackgroundColor,
      side: BorderSide(
        color: _currentBorderColor,
        width: 1.5 * widget.borderScale,
      ),
      alignment: Alignment(
        0.0,
        0.05,
      ), // Adjust slightly up to correct text position offset
      padding: _getEffectivePadding(),
      child: Row(
        mainAxisSize:
            widget.width != null ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment
                .center, // Adjust text vertical position to center
        children: [
          if (widget.leadingIcon != null) ...[
            widget.enabled
                ? widget.leadingIcon!
                : Opacity(opacity: 0.38, child: widget.leadingIcon!),
            AppSpacing.horizontal(
              _AppButtonConstants.spacing * widget.zoomScale,
            ),
          ],
          if (widget.width != null)
            Expanded(
              child: AppText(
                widget.label,
                variant: AppTextVariant.buttonLabel,
                color: _currentTextColor,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                disableZoom: widget.disableZoom,
              ),
            )
          else
            AppText(
              widget.label,
              variant: AppTextVariant.buttonLabel,
              color: _currentTextColor,
              overflow: TextOverflow.ellipsis,
              disableZoom: widget.disableZoom,
            ),
          if (widget.trailingIcon != null) ...[
            AppSpacing.horizontal(
              _AppButtonConstants.spacing * widget.zoomScale,
            ),
            widget.enabled
                ? widget.trailingIcon!
                : Opacity(opacity: 0.38, child: widget.trailingIcon!),
          ],
        ],
      ),
    );

    // If expandHeight is true, expand to parent constraints with SizedBox.expand
    Widget content =
        widget.expandHeight
            ? SizedBox.expand(child: rectangleBorder)
            : rectangleBorder;

    // When width is not specified, limit to content size with IntrinsicWidth
    if (widget.width == null) {
      content = IntrinsicWidth(child: content);
    }

    return GestureDetector(
      onTapDown:
          widget.enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp:
          widget.enabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel:
          widget.enabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.enabled ? widget.onPressed : null,
      child: content,
    );
  }
}

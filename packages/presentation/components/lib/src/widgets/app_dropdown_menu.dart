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
import 'app_rectangle_border.dart';
import '../icons/app_icons.dart';
import '../typography/app_text.dart';

/// Vertical position of AppDropdownMenu
enum AppDropdownMenuPosition {
  /// Focus on selected item and overlay (default)
  overlay,

  /// Display below dropdown button
  below,

  /// Display above dropdown button
  above,
}

/// Horizontal alignment of AppDropdownMenu
enum AppDropdownMenuAlignment {
  /// Left aligned
  left,

  /// Center aligned
  center,

  /// Right aligned
  right,

  /// Overhang to left (overlay menu expands to left side)
  leftOverhang,
}

// Constants for AppDropdownMenu (adjusted to match AppButton)
class _AppDropdownMenuConstants {
  static const double checkboxSpaceWidth = 16.0;
  static const double spacing = 4.0;
  static const double checkIconSize = 12.0;
  static const double chevronIconSize = 16.0;
  static const double horizontalPadding = 16.0; // 12.0 → 16.0 (match AppButton)
  static const double verticalPadding =
      4.0; // 6.0 → 4.0 (adjust label position)
  static const double defaultHeight = 32.0; // 48.0 → 32.0 (match AppButton)
  static const double standardIconSize =
      24.0; // Standard size for leading/trailing icons
  static const double widthMargin = 8.0; // Safety margin for width calculation

  // Total offset of checkbox space + spacing
  static const double totalOffset = checkboxSpaceWidth + spacing;
}

/// Common DropdownMenu for App app
///
/// Provides a design where menu items completely cover the dropdown button
/// when selected using a custom overlay menu.
/// Achieves Figma-style rounded rectangle design using AppRectangleBorder,
/// and obtains theme colors via core_themes capsule.
class AppDropdownMenu<T> extends ConsumerWidget {
  /// Initial selection value
  final T? initialSelection;

  /// Callback when selection changes
  final ValueChanged<T?>? onSelected;

  /// List of dropdown menu entries
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  /// Width of dropdown menu
  final double? width;

  /// Height of dropdown menu
  final double? height;

  /// Text style
  final TextStyle? textStyle;

  /// Hint text
  final String? hintText;

  /// Enabled/disabled state
  final bool enabled;

  /// Corner radius (uses AppRectangleBorder default if not specified)
  final double? cornerRadius;

  /// Corner smoothing (uses AppRectangleBorder default if not specified)
  final double? cornerSmoothing;

  /// Background color of dropdown button
  final Color? backgroundColor;

  /// Border color of dropdown button
  final Color? borderColor;

  /// Background color of overlay menu
  final Color? overlayBackgroundColor;

  /// Border color of overlay menu
  final Color? overlayBorderColor;

  /// Text color
  final Color? textColor;

  /// Vertical position of overlay menu
  final AppDropdownMenuPosition position;

  /// Horizontal alignment of overlay menu
  final AppDropdownMenuAlignment alignment;

  /// Whether to show checkmark for selected item
  final bool showCheckmark;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Whether to display as action icon button
  /// If true, dropdown button is displayed as action icon (3-dot menu)
  final bool showAsActionIcon;

  /// Icon data for action icon (used when showAsActionIcon is true)
  final IconData? actionIcon;

  /// Constructor
  const AppDropdownMenu({
    super.key,
    this.initialSelection,
    this.onSelected,
    required this.dropdownMenuEntries,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.enabled = true,
    this.cornerRadius,
    this.cornerSmoothing,
    this.backgroundColor,
    this.borderColor,
    this.overlayBackgroundColor,
    this.overlayBorderColor,
    this.textColor,
    this.position = AppDropdownMenuPosition.overlay,
    this.alignment = AppDropdownMenuAlignment.leftOverhang,
    this.showCheckmark = true,
    this.disableZoom = false,
    this.showAsActionIcon = false,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AppDropdownMenuWidget<T>(
      initialSelection: initialSelection,
      onSelected: onSelected,
      dropdownMenuEntries: dropdownMenuEntries,
      width: width,
      height: height,
      textStyle: textStyle,
      hintText: hintText,
      enabled: enabled,
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      overlayBackgroundColor: overlayBackgroundColor,
      overlayBorderColor: overlayBorderColor,
      textColor: textColor,
      position: position,
      alignment: alignment,
      showCheckmark: showCheckmark,
      disableZoom: disableZoom,
      showAsActionIcon: showAsActionIcon,
      actionIcon: actionIcon,
    );
  }
}

/// Internal implementation widget for AppDropdownMenu
class _AppDropdownMenuWidget<T> extends ConsumerWidget {
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final bool enabled;
  final double? cornerRadius;
  final double? cornerSmoothing;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? overlayBackgroundColor;
  final Color? overlayBorderColor;
  final Color? textColor;
  final AppDropdownMenuPosition position;
  final AppDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final bool disableZoom;
  final bool showAsActionIcon;
  final IconData? actionIcon;

  const _AppDropdownMenuWidget({
    super.key,
    this.initialSelection,
    this.onSelected,
    required this.dropdownMenuEntries,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.enabled = true,
    this.cornerRadius,
    this.cornerSmoothing,
    this.backgroundColor,
    this.borderColor,
    this.overlayBackgroundColor,
    this.overlayBorderColor,
    this.textColor,
    required this.position,
    required this.alignment,
    required this.showCheckmark,
    this.disableZoom = false,
    this.showAsActionIcon = false,
    this.actionIcon,
  });

  /// Calculate maximum item width for dropdown button
  double _calculateMaxItemWidth({
    required List<DropdownMenuEntry<T>> dropdownMenuEntries,
    required TextStyle? textStyle,
    required bool showCheckmark,
    required AppDropdownMenuAlignment alignment,
    required double zoomScale,
  }) {
    double maxWidth = 0.0;

    for (final entry in dropdownMenuEntries) {
      double itemWidth = 0.0;

      // Add horizontal padding (for dropdown button)
      itemWidth += _AppDropdownMenuConstants.horizontalPadding * 2 * zoomScale;

      // Checkmark is not displayed on dropdown button,
      // so don't include checkmark space

      // Add leading icon space
      if (entry.leadingIcon != null) {
        itemWidth += _AppDropdownMenuConstants.standardIconSize * zoomScale;
        itemWidth += _AppDropdownMenuConstants.spacing * zoomScale;
      }

      // Calculate text width (using text style with zoom scale applied)
      final zoomedTextStyle = textStyle?.copyWith(
        fontSize: (textStyle.fontSize ?? 14.0) * zoomScale,
      );
      final textPainter = TextPainter(
        text: TextSpan(text: entry.label, style: zoomedTextStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textWidth = textPainter.size.width;
      itemWidth += textWidth;

      // Add trailing icon space
      if (entry.trailingIcon != null) {
        itemWidth += _AppDropdownMenuConstants.spacing * zoomScale;
        itemWidth += _AppDropdownMenuConstants.standardIconSize * zoomScale;
      }

      // Add chevron icon space (for dropdown button)
      itemWidth += _AppDropdownMenuConstants.spacing * zoomScale;
      itemWidth += _AppDropdownMenuConstants.chevronIconSize * zoomScale;

      maxWidth = maxWidth > itemWidth ? maxWidth : itemWidth;
    }

    // Add safety margin to prevent rendering errors
    return maxWidth + _AppDropdownMenuConstants.widthMargin * zoomScale;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme colors using core_themes API
    final appColorScheme = ref.watch(appColorSchemeProvider);
    final themeData = Theme.of(context);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Create AppBorderRadius
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final appBorderRadius = AppBorderRadius.create(
      cornerRadius: cornerRadius != null ? cornerRadius! * zoomScale : null,
      cornerSmoothing: cornerSmoothing,
    );
    final smoothBorderRadius = appBorderRadius.toSmoothBorderRadius();

    // Build text style
    final effectiveTextStyle =
        textStyle ??
        themeData.textTheme.bodyMedium?.copyWith(
          color: appColorScheme.base.foreground,
        );

    // Get currently selected value
    final selectedEntry =
        dropdownMenuEntries
            .where((entry) => entry.value == initialSelection)
            .firstOrNull;

    // If width is not specified, calculate maximum width of all items
    double? effectiveWidth;
    if (showAsActionIcon) {
      // For action icon button, button itself is square
      // but menu width is calculated from maximum item width
      effectiveWidth = _calculateMaxItemWidth(
        dropdownMenuEntries: dropdownMenuEntries,
        textStyle: effectiveTextStyle,
        showCheckmark: showCheckmark,
        alignment: alignment,
        zoomScale: zoomScale,
      );
    } else if (width != null && width!.isFinite) {
      effectiveWidth = width! * zoomScale;
    } else {
      // Calculate maximum width of menu items
      effectiveWidth = _calculateMaxItemWidth(
        dropdownMenuEntries: dropdownMenuEntries,
        textStyle: effectiveTextStyle,
        showCheckmark: showCheckmark,
        alignment: alignment,
        zoomScale: zoomScale,
      );
    }

    return _AppDropdownButton<T>(
      selectedEntry: selectedEntry,
      dropdownMenuEntries: dropdownMenuEntries,
      onSelected: onSelected,
      width: effectiveWidth,
      height: height != null ? height! * zoomScale : null,
      textStyle: effectiveTextStyle,
      hintText: hintText,
      enabled: enabled,
      borderRadius: smoothBorderRadius,
      backgroundColor: backgroundColor ?? appColorScheme.base.background,
      borderColor: borderColor ?? appColorScheme.base.border,
      overlayBackgroundColor:
          overlayBackgroundColor ?? appColorScheme.base.background,
      overlayBorderColor: overlayBorderColor ?? appColorScheme.base.border,
      textColor: textColor ?? appColorScheme.base.foreground,
      position: position,
      alignment: alignment,
      showCheckmark: showCheckmark,
      hoverBackgroundColor:
          appColorScheme.interactive.list.itemBackground.hover,
      zoomScale: zoomScale,
      borderScale: borderScale,
      showAsActionIcon: showAsActionIcon,
      actionIcon: actionIcon,
    );
  }
}

/// Custom dropdown button implementation
class _AppDropdownButton<T> extends StatefulWidget {
  final DropdownMenuEntry<T>? selectedEntry;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final bool enabled;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color overlayBackgroundColor;
  final Color overlayBorderColor;
  final Color textColor;
  final AppDropdownMenuPosition position;
  final AppDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final double borderScale;
  final bool showAsActionIcon;
  final IconData? actionIcon;

  const _AppDropdownButton({
    super.key,
    this.selectedEntry,
    required this.dropdownMenuEntries,
    this.onSelected,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.enabled = true,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.overlayBackgroundColor,
    required this.overlayBorderColor,
    required this.textColor,
    required this.position,
    required this.alignment,
    required this.showCheckmark,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
    this.showAsActionIcon = false,
    this.actionIcon,
  });

  @override
  State<_AppDropdownButton<T>> createState() => _AppDropdownButtonState<T>();
}

class _AppDropdownButtonState<T> extends State<_AppDropdownButton<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _showOverlay() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  /// Get hover background color
  Color _getHoverBackgroundColor() {
    return widget.hoverBackgroundColor;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Get index of selected item
    final selectedIndex = widget.dropdownMenuEntries.indexWhere(
      (entry) => entry.value == widget.selectedEntry?.value,
    );

    // Calculate vertical offset based on position
    double verticalOffset;
    switch (widget.position) {
      case AppDropdownMenuPosition.overlay:
        // Calculate so selected item aligns with dropdown button position
        verticalOffset =
            selectedIndex >= 0 ? -selectedIndex * size.height : 0.0;
        break;
      case AppDropdownMenuPosition.below:
        // Display below dropdown button
        verticalOffset = size.height;
        break;
      case AppDropdownMenuPosition.above:
        // Display above dropdown button
        verticalOffset = -(widget.dropdownMenuEntries.length * size.height);
        break;
    }

    // Calculate overlay menu width
    final overlayWidth =
        widget.showAsActionIcon
            ? (widget.width ??
                200.0) // For action icon button, use calculated width
            : size.width; // For normal case, use button's actual width

    // Calculate horizontal offset based on alignment
    // Adjust offset based on whether checkmark is displayed
    final checkmarkOffset =
        widget.showCheckmark
            ? _AppDropdownMenuConstants.totalOffset * widget.zoomScale
            : 0.0;
    double horizontalOffset;
    switch (widget.alignment) {
      case AppDropdownMenuAlignment.left:
        horizontalOffset = 0.0;
        break;
      case AppDropdownMenuAlignment.center:
        horizontalOffset = -checkmarkOffset / 2;
        break;
      case AppDropdownMenuAlignment.right:
        horizontalOffset = -checkmarkOffset;
        break;
      case AppDropdownMenuAlignment.leftOverhang:
        horizontalOffset = -checkmarkOffset;
        break;
    }

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            // Close menu when tapping outside overlay menu
            onTap: _removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                // Transparent area covering entire screen
                Positioned.fill(child: Container(color: Colors.transparent)),
                // Overlay menu body
                Positioned(
                  width: overlayWidth,
                  height:
                      widget.dropdownMenuEntries.length *
                          (_AppDropdownMenuConstants.defaultHeight *
                              widget.zoomScale) +
                      _AppDropdownMenuConstants.verticalPadding *
                          widget.zoomScale,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(
                      horizontalOffset,
                      verticalOffset - 0.5,
                    ), // Adjusted from +1.0 → -0.5 (middle value)
                    child: GestureDetector(
                      // Don't propagate taps inside menu to parent GestureDetector
                      onTap: () {},
                      child: Material(
                        color: Colors.transparent,
                        child: _AppDropdownOverlay<T>(
                          entries: widget.dropdownMenuEntries,
                          onSelected: (value) {
                            widget.onSelected?.call(value);
                            _removeOverlay();
                          },
                          borderRadius: widget.borderRadius,
                          backgroundColor: widget.overlayBackgroundColor,
                          borderColor: widget.overlayBorderColor,
                          textColor: widget.textColor,
                          textStyle: widget.textStyle,
                          buttonHeight: size.height,
                          selectedValue: widget.selectedEntry?.value,
                          overlayWidth: overlayWidth,
                          alignment: widget.alignment,
                          showCheckmark: widget.showCheckmark,
                          hoverBackgroundColor: _getHoverBackgroundColor(),
                          zoomScale: widget.zoomScale,
                          borderScale: widget.borderScale,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled ? _showOverlay : null,
        child: Container(
          width:
              widget.showAsActionIcon
                  ? (_AppDropdownMenuConstants.defaultHeight * widget.zoomScale)
                  : widget.width,
          height:
              widget.height ??
              _AppDropdownMenuConstants.defaultHeight * widget.zoomScale,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: widget.borderColor,
              width: 1.5 * widget.borderScale,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal:
                _AppDropdownMenuConstants.horizontalPadding * widget.zoomScale,
            vertical:
                _AppDropdownMenuConstants.verticalPadding * widget.zoomScale,
          ),
          child:
              widget.showAsActionIcon
                  ? Align(
                    alignment: Alignment.center,
                    child: Icon(
                      widget.actionIcon ?? AppIcons.moreVert,
                      color: widget.textColor,
                      size: 20 * widget.zoomScale,
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start, // Changed from center to start
                    children: [
                      // Display leading icon of selected item
                      if (widget.selectedEntry?.leadingIcon != null) ...[
                        Padding(
                          padding: EdgeInsets.only(
                            top:
                                2.0 *
                                widget
                                    .zoomScale, // Changed from 4.0 → 2.0 (adjust up)
                          ),
                          child: widget.selectedEntry!.leadingIcon!,
                        ),
                        SizedBox(
                          width:
                              _AppDropdownMenuConstants.spacing *
                              widget.zoomScale,
                        ),
                      ],
                      Expanded(
                        child: AppText(
                          widget.selectedEntry?.label ?? widget.hintText ?? '',
                          variant: AppTextVariant.bodyText,
                          color:
                              widget.selectedEntry != null
                                  ? widget.textColor
                                  : widget.textColor.withValues(alpha: 0.6),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width:
                            _AppDropdownMenuConstants.spacing *
                            widget.zoomScale,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top:
                              2.0 *
                              widget
                                  .zoomScale, // Changed from 4.0 → 2.0 (adjust up)
                        ),
                        child: Icon(
                          AppIcons.chevronDown,
                          color: widget.textColor,
                          size:
                              _AppDropdownMenuConstants.chevronIconSize *
                              widget.zoomScale,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}

/// Overlay menu implementation
class _AppDropdownOverlay<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?> onSelected;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double buttonHeight;
  final T? selectedValue;
  final double overlayWidth;
  final AppDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final double borderScale;

  const _AppDropdownOverlay({
    super.key,
    required this.entries,
    required this.onSelected,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.textStyle,
    required this.buttonHeight,
    this.selectedValue,
    required this.overlayWidth,
    required this.alignment,
    required this.showCheckmark,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: overlayWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: 1.5 * borderScale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0 * zoomScale,
            offset: Offset(0, 4 * zoomScale),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            entries.map((entry) {
              return _AppDropdownMenuItem<T>(
                entry: entry,
                onSelected: onSelected,
                textColor: textColor,
                textStyle: textStyle,
                buttonHeight: buttonHeight,
                isSelected: entry.value == selectedValue,
                alignment: alignment,
                showCheckmark: showCheckmark,
                hoverBackgroundColor: hoverBackgroundColor,
                zoomScale: zoomScale,
              );
            }).toList(),
      ),
    );
  }
}

/// Dropdown menu item implementation
class _AppDropdownMenuItem<T> extends StatefulWidget {
  final DropdownMenuEntry<T> entry;
  final ValueChanged<T?> onSelected;
  final Color textColor;
  final TextStyle? textStyle;
  final double buttonHeight;
  final bool isSelected;
  final AppDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final Color hoverBackgroundColor;
  final double zoomScale;

  const _AppDropdownMenuItem({
    super.key,
    required this.entry,
    required this.onSelected,
    required this.textColor,
    this.textStyle,
    required this.buttonHeight,
    required this.isSelected,
    required this.alignment,
    required this.showCheckmark,
    required this.hoverBackgroundColor,
    required this.zoomScale,
  });

  @override
  State<_AppDropdownMenuItem<T>> createState() =>
      _AppDropdownMenuItemState<T>();
}

class _AppDropdownMenuItemState<T> extends State<_AppDropdownMenuItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onSelected(widget.entry.value),
        behavior: HitTestBehavior.opaque, // Make space outside label tappable
        child: Container(
          height: _AppDropdownMenuConstants.defaultHeight * widget.zoomScale,
          color: _isHovered ? widget.hoverBackgroundColor : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal:
                _AppDropdownMenuConstants.horizontalPadding * widget.zoomScale,
            vertical:
                _AppDropdownMenuConstants.verticalPadding * widget.zoomScale,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Changed from center to start
            children: [
              // Display checkbox space only if checkmark is enabled and alignment is not left
              if (widget.showCheckmark &&
                  widget.alignment != AppDropdownMenuAlignment.left) ...[
                // Space for checkbox
                SizedBox(
                  width:
                      _AppDropdownMenuConstants.checkboxSpaceWidth *
                      widget.zoomScale,
                  child:
                      widget.isSelected
                          ? Align(
                            alignment:
                                Alignment.topLeft, // Position checkmark at top
                            child: Padding(
                              padding: EdgeInsets.only(
                                top:
                                    4.0 *
                                    widget
                                        .zoomScale, // Changed from 2.0 → 4.0 (offset further down)
                              ),
                              child: Icon(
                                AppIcons.check,
                                color: widget.textColor,
                                size:
                                    _AppDropdownMenuConstants.checkIconSize *
                                    widget.zoomScale,
                              ),
                            ),
                          )
                          : null,
                ),
                SizedBox(
                  width: _AppDropdownMenuConstants.spacing * widget.zoomScale,
                ),
              ],
              if (widget.entry.leadingIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(
                    top:
                        2.0 *
                        widget
                            .zoomScale, // Changed from 4.0 → 2.0 (adjust slightly up)
                  ),
                  child: widget.entry.leadingIcon!,
                ),
                SizedBox(
                  width: _AppDropdownMenuConstants.spacing * widget.zoomScale,
                ),
              ],
              // Overlay menu width is adjusted to maximum menu item width,
              // so text truncation is not necessary, but use Flexible for safety
              Flexible(
                child:
                    widget.entry.labelWidget ??
                    AppText(
                      widget.entry.label,
                      variant: AppTextVariant.bodyText,
                      color: widget.textColor,
                      overflow:
                          TextOverflow
                              .ellipsis, // Changed from visible to ellipsis
                      maxLines: 1, // Explicitly limit to 1 line
                    ),
              ),
              if (widget.entry.trailingIcon != null) ...[
                SizedBox(
                  width: _AppDropdownMenuConstants.spacing * widget.zoomScale,
                ),
                widget.entry.trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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

import '../styling/app_border_radius.dart';
import '../icons/app_icons.dart';
import '../widgets/app_icon_button.dart';

/// A class representing an item in a popup menu.
class AppPopupMenuItem<T> {
  const AppPopupMenuItem({
    required this.value,
    required this.title,
    this.icon,
    this.enabled = true,
    this.onSelected,
  });

  final T value;
  final String title;
  final IconData? icon;
  final bool enabled;
  final VoidCallback? onSelected;
}

/// A class representing a divider in a popup menu.
class AppPopupMenuDivider {
  const AppPopupMenuDivider();
}

/// An entry in a popup menu (item or divider).
abstract class AppPopupMenuEntry<T> {
  const AppPopupMenuEntry();
}

class AppPopupMenuItemEntry<T> extends AppPopupMenuEntry<T> {
  const AppPopupMenuItemEntry(this.item);
  final AppPopupMenuItem<T> item;
}

class AppPopupMenuDividerEntry<T> extends AppPopupMenuEntry<T> {
  const AppPopupMenuDividerEntry();
}

/// A popup menu compliant with the App design system.
class AppPopupMenu<T> extends ConsumerWidget {
  const AppPopupMenu({
    super.key,
    required this.child,
    required this.items,
    this.tooltip,
    this.enabled = true,
    this.disableZoom = false,
    this.onOpenStateChanged,
    this.overlayBackgroundColor,
    this.menuOpenBackgroundColor,
  });

  /// Factory constructor for action icon buttons.
  AppPopupMenu.actionIcon({
    super.key,
    required this.items,
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    this.tooltip,
    this.enabled = true,
    this.disableZoom = false,
    this.onOpenStateChanged,
    this.overlayBackgroundColor,
    this.menuOpenBackgroundColor,
  }) : child = AppIconButton.circle(
         icon: icon ?? AppIcons.ellipsis,
         iconSize: iconSize ?? 16,
         iconColor: iconColor,
         tooltip: null, // Disable tooltip (managed by AppPopupMenu)
       );

  /// Factory constructor for a circular action button with hover effect.
  AppPopupMenu.circleActionButton({
    super.key,
    required this.items,
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    Color? backgroundColor,
    Color? hoverColor,
    double? size,
    this.tooltip,
    this.enabled = true,
    this.disableZoom = false,
    this.onOpenStateChanged,
    this.overlayBackgroundColor,
    this.menuOpenBackgroundColor,
  }) : child = _CircleActionButton(
         icon: icon ?? AppIcons.ellipsis,
         iconSize: iconSize ?? 16,
         iconColor: iconColor,
         backgroundColor: backgroundColor,
         hoverColor: hoverColor,
         menuOpenBackgroundColor: menuOpenBackgroundColor,
         size: size ?? 32,
       );

  final Widget child;
  final List<AppPopupMenuEntry<T>> items;
  final String? tooltip;
  final bool enabled;
  final bool disableZoom;
  final ValueChanged<bool>? onOpenStateChanged;
  final Color? overlayBackgroundColor;
  final Color? menuOpenBackgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return _AppPopupMenuButton<T>(
      items: items,
      enabled: enabled,
      tooltip: tooltip,
      colorScheme: colorScheme,
      zoomScale: zoomScale,
      onOpenStateChanged: onOpenStateChanged,
      overlayBackgroundColor: overlayBackgroundColor,
      menuOpenBackgroundColor: menuOpenBackgroundColor,
      child: child,
    );
  }
}

/// Implementation of the popup menu button.
class _AppPopupMenuButton<T> extends StatefulWidget {
  const _AppPopupMenuButton({
    required this.items,
    required this.enabled,
    required this.tooltip,
    required this.colorScheme,
    required this.zoomScale,
    required this.child,
    this.onOpenStateChanged,
    this.overlayBackgroundColor,
    this.menuOpenBackgroundColor,
  });

  final List<AppPopupMenuEntry<T>> items;
  final bool enabled;
  final String? tooltip;
  final AppColorScheme colorScheme;
  final double zoomScale;
  final Widget child;
  final ValueChanged<bool>? onOpenStateChanged;
  final Color? overlayBackgroundColor;
  final Color? menuOpenBackgroundColor;

  @override
  State<_AppPopupMenuButton<T>> createState() => _AppPopupMenuButtonState<T>();
}

class _AppPopupMenuButtonState<T> extends State<_AppPopupMenuButton<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void dispose() {
    // On dispose, remove only the overlay without calling setState
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _removeOverlay() {
    widget.onOpenStateChanged?.call(false);
    _overlayEntry?.remove();
    _overlayEntry = null;

    // Call setState only if mounted and _isOpen is true
    if (mounted && _isOpen) {
      setState(() {
        _isOpen = false;
      });
    } else {
      // If not mounted, update only the state
      _isOpen = false;
    }
  }

  void _showOverlay() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }

    widget.onOpenStateChanged?.call(true);
    // Use a slightly longer delay to more reliably separate tap events
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted && !_isOpen) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        if (mounted) {
          setState(() {
            _isOpen = true;
          });
        }
      }
    });
  }

  /// Dynamically calculates the width of the menu.
  double _calculateMenuWidth() {
    double maxWidth = 120.0; // Minimum width

    for (final entry in widget.items) {
      if (entry is AppPopupMenuItemEntry<T>) {
        final item = entry.item;

        // Calculate text width
        final textPainter = TextPainter(
          text: TextSpan(
            text: item.title,
            style: TextStyle(
              fontSize: 14.0 * widget.zoomScale,
              fontWeight: FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Icon + padding + text + padding
        double itemWidth = 16.0 * widget.zoomScale; // Left padding
        if (item.icon != null) {
          itemWidth += 16.0 * widget.zoomScale; // Icon size
          itemWidth += 8.0 * widget.zoomScale; // Spacing between icon and text
        }
        itemWidth += textPainter.size.width; // Text width
        itemWidth += 16.0 * widget.zoomScale; // Right padding

        maxWidth = maxWidth > itemWidth ? maxWidth : itemWidth;
      }
    }

    // Max width limit (up to 50% of screen width)
    final screenWidth = MediaQuery.of(context).size.width;
    return (maxWidth + 16.0 * widget.zoomScale).clamp(120.0, screenWidth * 0.5);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Calculate menu height
    double menuHeight = 4;
    for (final entry in widget.items) {
      if (entry is AppPopupMenuItemEntry<T>) {
        menuHeight += 32.0 * widget.zoomScale; // Item height
      } else if (entry is AppPopupMenuDividerEntry<T>) {
        menuHeight +=
            (1.0 + 8.0) * widget.zoomScale; // Divider height + vertical margin
      }
    }
    menuHeight += 8.0 * widget.zoomScale; // Padding

    // Dynamically calculate menu width
    final menuWidth = _calculateMenuWidth();

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: () {
              // Remove overlay
              if (mounted) {
                _removeOverlay();
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned.fill(child: Container(color: Colors.transparent)),
                Positioned(
                  width: menuWidth, // Dynamically calculated menu width
                  height: menuHeight,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(
                      -(menuWidth - size.width), // Align to right edge
                      size.height +
                          4.0 * widget.zoomScale, // Display below the button
                    ),
                    child: GestureDetector(
                      onTap:
                          () {}, // Do not propagate taps within the menu to the parent
                      behavior: HitTestBehavior.opaque,
                      child: Material(
                        color: Colors.transparent,
                        child: _AppPopupMenuOverlay<T>(
                          items: widget.items,
                          colorScheme: widget.colorScheme,
                          zoomScale: widget.zoomScale,
                          onItemSelected: (item) {
                            item.onSelected?.call();
                            if (mounted) {
                              _removeOverlay();
                            }
                          },
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
    Widget childWidget = widget.child;

    // _CircleActionButtonの場合、メニューの開閉状態を反映
    if (widget.child is _CircleActionButton) {
      final originalButton = widget.child as _CircleActionButton;
      childWidget = _CircleActionButton(
        icon: originalButton.icon,
        iconSize: originalButton.iconSize,
        iconColor: originalButton.iconColor,
        backgroundColor: originalButton.backgroundColor,
        hoverColor: originalButton.hoverColor,
        isMenuOpen: _isOpen,
        menuOpenBackgroundColor: originalButton.menuOpenBackgroundColor,
        size: originalButton.size,
      );
    }

    Widget button = CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled ? _showOverlay : null,
        child: childWidget,
      ),
    );

    // Only show tooltip when the menu is closed
    if (widget.tooltip != null && !_isOpen) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}

/// Implementation of the popup menu overlay.
class _AppPopupMenuOverlay<T> extends StatelessWidget {
  const _AppPopupMenuOverlay({
    required this.items,
    required this.colorScheme,
    required this.zoomScale,
    required this.onItemSelected,
  });

  final List<AppPopupMenuEntry<T>> items;
  final AppColorScheme colorScheme;
  final double zoomScale;
  final void Function(AppPopupMenuItem<T> item) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.base.background,
        borderRadius: BorderRadius.circular(AppBorderRadiusValues.small),
        border: Border.all(color: colorScheme.base.border, width: 1.0),
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
        children: [
          AppSpacing(height: 4),
          ...items.map((entry) {
            if (entry is AppPopupMenuItemEntry<T>) {
              return _AppPopupMenuItemWidget<T>(
                item: entry.item,
                colorScheme: colorScheme,
                zoomScale: zoomScale,
                onSelected: () => onItemSelected(entry.item),
              );
            } else if (entry is AppPopupMenuDividerEntry<T>) {
              return _AppPopupMenuDividerWidget(
                colorScheme: colorScheme,
                zoomScale: zoomScale,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

/// Popup menu item widget.
class _AppPopupMenuItemWidget<T> extends StatefulWidget {
  const _AppPopupMenuItemWidget({
    required this.item,
    required this.colorScheme,
    required this.zoomScale,
    required this.onSelected,
  });

  final AppPopupMenuItem<T> item;
  final AppColorScheme colorScheme;
  final double zoomScale;
  final VoidCallback onSelected;

  @override
  State<_AppPopupMenuItemWidget<T>> createState() =>
      _AppPopupMenuItemWidgetState<T>();
}

class _AppPopupMenuItemWidgetState<T>
    extends State<_AppPopupMenuItemWidget<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.item.enabled ? widget.onSelected : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 32.0 * widget.zoomScale,
          color:
              _isHovered && widget.item.enabled
                  ? widget.colorScheme.interactive.list.itemBackground.hover
                  : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: 12.0 * widget.zoomScale,
            vertical: 8.0 * widget.zoomScale,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 16.0 * widget.zoomScale,
                  color:
                      widget.item.enabled
                          ? widget.colorScheme.base.foreground
                          : widget.colorScheme.base.foreground.withValues(
                            alpha: 0.5,
                          ),
                ),
                SizedBox(width: 8.0 * widget.zoomScale),
              ],
              Expanded(
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    fontSize: 14.0 * widget.zoomScale,
                    color:
                        widget.item.enabled
                            ? widget.colorScheme.base.foreground
                            : widget.colorScheme.base.foreground.withValues(
                              alpha: 0.5,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Popup menu divider widget.
class _AppPopupMenuDividerWidget extends StatelessWidget {
  const _AppPopupMenuDividerWidget({
    required this.colorScheme,
    required this.zoomScale,
  });

  final AppColorScheme colorScheme;
  final double zoomScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0 * zoomScale,
      margin: EdgeInsets.symmetric(vertical: 4.0 * zoomScale),
      color: colorScheme.base.border,
    );
  }
}

/// Circular action button widget with hover effect.
class _CircleActionButton extends ConsumerStatefulWidget {
  const _CircleActionButton({
    required this.icon,
    required this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.isMenuOpen = false,
    this.menuOpenBackgroundColor,
    required this.size,
  });

  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? hoverColor;
  final bool isMenuOpen;
  final Color? menuOpenBackgroundColor;
  final double size;

  @override
  ConsumerState<_CircleActionButton> createState() =>
      _CircleActionButtonState();
}

class _CircleActionButtonState extends ConsumerState<_CircleActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    // Determine default background and hover colors
    final defaultBackgroundColor =
        widget.backgroundColor ??
        colorScheme.interactive.actionButton.background;
    final defaultHoverColor =
        widget.hoverColor ?? defaultBackgroundColor.withValues(alpha: 0.8);
    final menuOpenBackgroundColor =
        widget.menuOpenBackgroundColor ?? defaultHoverColor;

    // Background color priority: menu open > hover > default
    Color currentBackgroundColor;
    if (widget.isMenuOpen) {
      currentBackgroundColor = menuOpenBackgroundColor;
    } else if (_isHovered) {
      currentBackgroundColor = defaultHoverColor;
    } else {
      currentBackgroundColor = defaultBackgroundColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentBackgroundColor,
        ),
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color:
              widget.iconColor ??
              colorScheme.interactive.actionButton.iconColor,
        ),
      ),
    );
  }
}

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
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:presentation_components/src/widgets/app_icon.dart';
import 'app_container.dart';
import 'app_rectangle_border.dart';

/// Enum to specify the icon position of ExpansionTile.
enum ExpansionIconPosition {
  /// Displays the icon on the left side (start).
  leading,

  /// Displays the icon on the right side (end).
  trailing,
}

/// ExpansionTile with App application standard styles applied.
///
/// By default, the icon is positioned on the left.
/// Animations are disabled, and the state switches instantly.
/// Background color, borders, and icon position are customizable.
class AppExpansionTile extends ConsumerStatefulWidget {
  const AppExpansionTile({
    super.key,
    required this.title,
    this.children = const <Widget>[],
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.shape,
    this.collapsedShape,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.childrenPadding,
    this.tilePadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.controller,
    this.animationDuration =
        Duration.zero, // Animation disabled per design guidelines
    this.iconPosition = ExpansionIconPosition.leading, // New parameter
    this.disableZoom = false,
  });

  /// Title widget. Typically an [AppText] widget.
  final Widget title;

  /// List of widgets displayed when the tile is expanded.
  final List<Widget> children;

  /// Background color of the tile when expanded.
  final Color? backgroundColor;

  /// Background color of the tile when collapsed.
  final Color? collapsedBackgroundColor;

  /// Border of the tile when expanded.
  final ShapeBorder? shape;

  /// Border of the tile when collapsed.
  final ShapeBorder? collapsedShape;

  /// Whether the tile is initially expanded.
  final bool initiallyExpanded;

  /// Callback invoked when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Padding applied to [children]. Uses theme's default if not specified.
  final EdgeInsetsGeometry? childrenPadding;

  /// Padding applied to the title. Uses default value if not specified.
  final EdgeInsetsGeometry? tilePadding;

  final ExpansibleController? controller;

  final Duration
  animationDuration; // Animation disabled - kept for API compatibility

  /// Icon position (leading or trailing). Default is leading.
  final ExpansionIconPosition iconPosition; // New parameter

  /// Whether to disable zoom functionality
  final bool disableZoom;

  @override
  ConsumerState<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends ConsumerState<AppExpansionTile> {
  // Animation removed per design guidelines - Design Principle #6: Animation Prohibition
  bool _isExpanded = false;
  // ExpansionTileController? _internalController; // Not needed if passed directly

  @override
  void initState() {
    super.initState();
    // Set initial state from widget.initiallyExpanded
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read state from PageStorage after context becomes available
    final bool? storedExpanded =
        PageStorage.maybeOf(context)?.readState(context) as bool?;
    if (storedExpanded != null && storedExpanded != _isExpanded) {
      setState(() {
        _isExpanded = storedExpanded;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(AppExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animation duration changes ignored - animations are disabled

    // Handle controller changes
    if (widget.controller != oldWidget.controller) {
      // If a new controller is provided
      if (widget.controller != null) {
        try {
          // Safely check controller state
          final isControllerExpanded = widget.controller!.isExpanded;
          if (isControllerExpanded != _isExpanded) {
            _updateExpansionState(isControllerExpanded);
          }
        } catch (e) {
          // Ignore if controller is not yet initialized
        }
      }
    }
    // If no controller, reflect changes in initiallyExpanded
    else if (widget.controller == null &&
        widget.initiallyExpanded != oldWidget.initiallyExpanded) {
      _updateExpansionState(widget.initiallyExpanded);
    }
  }

  // This function now only updates the internal state and calls the callback
  void _handleExpansionStateChange(bool expanded) {
    _updateExpansionState(expanded);
    widget.onExpansionChanged?.call(_isExpanded); // Call the external callback
  }

  void _updateExpansionState(bool expanded) {
    if (_isExpanded != expanded) {
      setState(() {
        _isExpanded = expanded;
        PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // Get accessibility config for zoom scaling
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        final zoomScale =
            widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;

        return _buildTile(context, accessibilityConfig, zoomScale);
      },
    );
  }

  Widget _buildTile(
    BuildContext context,
    AppAccessibilityConfig accessibilityConfig,
    double zoomScale,
  ) {
    // Define the static icon widget - no animation per design guidelines
    final Widget iconWidget = AppIcon(
      _isExpanded ? LucideIcons.chevronDown200 : LucideIcons.chevronRight200,
      size: AppIconSize.small,
    );

    // Header using AppContainer
    Widget header;
    if (widget.iconPosition == ExpansionIconPosition.leading) {
      // Position icon on the left
      header = GestureDetector(
        onTap: () => _handleExpansionStateChange(!_isExpanded),
        behavior: HitTestBehavior.opaque,
        child: AppContainer(
          leadingWidget: iconWidget,
          padding: widget.tilePadding,
          disableZoom: widget.disableZoom,
          child: widget.title,
        ),
      );
    } else {
      // TODO: Fix similarly to the left side
      // Position icon on the right
      header = AppContainer(
        padding: widget.tilePadding,
        disableZoom: widget.disableZoom,
        child: GestureDetector(
          onTap: () => _handleExpansionStateChange(!_isExpanded),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(child: widget.title),
              Padding(
                padding: EdgeInsets.only(left: 8.0 * zoomScale),
                child: iconWidget,
              ),
            ],
          ),
        ),
      );
    }

    // Apply background color and border
    if (widget.backgroundColor != null ||
        widget.shape != null ||
        widget.collapsedBackgroundColor != null ||
        widget.collapsedShape != null) {
      header = Container(
        decoration: ShapeDecoration(
          color:
              _isExpanded
                  ? widget.backgroundColor
                  : widget.collapsedBackgroundColor,
          shape:
              _isExpanded
                  ? (widget.shape ?? ref.watch(appRectangleBorderProvider))
                  : (widget.collapsedShape ??
                      ref.watch(appRectangleBorderProvider)),
        ),
        child: header,
      );
    }

    // Padding for child widgets
    final effectiveChildrenPadding =
        widget.childrenPadding ??
        EdgeInsets.only(
          left: AppContainer.defaultHorizontalPadding * zoomScale,
          top: 8.0 * zoomScale,
        );

    // ExpansionTileController support
    if (widget.controller != null) {
      try {
        // Synchronize controller state with internal state
        // An exception may occur when accessing isExpanded if the controller is not initialized
        final isControllerExpanded = widget.controller!.isExpanded;
        if (isControllerExpanded != _isExpanded) {
          _updateExpansionState(isControllerExpanded);
        }
      } catch (e) {
        // Ignore error if controller is not yet initialized
        // In this case, use internal state
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        // Direct conditional rendering - no animation per design guidelines
        if (_isExpanded)
          Padding(
            padding: effectiveChildrenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
      ],
    );
  }
}

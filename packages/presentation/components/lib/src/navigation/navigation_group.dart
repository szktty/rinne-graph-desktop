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
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import '../id/uuid_generator.dart';
import '../icons/app_icons.dart';

/// A collapsible group of navigation items.
class NavigationGroup extends ConsumerStatefulWidget {
  /// The unique identifier for the widget.
  final UniqueId id;

  /// The title of the group.
  final String title;

  /// The child widgets of the group.
  final List<Widget> children;

  /// The icon for the group.
  final Widget? icon;

  /// Whether to expand initially.
  final bool initiallyExpanded;

  /// Whether it is currently expanded (for external control).
  final bool isExpanded;

  /// Callback for when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The background color.
  final Color? backgroundColor;

  /// An additional widget to display on the right.
  final Widget? trailing;

  /// The expansion icon.
  final Widget? expansionIcon;

  /// The size of the indent for child items.
  final double childrenIndent;

  /// The duration of the animation (Note: always Duration.zero due to Design Principle #6).
  final Duration animationDuration;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [NavigationGroup].
  ///
  /// [id] - The unique identifier for the group.
  /// [title] - The title to display.
  /// [children] - The child widgets of the group.
  /// [icon] - The icon for the group.
  /// [initiallyExpanded] - Whether to expand initially.
  /// [isExpanded] - Whether it is currently expanded (for external control).
  /// [onExpansionChanged] - Callback for when the expansion state changes.
  /// [titleStyle] - The text style for the title.
  /// [backgroundColor] - The background color.
  /// [trailing] - An additional widget to display on the right.
  /// [expansionIcon] - A custom expansion icon.
  /// [childrenIndent] - The size of the indent for child items.
  /// [animationDuration] - The duration of the animation.
  const NavigationGroup({
    required this.id,
    required this.title,
    required this.children,
    this.icon,
    this.initiallyExpanded = false,
    this.isExpanded = false,
    this.onExpansionChanged,
    this.titleStyle,
    this.backgroundColor,
    this.trailing,
    this.expansionIcon,
    this.childrenIndent = 24.0,
    this.animationDuration = Duration.zero,
    this.disableZoom = false,
    super.key,
  });

  /// A convenient constructor for creating a [NavigationGroup] using a string ID.
  ///
  /// [idString] - The string to use as the group's ID.
  /// Other parameters are the same as the normal constructor.
  factory NavigationGroup.withStringId({
    required String idString,
    required String title,
    required List<Widget> children,
    Widget? icon,
    bool initiallyExpanded = false,
    bool isExpanded = false,
    ValueChanged<bool>? onExpansionChanged,
    TextStyle? titleStyle,
    Color? backgroundColor,
    Widget? trailing,
    Widget? expansionIcon,
    double childrenIndent = 24.0,
    Duration animationDuration = Duration.zero,
    Key? key,
  }) {
    return NavigationGroup(
      id: UuidGenerator.fromString(idString),
      title: title,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
      isExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      titleStyle: titleStyle,
      backgroundColor: backgroundColor,
      trailing: trailing,
      expansionIcon: expansionIcon,
      childrenIndent: childrenIndent,
      animationDuration: Duration.zero,
      disableZoom: false,
      key: key,
      children: children,
    );
  }

  /// A convenient constructor for creating a [NavigationGroup] with a new random ID.
  ///
  /// Other parameters are the same as the normal constructor.
  factory NavigationGroup.withNewId({
    required String title,
    required List<Widget> children,
    Widget? icon,
    bool initiallyExpanded = false,
    bool isExpanded = false,
    ValueChanged<bool>? onExpansionChanged,
    TextStyle? titleStyle,
    Color? backgroundColor,
    Widget? trailing,
    Widget? expansionIcon,
    double childrenIndent = 24.0,
    Duration animationDuration = Duration.zero,
    Key? key,
  }) {
    return NavigationGroup(
      id: UuidGenerator().generate(),
      title: title,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
      isExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      titleStyle: titleStyle,
      backgroundColor: backgroundColor,
      trailing: trailing,
      expansionIcon: expansionIcon,
      childrenIndent: childrenIndent,
      animationDuration: Duration.zero,
      disableZoom: false,
      key: key,
      children: children,
    );
  }

  @override
  ConsumerState<NavigationGroup> createState() => _NavigationGroupState();
}

class _NavigationGroupState extends ConsumerState<NavigationGroup> {
  late bool _isExpandedState;

  @override
  void initState() {
    super.initState();
    _isExpandedState = widget.initiallyExpanded || widget.isExpanded;
  }

  @override
  void didUpdateWidget(NavigationGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the expansion state is changed from the outside, reflect it.
    if (widget.isExpanded != _isExpandedState) {
      setState(() {
        _isExpandedState = widget.isExpanded;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Icon rotation (no animation, direct state change)
    final iconRotation = _isExpandedState ? 0.25 : 0.0;

    // Height factor (no animation, direct state change)
    final heightFactor = _isExpandedState ? 1.0 : 0.0;

    final theme = Theme.of(context);
    final effectiveBackgroundColor = widget.backgroundColor;
    final effectiveTitleStyle =
        widget.titleStyle ??
        theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500);

    // Custom expansion icon or default expansion icon (no animation)
    Widget getExpansionIcon() {
      if (widget.expansionIcon != null) {
        return Transform.rotate(
          angle: iconRotation * 1.5708, // 90 degrees = π/2 radians
          child: widget.expansionIcon!,
        );
      } else {
        return Transform.rotate(
          angle: iconRotation * 1.5708, // 90 degrees = π/2 radians
          child: Icon(AppIcons.arrowRight, size: 18 * zoomScale),
        );
      }
    }

    // Header part
    final header = Material(
      color: effectiveBackgroundColor,
      child: InkWell(
        onTap: () {
          final newExpandedState = !_isExpandedState;
          setState(() {
            _isExpandedState = newExpandedState;
          });
          widget.onExpansionChanged?.call(newExpandedState);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * zoomScale,
            vertical: 8 * zoomScale,
          ),
          child: Row(
            children: [
              // Place the expansion icon on the left
              Padding(
                padding: EdgeInsets.only(right: 8 * zoomScale),
                child: getExpansionIcon(),
              ),
              if (widget.icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 12 * zoomScale),
                  child: widget.icon,
                ),
              Expanded(child: Text(widget.title, style: effectiveTitleStyle)),
              // Place the trailing widget on the right (if it exists)
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );

    // Indented child widgets
    final indentedChildren =
        widget.children.map((child) {
          return Padding(
            padding: EdgeInsets.only(left: widget.childrenIndent * zoomScale),
            child: child,
          );
        }).toList();

    // The part containing the child elements
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        if (_isExpandedState)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: indentedChildren,
          ),
      ],
    );
  }
}

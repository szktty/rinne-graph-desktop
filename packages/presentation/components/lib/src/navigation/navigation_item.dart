import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'identifiable_navigation_item.dart';
import '../id/uuid_generator.dart';

/// A widget that displays a single navigation item.
class NavigationItem extends IdentifiableNavigationItem {
  /// The title of the item.
  final String title;

  /// The widget to display at the beginning (e.g., an icon).
  final Widget? leading;

  /// The widget to display at the end (e.g., a badge or action button).
  final Widget? trailing;

  /// Callback for when a tap occurs.
  final VoidCallback? onTap;

  /// The selection state.
  final bool isSelected;

  /// The padding.
  final EdgeInsets padding;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The background color.
  final Color? backgroundColor;

  /// The background color when selected.
  final Color? selectedBackgroundColor;

  /// The indent on the left side.
  final double indent;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [NavigationItem].
  ///
  /// [id] - The unique identifier for the item.
  /// [title] - The title to display.
  /// [leading] - The widget to display at the beginning.
  /// [trailing] - The widget to display at the end.
  /// [onTap] - Callback for when a tap occurs.
  /// [isSelected] - The selection state.
  /// [padding] - The padding.
  /// [titleStyle] - The text style for the title.
  /// [backgroundColor] - The background color.
  /// [selectedBackgroundColor] - The background color when selected.
  /// [indent] - The indent on the left side.
  const NavigationItem({
    required super.id,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.titleStyle,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.indent = 0,
    this.disableZoom = false,
    super.key,
  });

  /// A convenient constructor for creating a [NavigationItem] using a string ID.
  ///
  /// [idString] - The string to use as the item's ID.
  /// Other parameters are the same as the normal constructor.
  factory NavigationItem.withStringId({
    required String idString,
    required String title,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool isSelected = false,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    TextStyle? titleStyle,
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    double indent = 0,
    Key? key,
  }) {
    return NavigationItem(
      id: UuidGenerator.fromString(idString),
      title: title,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      isSelected: isSelected,
      padding: padding,
      titleStyle: titleStyle,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      indent: indent,
      disableZoom: false,
      key: key,
    );
  }

  /// A convenient constructor for creating a [NavigationItem] with a new random ID.
  ///
  /// Other parameters are the same as the normal constructor.
  factory NavigationItem.withNewId({
    required String title,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool isSelected = false,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    TextStyle? titleStyle,
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    double indent = 0,
    Key? key,
  }) {
    return NavigationItem(
      id: UuidGenerator().generate(),
      title: title,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      isSelected: isSelected,
      padding: padding,
      titleStyle: titleStyle,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      indent: indent,
      disableZoom: false,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Get the color scope (use the sidebar scope or the default)
    final colorScope = ref.watch(sideBarColorScopeProvider);

    // Get the text theme
    final themeData = ref.watch(effectiveThemeDataProvider);

    final effectiveBackgroundColor =
        isSelected
            ? selectedBackgroundColor ?? colorScope.selection
            : backgroundColor;

    final effectiveTitleStyle =
        titleStyle ??
        (isSelected
            ? themeData.textTheme.bodyLarge?.copyWith(
              color: colorScope.accent,
              fontWeight: FontWeight.w500,
            )
            : themeData.textTheme.bodyLarge?.copyWith(color: colorScope.text));

    Widget content = Container(
      padding: padding * zoomScale,
      child: Row(
        children: [
          if (leading != null)
            Padding(
              padding: EdgeInsets.only(right: 12 * zoomScale),
              child: leading,
            ),
          Expanded(
            child: Text(
              title,
              style: effectiveTitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    // Apply if indent is specified
    if (indent > 0) {
      content = Padding(
        padding: EdgeInsets.only(left: indent * zoomScale),
        child: content,
      );
    }

    return Material(
      color: effectiveBackgroundColor,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}

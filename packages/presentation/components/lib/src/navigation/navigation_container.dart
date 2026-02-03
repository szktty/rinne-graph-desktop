import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_themes/core_themes.dart';
import 'navigation_item.dart';
import 'navigation_group.dart';

/// A container for navigation items.
///
/// This widget functions as a container for navigation items, and manages a
/// scrollable area.
class NavigationContainer extends ConsumerWidget {
  /// A list of navigation items.
  final List<Widget> children;

  /// The padding of the container.
  final EdgeInsets padding;

  /// The background color.
  final Color? backgroundColor;

  /// The scroll physics.
  final ScrollPhysics? physics;

  /// Whether to size the scroll area to the size of its children.
  final bool shrinkWrap;

  /// The ID of the selected item.
  final UniqueId? selectedItemId;

  /// The ID of the expanded group.
  final List<UniqueId> expandedGroupIds;

  /// Callback for when an item is selected.
  final void Function(UniqueId)? onItemSelected;

  /// Callback for when a group is expanded/collapsed.
  final void Function(UniqueId)? onGroupToggled;

  /// The default indent for child elements.
  final double defaultIndent;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a [NavigationContainer].
  ///
  /// [children] - A list of navigation items.
  /// [padding] - The padding of the container.
  /// [backgroundColor] - The background color.
  /// [physics] - The scroll physics.
  /// [shrinkWrap] - Whether to size the scroll area to the size of its children.
  /// [selectedItemId] - The ID of the selected item.
  /// [expandedGroupIds] - A list of IDs of expanded groups.
  /// [onItemSelected] - Callback for when an item is selected.
  /// [onGroupToggled] - Callback for when a group is expanded.
  /// [defaultIndent] - The default indent for child elements.
  const NavigationContainer({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.physics,
    this.shrinkWrap = false,
    this.selectedItemId,
    this.expandedGroupIds = const [],
    this.onItemSelected,
    this.onGroupToggled,
    this.defaultIndent = 24.0,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: padding * zoomScale,
        physics: physics,
        shrinkWrap: shrinkWrap,
        children: _processChildren(children, zoomScale),
      ),
    );
  }

  /// Process child widgets to apply selection and expansion states.
  List<Widget> _processChildren(List<Widget> items, double zoomScale) {
    return items.map((child) {
      if (child is NavigationItem) {
        return _processNavigationItem(child, zoomScale);
      } else if (child is NavigationGroup) {
        return _processNavigationGroup(child, zoomScale);
      } else {
        return child; // Return NavigationDivider, etc. as is.
      }
    }).toList();
  }

  /// Process NavigationItem.
  Widget _processNavigationItem(NavigationItem item, double zoomScale) {
    final isSelected = selectedItemId != null && item.id == selectedItemId;
    final indent = (item.indent > 0 ? item.indent : defaultIndent) * zoomScale;

    return NavigationItem(
      id: item.id,
      title: item.title,
      leading: item.leading,
      trailing: item.trailing,
      isSelected: isSelected,
      onTap: () {
        onItemSelected?.call(item.id);
        item.onTap?.call();
      },
      padding: item.padding,
      titleStyle: item.titleStyle,
      backgroundColor: item.backgroundColor,
      selectedBackgroundColor: item.selectedBackgroundColor,
      indent: indent,
      disableZoom: disableZoom,
    );
  }

  /// Process NavigationGroup.
  Widget _processNavigationGroup(NavigationGroup group, double zoomScale) {
    final isExpanded = expandedGroupIds.contains(group.id);

    return NavigationGroup(
      id: group.id,
      title: group.title,
      icon: group.icon,
      isExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        onGroupToggled?.call(group.id);
        group.onExpansionChanged?.call(expanded);
      },
      titleStyle: group.titleStyle,
      backgroundColor: group.backgroundColor,
      trailing: group.trailing,
      expansionIcon: group.expansionIcon,
      childrenIndent: group.childrenIndent,
      disableZoom: disableZoom,
      children: _processChildren(group.children, zoomScale),
    );
  }
}

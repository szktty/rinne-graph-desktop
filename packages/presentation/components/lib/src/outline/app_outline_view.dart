import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../icons/app_icons.dart';
import '../typography/app_text.dart';
import 'app_outline_item.dart';

/// An outline view with standard App application styling.
///
/// Provides hierarchical outline display and manages the tree structure of expandable items.
class AppOutlineView<T> extends ConsumerWidget {
  const AppOutlineView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.childrenBuilder,
    this.selectedItem,
    this.onItemTap,
    this.onExpansionChanged,
    this.expandedItems = const {},
    this.emptyBuilder,
    this.headerBuilder,
    this.backgroundColor,
    this.padding,
    this.scrollController,
    this.physics,
    this.disableZoom = false,
  });

  /// The list of items to display.
  final List<T> items;

  /// The builder function for each item.
  final Widget Function(
    T item,
    bool isSelected,
    bool isExpanded,
    bool hasChildren,
    int depth,
  )
  itemBuilder;

  /// Function to get child elements of each item.
  final List<T> Function(T item) childrenBuilder;

  /// The currently selected item.
  final T? selectedItem;

  /// Callback when an item is tapped.
  final ValueChanged<T>? onItemTap;

  /// Callback when the expansion state changes.
  final ValueChanged<T>? onExpansionChanged;

  /// The set of expanded items.
  final Set<T> expandedItems;

  /// Builder for the widget to display when items are empty.
  final Widget Function()? emptyBuilder;

  /// Builder for the header widget.
  final Widget Function()? headerBuilder;

  /// Background color.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Scroll controller.
  final ScrollController? scrollController;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final effectiveBackgroundColor =
        backgroundColor ?? appColorScheme.base.background;

    if (items.isEmpty) {
      return Container(
        color: effectiveBackgroundColor,
        child:
            emptyBuilder?.call() ??
            _buildDefaultEmptyWidget(appColorScheme, zoomScale),
      );
    }

    return Container(
      color: effectiveBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          if (headerBuilder != null) headerBuilder!(),

          // Outline content
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: physics,
              padding: (padding ?? const EdgeInsets.all(8.0)) * zoomScale,
              children: _buildOutlineItems(items, 0, <T>{}),
            ),
          ),
        ],
      ),
    );
  }

  /// Recursively builds outline items.
  List<Widget> _buildOutlineItems(
    List<T> items,
    int depth,
    Set<T> visitedItems,
  ) {
    final widgets = <Widget>[];

    for (final item in items) {
      // Prevent circular references
      if (visitedItems.contains(item)) {
        continue;
      }

      final children = childrenBuilder(item);
      final hasChildren = children.isNotEmpty;
      final isExpanded = expandedItems.contains(item);
      final isSelected = selectedItem == item;

      // Create a new set of visited items (add current item)
      final newVisitedItems = Set<T>.from(visitedItems)..add(item);

      widgets.add(
        AppOutlineItem(
          title: itemBuilder(item, isSelected, isExpanded, hasChildren, depth),
          isExpanded: isExpanded,
          isSelected: isSelected,
          hasChildren: hasChildren,
          depth: depth,
          onTap: () => onItemTap?.call(item),
          onExpansionChanged:
              hasChildren ? (expanded) => onExpansionChanged?.call(item) : null,
          disableZoom: disableZoom,
          children:
              isExpanded && hasChildren
                  ? _buildOutlineItems(children, depth + 1, newVisitedItems)
                  : [],
        ),
      );
    }

    return widgets;
  }

  /// Builds the default empty state widget.
  Widget _buildDefaultEmptyWidget(
    AppColorScheme appColorScheme,
    double zoomScale,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.listTree,
            size: 64 * zoomScale,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText.withValues(
              alpha: 0.5,
            ),
          ),
          SizedBox(height: 16 * zoomScale),
          AppText(
            'Outline',
            variant: AppTextVariant.sectionTitle,
            color: appColorScheme.uiAreas.sideBar.activeItemText,
          ),
          SizedBox(height: 8 * zoomScale),
          AppText(
            'No data available',
            variant: AppTextVariant.bodyText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
        ],
      ),
    );
  }
}

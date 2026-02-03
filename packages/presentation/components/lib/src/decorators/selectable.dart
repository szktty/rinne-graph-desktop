import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../styling/app_border_radius.dart';

/// Decorator for managing selection state.
///
/// Wraps widgets like AppCard to provide style changes according to the
/// selection state. By adopting the decorator pattern, selection functionality
/// is separated from other components, improving reusability.
///
/// Usage example:
/// ```dart
/// Selectable(
///   isSelected: true,
///   child: AppCard(
///     child: Text('Selectable Card'),
///   ),
/// )
/// ```
class Selectable extends ConsumerWidget {
  /// The child widget.
  final Widget child;

  /// The selection state.
  final bool isSelected;

  /// Background color when selected (automatically obtained from the theme if null).
  final Color? selectedBackgroundColor;

  /// Border color when selected (automatically obtained from the theme if null).
  final Color? selectedBorderColor;

  /// Border width when selected.
  final double selectedBorderWidth;

  /// Corner radius (needs to match the child widget).
  final double? cornerRadius;

  /// Whether to disable zoom support.
  final bool disableZoom;

  const Selectable({
    super.key,
    required this.child,
    required this.isSelected,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 2.0,
    this.cornerRadius,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isSelected) {
      return child;
    }

    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Zoom support
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Determine the style for the selected state
    final effectiveSelectedBackgroundColor =
        selectedBackgroundColor ??
        colorScheme.interactive.list.selectedBackground.withValues(alpha: 0.1);
    final effectiveSelectedBorderColor =
        selectedBorderColor ?? colorScheme.theme.primaryColor;
    final effectiveCornerRadius = cornerRadius ?? AppBorderRadiusValues.medium;
    final effectiveBorderWidth = selectedBorderWidth * zoomScale;

    // Apply overlay for the selected state
    return Container(
      decoration: BoxDecoration(
        color: effectiveSelectedBackgroundColor,
        border: Border.all(
          color: effectiveSelectedBorderColor,
          width: effectiveBorderWidth,
        ),
        borderRadius: BorderRadius.circular(effectiveCornerRadius),
      ),
      child: child,
    );
  }
}

/// Helper class for managing selection state.
///
/// Used when managing multiple selectable items.
class SelectionState<T> {
  final Set<T> _selectedItems = <T>{};

  /// Set of selected items.
  Set<T> get selectedItems => Set.unmodifiable(_selectedItems);

  /// Whether an item is selected.
  bool isSelected(T item) => _selectedItems.contains(item);

  /// Select an item.
  void select(T item) => _selectedItems.add(item);

  /// Deselect an item.
  void deselect(T item) => _selectedItems.remove(item);

  /// Toggle the selection state of an item.
  void toggle(T item) {
    if (isSelected(item)) {
      deselect(item);
    } else {
      select(item);
    }
  }

  /// Clear all selections.
  void clearSelection() => _selectedItems.clear();

  /// Number of selected items.
  int get selectedCount => _selectedItems.length;

  /// Whether anything is selected.
  bool get hasSelection => _selectedItems.isNotEmpty;
}

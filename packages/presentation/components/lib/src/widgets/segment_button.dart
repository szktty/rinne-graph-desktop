import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

/// A segmented button that automatically applies the app's theme color.
///
/// It supports single selection only and is compatible with accessibility zoom features.
/// Segment width and font size are automatically scaled.
class AppSegmentedButton<T> extends ConsumerWidget {
  final T selectedValue;
  final void Function(T) onChanged;
  final List<(T value, String label)> items;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const AppSegmentedButton({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    double segmentWidth = 120.0 * zoomScale; // Apply zoom scaling

    return SegmentedButton<T>(
      segments:
          items
              .map(
                (item) => ButtonSegment<T>(
                  value: item.$1,
                  label: SizedBox(
                    width: segmentWidth,
                    child: Center(child: Text(item.$2)),
                  ),
                ),
              )
              .toList(),
      selected: {selectedValue},
      onSelectionChanged: (Set<T> selected) => onChanged(selected.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return appColorScheme.theme.primaryColor.withValues(alpha: 0.1);
          }
          return appColorScheme.base.background;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return appColorScheme.theme.primaryColor;
          }
          return appColorScheme.base.foreground;
        }),
        // Apply zoom scaling to text style
        textStyle: WidgetStateProperty.all(
          Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize:
                (Theme.of(context).textTheme.labelMedium?.fontSize ?? 14.0) *
                zoomScale,
          ),
        ),
      ),
    );
  }
}

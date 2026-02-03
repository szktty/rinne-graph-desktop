import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

/// A radio button group component for color selection.
///
/// Provides a radio button group to select one color from any color list.
/// - Displays only buttons in a single row, without showing color names.
/// - Shows color names in a tooltip on mouse hover.
/// - When not selected: solid color circle without border (24px).
/// - When selected: surrounded by a ring of the same color (30x30, ring thickness 4px, spacing 2px).
class AppColorPicker<T> extends ConsumerWidget {
  /// List of color options.
  final List<AppColorOption<T>> options;

  /// Currently selected value.
  final T? selectedValue;

  /// Callback when the value changes.
  final ValueChanged<T>? onChanged;

  /// Spacing between buttons.
  final double spacing;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  /// Semantic label.
  final String? semanticLabel;

  const AppColorPicker({
    super.key,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.spacing = 12.0,
    this.disableZoom = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Semantics(
      label: semanticLabel ?? 'Color selection',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = option.value == selectedValue;

              return Padding(
                padding: EdgeInsets.only(
                  right: index < options.length - 1 ? spacing * zoomScale : 0,
                ),
                child: _ColorPickerButton<T>(
                  option: option,
                  isSelected: isSelected,
                  onTap:
                      onChanged != null ? () => onChanged!(option.value) : null,
                  zoomScale: zoomScale,
                ),
              );
            }).toList(),
      ),
    );
  }
}

/// A class representing a color option.
class AppColorOption<T> {
  /// The value of the option.
  final T value;

  /// The color to display.
  final Color color;

  /// The color name (displayed in tooltip).
  final String name;

  const AppColorOption({
    required this.value,
    required this.color,
    required this.name,
  });
}

/// Individual button for the color picker.
class _ColorPickerButton<T> extends StatefulWidget {
  final AppColorOption<T> option;
  final bool isSelected;
  final VoidCallback? onTap;
  final double zoomScale;

  const _ColorPickerButton({
    required this.option,
    required this.isSelected,
    this.onTap,
    required this.zoomScale,
  });

  @override
  State<_ColorPickerButton<T>> createState() => _ColorPickerButtonState<T>();
}

class _ColorPickerButtonState<T> extends State<_ColorPickerButton<T>> {
  @override
  Widget build(BuildContext context) {
    // Size calculation (conforming to 4px grid).
    const double baseOuterSize = 30.0; // 選択時の外側サイズ
    const double baseInnerSize = 24.0; // 非選択時の円サイズ
    const double ringWidth = 4.0; // 輪の太さ
    const double ringGap = 2.0; // 輪と円の間隔

    final outerSize = baseOuterSize * widget.zoomScale;
    final innerSize = baseInnerSize * widget.zoomScale;
    final scaledRingWidth = ringWidth * widget.zoomScale;
    final scaledRingGap = ringGap * widget.zoomScale;

    return Tooltip(
      message: widget.option.name,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          label: 'Select ${widget.option.name}',
          selected: widget.isSelected,
          onTap: widget.onTap,
          child: Container(
            width: outerSize,
            height: outerSize,
            decoration:
                widget.isSelected
                    ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.option.color,
                        width: scaledRingWidth,
                      ),
                    )
                    : null,
            child: Center(
              child: Container(
                width:
                    widget.isSelected
                        ? innerSize - (scaledRingGap * 2)
                        : innerSize,
                height:
                    widget.isSelected
                        ? innerSize - (scaledRingGap * 2)
                        : innerSize,
                decoration: BoxDecoration(
                  color: widget.option.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

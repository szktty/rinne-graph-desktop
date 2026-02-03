import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../widgets/app_rectangle_border.dart';

/// A component that groups and displays buttons.
///
/// This component logically groups and displays related action buttons.
/// Suitable for use in toolbars, etc.
class ButtonGroup extends ConsumerWidget {
  /// List of buttons.
  final List<Widget> children;

  /// Space between buttons.
  final double spacing;

  /// Background color of the entire group.
  final Color? backgroundColor;

  /// Padding of the group.
  final EdgeInsets padding;

  /// Display direction of the entire group.
  final Axis direction;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a [ButtonGroup].
  ///
  /// [children] - A list of buttons to display in the group.
  /// [spacing] - The space between the buttons.
  /// [backgroundColor] - The background color of the entire group.
  /// [padding] - The padding of the group.
  /// [direction] - The display direction of the buttons (horizontal/vertical).
  const ButtonGroup({
    super.key,
    required this.children,
    this.spacing = 4.0,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(2.0),
    this.direction = Axis.horizontal,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(appColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    return Container(
      padding: EdgeInsets.all(padding.top * zoomScale),
      decoration: BoxDecoration(
        color: backgroundColor ?? appColorScheme.base.background,
        borderRadius: BorderRadius.circular(8.0 * zoomScale),
        border: Border.all(
          color: appColorScheme.base.border.withValues(alpha: 0.2),
          width: 1.0 * borderScale,
        ),
      ),
      child:
          direction == Axis.horizontal
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: _addSpacingBetweenChildren(spacing * zoomScale),
              )
              : Column(
                mainAxisSize: MainAxisSize.min,
                children: _addSpacingBetweenChildren(spacing * zoomScale),
              ),
    );
  }

  /// Add space between child widgets.
  List<Widget> _addSpacingBetweenChildren(double scaledSpacing) {
    if (children.isEmpty) return [];

    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);

      // Add space after all but the last child widget.
      if (i < children.length - 1) {
        if (direction == Axis.horizontal) {
          result.add(SizedBox(width: scaledSpacing));
        } else {
          result.add(SizedBox(height: scaledSpacing));
        }
      }
    }

    return result;
  }
}

/// Icon button for use within a ButtonGroup.
class GroupIconButton extends ConsumerWidget {
  /// The icon to display on the button.
  final IconData icon;

  /// Callback for when the button is pressed.
  final VoidCallback? onPressed;

  /// Description of the button (tooltip).
  final String? tooltip;

  /// Whether the button is selected.
  final bool isSelected;

  /// The size of the button.
  final double size;

  const GroupIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isSelected = false,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(appColorSchemeProvider);

    final button = IconButton(
      icon: Icon(
        icon,
        color:
            isSelected
                ? appColorScheme.appSpecific.graph.nodeBase
                : appColorScheme.uiAreas.sideBar.inactiveItemText,
        size: 20.0,
      ),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor:
            isSelected
                ? appColorScheme.appSpecific.graph.nodeBase.withValues(
                  alpha: 0.2,
                )
                : Colors.transparent,
        minimumSize: Size(size, size),
        shape: ref.watch(appRectangleBorderProvider),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Button with text for use within a ButtonGroup.
class GroupButton extends ConsumerWidget {
  /// The text to display on the button.
  final String label;

  /// The icon to display on the button (optional).
  final IconData? icon;

  /// Callback for when the button is pressed.
  final VoidCallback? onPressed;

  /// Description of the button (tooltip).
  final String? tooltip;

  /// Whether the button is selected.
  final bool isSelected;

  const GroupButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.tooltip,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(appColorSchemeProvider);

    final button = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected
                ? appColorScheme.appSpecific.graph.nodeBase.withValues(
                  alpha: 0.2,
                )
                : Colors.transparent,
        shape: ref.watch(appRectangleBorderProvider),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16.0,
              color:
                  isSelected
                      ? appColorScheme.appSpecific.graph.nodeBase
                      : appColorScheme.uiAreas.sideBar.inactiveItemText,
            ),
            const SizedBox(width: 4.0),
          ],
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? appColorScheme.appSpecific.graph.nodeBase
                      : appColorScheme.uiAreas.sideBar.inactiveItemText,
            ),
          ),
        ],
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

import 'toolbar_state.dart';
import 'toolbar_providers.dart';

/// Toolbar widget.
class _Toolbar extends ConsumerWidget {
  const _Toolbar({
    required this.children,
    this.axis = Axis.horizontal,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.decoration,
    this.clipBehavior = Clip.none,
    this.disableZoom = false,
  });

  /// Widgets within the toolbar.
  final List<Widget> children;

  /// Direction of the toolbar (horizontal/vertical).
  final Axis axis;

  /// Space between items.
  final double spacing;

  /// Internal padding of the toolbar.
  final EdgeInsetsGeometry padding;

  /// Decoration of the toolbar.
  final BoxDecoration? decoration;

  /// Clipping behavior.
  final Clip clipBehavior;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    return Container(
      decoration:
          decoration ??
          BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: borderScale,
              ),
            ),
          ),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          (padding as EdgeInsets).left * zoomScale,
          (padding as EdgeInsets).top * zoomScale,
          (padding as EdgeInsets).right * zoomScale,
          (padding as EdgeInsets).bottom * zoomScale,
        ),
        child:
            axis == Axis.horizontal
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _addSpacing(children, spacing * zoomScale),
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _addSpacing(children, spacing * zoomScale),
                ),
      ),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, double space) {
    return widgets
        .expand((widget) sync* {
          yield SizedBox(
            width: axis == Axis.horizontal ? space : 0,
            height: axis == Axis.vertical ? space : 0,
          );
          yield widget;
        })
        .skip(1)
        .toList();
  }
}

/// Item group for the toolbar.
class ToolbarGroup extends ConsumerWidget {
  const ToolbarGroup({
    super.key,
    required this.children,
    this.spacing = 4.0,
    this.disableZoom = false,
  });

  final List<Widget> children;
  final double spacing;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          children
              .expand((child) sync* {
                yield SizedBox(width: spacing * zoomScale);
                yield child;
              })
              .skip(1)
              .toList(),
    );
  }
}

/// Toolbar item.
class ToolbarItem extends ConsumerWidget {
  const ToolbarItem({
    super.key,
    required this.child,
    this.onPressed,
    this.tooltip,
    this.enabled = true,
    this.disableZoom = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool enabled;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final button = IconButton(
      onPressed: enabled ? onPressed : null,
      icon: child,
      iconSize: 24 * zoomScale,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Toolbar widget using Riverpod.
class Toolbar extends ConsumerWidget {
  const Toolbar({
    super.key,
    required this.axis,
    required this.items,
    this.disableZoom = false,
  });

  final Axis axis;
  final List<ToolbarItemData> items;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toolbarStateNotifierProvider);
    final toolbarNotifier = ref.read(toolbarStateNotifierProvider.notifier);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return _Toolbar(
      axis: axis,
      spacing: 8.0 * zoomScale,
      padding: EdgeInsets.all(8.0 * zoomScale),
      decoration: null,
      clipBehavior: Clip.none,
      disableZoom: disableZoom,
      children:
          items.map((item) {
            // Deleted because it is not used
            final isEnabled = state.enabledTools.contains(item.id);

            return ToolbarItem(
              onPressed:
                  isEnabled ? () => toolbarNotifier.selectTool(item.id) : null,
              tooltip: item.tooltip,
              enabled: isEnabled,
              disableZoom: disableZoom,
              child: item.icon,
            );
          }).toList(),
    );
  }
}

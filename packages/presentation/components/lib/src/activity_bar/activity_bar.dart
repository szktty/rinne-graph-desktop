import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_gesture_detector.dart';

/// Activity bar item
class ActivityBarItem {
  const ActivityBarItem({
    required this.icon,
    required this.label,
    required this.logicalIndex,
    this.badge,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final int logicalIndex;
  final String? badge;
  final VoidCallback? onTap;
  final bool enabled;
}

/// Activity bar
///
/// Displays items divided into two sections (top: main functions, bottom: meta functions).
class ActivityBar extends ConsumerWidget {
  const ActivityBar({
    required this.topItems,
    required this.bottomItems,
    this.selectedIndex,
    this.disableZoom = false,
    super.key,
  });

  final List<ActivityBarItem> topItems;
  final List<ActivityBarItem> bottomItems;
  final int? selectedIndex;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Container(
      color: appColorScheme.uiAreas.activityBar.background,
      child: Column(
        children: [
          // Top items (main functions)
          Expanded(
            child: ListView.builder(
              itemCount: topItems.length,
              itemBuilder: (context, index) {
                final item = topItems[index];
                return _ActivityBarItemWidget(
                  item: item,
                  isSelected: selectedIndex == item.logicalIndex,
                  disableZoom: disableZoom,
                );
              },
            ),
          ),

          // Bottom items (meta functions)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < bottomItems.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == bottomItems.length - 1 ? 8.0 : 0.0,
                  ),
                  child: _ActivityBarItemWidget(
                    item: bottomItems[i],
                    isSelected: selectedIndex == bottomItems[i].logicalIndex,
                    disableZoom: disableZoom,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual activity bar item
class _ActivityBarItemWidget extends ConsumerWidget {
  const _ActivityBarItemWidget({
    required this.item,
    this.isSelected = false,
    this.disableZoom = false,
  });

  final ActivityBarItem item;
  final bool isSelected;
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    return Tooltip(
      message: item.label,
      preferBelow: false,
      child: AppGestureDetector(
        onTap: item.enabled ? item.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color:
                    isSelected
                        ? appColorScheme.base.selection
                        : Colors.transparent,
                width: (2.0 * borderScale).toDouble(),
              ),
            ),
            // Use color scheme settings: background color is primary color when selected
            color:
                isSelected
                    ? appColorScheme.uiAreas.activityBar.activeItemBackground
                    : null,
          ),
          child: SizedBox(
            height: (44.0 * zoomScale).toDouble(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppIcon(
                  item.icon,
                  customSize: 22.0,
                  // Use color scheme settings
                  customColor:
                      !item.enabled
                          ? appColorScheme.uiAreas.activityBar.inactiveItem
                              .withValues(alpha: 0.3)
                          : isSelected
                          ? appColorScheme.uiAreas.activityBar.activeItem
                          : appColorScheme.uiAreas.activityBar.inactiveItem,
                  disableZoom: disableZoom,
                  semanticLabel: item.label,
                ),
                if (item.badge != null)
                  Positioned(
                    top: (6.0 * zoomScale).toDouble(),
                    right: (6.0 * zoomScale).toDouble(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: appColorScheme.status.error,
                        borderRadius: BorderRadius.circular(
                          (8.0 * borderScale).toDouble(),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (4.0 * zoomScale).toDouble(),
                          vertical: (2.0 * zoomScale).toDouble(),
                        ),
                        child: Text(
                          item.badge!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize:
                                (theme.textTheme.labelSmall?.fontSize ?? 12) *
                                zoomScale,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

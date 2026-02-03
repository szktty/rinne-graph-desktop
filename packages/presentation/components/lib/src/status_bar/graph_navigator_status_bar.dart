import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../typography/app_text.dart';
import 'status_bar_utils.dart';

/// Status bar component for graph navigator.
///
/// Displays information about selected records and view statistics.
class GraphNavigatorStatusBar extends ConsumerWidget {
  const GraphNavigatorStatusBar({
    required this.selectedEntityInfo,
    required this.statisticsInfo,
    required this.searchFilterState,
    this.disableZoom = false,
    super.key,
  });

  /// Information about the selected entity.
  final AsyncValue<dynamic> selectedEntityInfo;

  /// Graph statistics.
  final AsyncValue<dynamic> statisticsInfo;

  /// Search/filter state.
  final dynamic searchFilterState;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Container(
      height: 36.0 * zoomScale,
      padding: EdgeInsets.fromLTRB(
        20.0 * zoomScale,
        0.0 * zoomScale,
        20.0 * zoomScale,
        4.0 * zoomScale,
      ),
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.statusBar.background,
        border: Border(
          top: BorderSide(
            color: appColorScheme.base.divider.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _ResponsiveStatusBarContent(
            selectedEntityInfo: selectedEntityInfo,
            statisticsInfo: statisticsInfo,
            searchFilterState: searchFilterState,
            availableWidth: constraints.maxWidth,
            zoomScale: zoomScale,
          );
        },
      ),
    );
  }
}

/// レスポンシブ対応のステータスバーコンテンツ
class _ResponsiveStatusBarContent extends ConsumerWidget {
  const _ResponsiveStatusBarContent({
    required this.selectedEntityInfo,
    required this.statisticsInfo,
    required this.searchFilterState,
    required this.availableWidth,
    required this.zoomScale,
  });

  final AsyncValue<dynamic> selectedEntityInfo;
  final AsyncValue<dynamic> statisticsInfo;
  final dynamic searchFilterState;
  final double availableWidth;
  final double zoomScale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Generate display string for statistics
    final statisticsText = _buildStatisticsText();

    // Generate display string for selection info
    final selectionText = _buildSelectionText();

    // Determine layout based on display priority
    return Row(
      children: [
        // Selected record info (medium priority)
        if (selectionText != null && _hasSpaceForSelection()) ...[
          Expanded(
            child: AppText(
              selectionText,
              variant: AppTextVariant.bodyText,
              color: appColorScheme.uiAreas.statusBar.foreground,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 20.0 * zoomScale,
          ), // Spacing between statistics and info set to 20px
        ],

        // Spacer (only if no selection info)
        if (selectionText == null || !_hasSpaceForSelection()) const Spacer(),

        // View statistics (highest priority)
        if (statisticsText != null)
          AppText(
            statisticsText,
            variant: AppTextVariant.bodyText,
            color: appColorScheme.uiAreas.statusBar.foreground,
          ),
      ],
    );
  }

  /// Constructs the display string for statistics.
  String? _buildStatisticsText() {
    return statisticsInfo.when(
      data: (data) {
        if (data == null) return null;

        final isSearchActive = searchFilterState?.isActive ?? false;

        if (isSearchActive) {
          // When search/filter is applied
          return StatusBarUtils.formatSearchResultText(
            displayedCount: data.displayedRecords,
            filteredTotalCount: searchFilterState?.filteredRecords ?? 0,
            totalCount: data.totalRecords,
          );
        } else {
          // Normal state
          return StatusBarUtils.formatNormalViewText(
            displayedCount: data.displayedRecords,
            totalCount: data.totalRecords,
          );
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Constructs the display string for selection info.
  String? _buildSelectionText() {
    return selectedEntityInfo.when(
      data: (data) {
        if (data == null) return null;

        switch (data.runtimeType.toString()) {
          case 'SelectedNodeData':
            return StatusBarUtils.formatSelectedNodeText(
              displayName: data.displayName,
              linkCount: data.linkCount,
            );
          case 'SelectedLinkData':
            return StatusBarUtils.formatSelectedLinkText(
              displayName: data.displayName,
              nodeCount: data.nodeCount,
            );
          default:
            return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Determines if there is space to display selection info.
  bool _hasSpaceForSelection() {
    // Calculate minimum width (statistics + margin)
    const minStatisticsWidth = 180.0; // Shrink minimum width of statistics
    const marginWidth = 20.0; // Margin width set to 20px

    final requiredWidth = (minStatisticsWidth + marginWidth) * zoomScale;

    return availableWidth > requiredWidth;
  }
}

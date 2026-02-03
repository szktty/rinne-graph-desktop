import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../stack_grid/app_stack_grid.dart';
import '../typography/app_text.dart';

/// Generic panel widget for stack selection.
/// Includes pagination, search, and filtering features.
class StackSelectionPanel<T> extends ConsumerStatefulWidget {
  /// List of stack data.
  final List<T> stacks;

  /// Function to convert stack data to StackData.
  final StackData Function(T) stackDataConverter;

  /// Callback when a stack is selected.
  final ValueChanged<T>? onStackSelected;

  /// Callback when a stack is double-clicked.
  final ValueChanged<T>? onStackDoubleClicked;

  /// Currently selected stack.
  final T? selectedStack;

  /// Number of grid columns (default: 3).
  final int gridColumns;

  /// Number of grid rows (default: 2).
  final int gridRows;

  /// Horizontal spacing between cards (default: 24).
  final double crossAxisSpacing;

  /// Vertical spacing between cards (default: 20).
  final double mainAxisSpacing;

  /// Padding for the entire grid.
  final EdgeInsets gridPadding;

  /// Whether to show page indicator.
  final bool showPageIndicator;

  /// Whether to show page navigation buttons.
  final bool showNavigationButtons;

  /// Whether to force display pagination (for development/testing).
  final bool forceShowPagination;

  /// Whether to enable search functionality.
  final bool enableSearch;

  /// Search filter function.
  final bool Function(T stack, String query)? searchFilter;

  /// Widget for displaying empty state.
  final Widget? emptyWidget;

  /// Widget for displaying loading state.
  final Widget? loadingWidget;

  /// Callback for displaying error state.
  final Widget Function(Object error)? errorBuilder;

  /// Title.
  final String? title;

  /// Subtitle.
  final String? subtitle;

  const StackSelectionPanel({
    super.key,
    required this.stacks,
    required this.stackDataConverter,
    this.onStackSelected,
    this.onStackDoubleClicked,
    this.selectedStack,
    this.gridColumns = 3,
    this.gridRows = 2,
    this.crossAxisSpacing = 24.0,
    this.mainAxisSpacing = 20.0,
    this.gridPadding = EdgeInsets.zero,
    this.showPageIndicator = true,
    this.showNavigationButtons = true,
    this.forceShowPagination = false,
    this.enableSearch = false,
    this.searchFilter,
    this.emptyWidget,
    this.loadingWidget,
    this.errorBuilder,
    this.title,
    this.subtitle,
  });

  @override
  ConsumerState<StackSelectionPanel<T>> createState() =>
      _StackSelectionPanelState<T>();
}

class _StackSelectionPanelState<T>
    extends ConsumerState<StackSelectionPanel<T>> {
  String _searchQuery = '';
  List<T> _filteredStacks = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredStacks();
  }

  @override
  void didUpdateWidget(StackSelectionPanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stacks != widget.stacks) {
      _updateFilteredStacks();
    }
  }

  void _updateFilteredStacks() {
    if (!widget.enableSearch || _searchQuery.isEmpty) {
      _filteredStacks = widget.stacks;
    } else {
      _filteredStacks =
          widget.stacks
              .where(
                (stack) =>
                    widget.searchFilter?.call(stack, _searchQuery) ?? true,
              )
              .toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _updateFilteredStacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title and subtitle
        if (widget.title != null) ...[
          AppText(
            widget.title!,
            variant: AppTextVariant.pageTitle,
            color: colorScheme.uiAreas.sideBar.activeItemText,
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            AppText(
              widget.subtitle!,
              variant: AppTextVariant.bodyText,
              color: colorScheme.uiAreas.sideBar.inactiveItemText,
            ),
          ],
          const SizedBox(height: 24),
        ],

        // Search bar
        if (widget.enableSearch) ...[
          TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search stacks...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Stack grid
        Expanded(child: _buildStackGrid(colorScheme)),
      ],
    );
  }

  Widget _buildStackGrid(AppColorScheme colorScheme) {
    // Convert stack data to StackData
    final stackDataList =
        _filteredStacks.map(widget.stackDataConverter).toList();

    return AppStackGrid(
      stacks: stackDataList,
      gridColumns: widget.gridColumns,
      gridRows: widget.gridRows,
      gridPadding: widget.gridPadding,
      crossAxisSpacing: widget.crossAxisSpacing,
      mainAxisSpacing: widget.mainAxisSpacing,
      selectedStack:
          widget.selectedStack != null
              ? widget.stackDataConverter(widget.selectedStack as T)
              : null,
      onStackSelected: (stackData) {
        // Find and return the original stack object
        final originalStack = _findOriginalStack(stackData);
        if (originalStack != null) {
          widget.onStackSelected?.call(originalStack);
        }
      },
      onStackDoubleClicked: (stackData) {
        // Find and return the original stack object
        final originalStack = _findOriginalStack(stackData);
        if (originalStack != null) {
          widget.onStackDoubleClicked?.call(originalStack);
        }
      },
      showPageIndicator: widget.showPageIndicator,
      showNavigationButtons: widget.showNavigationButtons,
      forceShowPagination: widget.forceShowPagination,
      emptyWidget: widget.emptyWidget ?? _buildDefaultEmptyWidget(colorScheme),
      loadingWidget: widget.loadingWidget,
      errorBuilder: widget.errorBuilder,
    );
  }

  /// Finds the original stack object from StackData.
  T? _findOriginalStack(StackData stackData) {
    try {
      return _filteredStacks.firstWhere(
        (stack) => widget.stackDataConverter(stack).id == stackData.id,
      );
    } catch (e) {
      return null;
    }
  }

  /// Default empty state widget.
  Widget _buildDefaultEmptyWidget(AppColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.layers_outlined,
            size: 64,
            color: colorScheme.uiAreas.sideBar.inactiveItemText.withValues(
              alpha: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            _searchQuery.isEmpty ? 'No stacks available' : 'No search results',
            variant: AppTextVariant.bodyText,
            color: colorScheme.uiAreas.sideBar.activeItemText,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            AppText(
              'Please change search criteria',
              variant: AppTextVariant.smallText,
              color: colorScheme.uiAreas.sideBar.inactiveItemText,
            ),
          ],
        ],
      ),
    );
  }
}

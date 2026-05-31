/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

import 'package:fonde_ui/fonde_ui.dart'
    show
        FondeGestureDetector,
        FondePageIndicator,
        FondeBorderRadiusValues,
        FondeRectangleBorder,
        FondePopupMenu,
        FondePopupMenuItem,
        FondePopupMenuDivider,
        FondePopupMenuEntry,
        FondePopupMenuItemEntry,
        FondePopupMenuDividerEntry;
import 'package:fonde_ui/src/widgets/widgets/fonde_rectangle_border.dart'
    show fondeBorderRadiusProvider;

import '../typography/app_text.dart';
import '../icons/app_icons.dart';

/// Class to hold card dimension information
class CardDimensions {
  final double cardWidth;
  final double cardHeight;
  final double thumbnailWidth;
  final double thumbnailHeight;

  const CardDimensions({
    required this.cardWidth,
    required this.cardHeight,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
  });
}

/// Data type for stack
abstract class StackData {
  String get id;
  String get name;
  String? get thumbnailUrl;
  List<String> get categories;
  int get nodeCount;
  int get linkCount;
  String get updatedAt;
  bool get isFavorite;
  Map<String, dynamic> get metadata;
}

/// Stack card grid component with pagination support
class AppStackGrid extends ConsumerStatefulWidget {
  // Layout constants
  static const double _cardPadding = 4.0;
  static const double _cardBorderWidth = 2.0;
  static const double _spaceBetweenThumbnailAndTitle = 8.0;
  static const double _titleHeight = 28.0;
  static const double _thumbnailAspectRatio = 4 / 3;

  // Title section height (spacing + title height)
  static const double titleSpaceHeight =
      _spaceBetweenThumbnailAndTitle + _titleHeight;

  /// List of stack data
  final List<StackData> stacks;

  /// Number of grid columns (default: 3)
  final int gridColumns;

  /// Number of grid rows (default: 2)
  final int gridRows;

  /// Horizontal space between cards (default: 24)
  final double crossAxisSpacing;

  /// Vertical space between cards (default: 20)
  final double mainAxisSpacing;

  /// Grid padding (deprecated - use gridPadding)
  @Deprecated('Use gridPadding instead')
  final EdgeInsets padding;

  /// Padding for entire grid (default: EdgeInsets.zero)
  final EdgeInsets gridPadding;

  /// Fixed width for each item (auto-calculated if null)
  final double? itemWidth;

  /// Fixed height for each item (auto-calculated if null)
  final double? itemHeight;

  /// Fixed height for grid section (for coordination with external widgets)
  final double? fixedHeight;

  /// Callback when stack is selected
  final ValueChanged<StackData>? onStackSelected;

  /// Callback when stack is double-clicked
  final ValueChanged<StackData>? onStackDoubleClicked;

  /// Callback for stack detail actions (favorite, pin, etc.)
  final void Function(StackData stack, String action)? onStackAction;

  /// Callback to generate custom action menu items
  final List<FondePopupMenuEntry<String>> Function(StackData stack)?
  customActionItems;

  /// Currently selected stack
  final StackData? selectedStack;

  /// Callback to display error state
  final Widget Function(Object error)? errorBuilder;

  /// Widget to display empty state
  final Widget? emptyWidget;

  /// Widget to display loading state
  final Widget? loadingWidget;

  /// Whether to show page indicator (default: true)
  final bool showPageIndicator;

  /// Whether to show navigation arrow buttons (default: true)
  final bool showNavigationButtons;

  /// Whether to force show pagination (for development/testing)
  final bool forceShowPagination;

  const AppStackGrid({
    required this.stacks,
    this.gridColumns = 3,
    this.gridRows = 2,
    this.crossAxisSpacing = 24.0,
    this.mainAxisSpacing = 20.0,
    @Deprecated('Use gridPadding instead')
    this.padding = const EdgeInsets.only(bottom: 24),
    this.gridPadding = EdgeInsets.zero,
    this.itemWidth,
    this.itemHeight,
    this.fixedHeight,
    this.onStackSelected,
    this.onStackDoubleClicked,
    this.onStackAction,
    this.customActionItems,
    this.selectedStack,
    this.errorBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.showPageIndicator = true,
    this.showNavigationButtons = true,
    this.forceShowPagination = false,
    super.key,
  });

  @override
  ConsumerState<AppStackGrid> createState() => _AppStackGridState();
}

class _AppStackGridState extends ConsumerState<AppStackGrid> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _stacksPerPage => widget.gridColumns * widget.gridRows;
  int get _totalPages =>
      widget.stacks.isEmpty
          ? 0
          : (widget.stacks.length / _stacksPerPage).ceil();

  /// Helper method to calculate card dimensions
  CardDimensions _calculateCardDimensions(double availableWidth) {
    final cardWidth =
        (availableWidth -
            (widget.crossAxisSpacing * (widget.gridColumns - 1))) /
        widget.gridColumns;

    // Thumbnail width considering only border (padding removed)
    final thumbnailWidth = cardWidth - (AppStackGrid._cardBorderWidth * 2);
    final thumbnailHeight = thumbnailWidth / AppStackGrid._thumbnailAspectRatio;

    // Card total height (padding and spacing removed)
    final cardHeight =
        thumbnailHeight +
        AppStackGrid._titleHeight +
        (AppStackGrid._cardBorderWidth * 2);

    return CardDimensions(
      cardWidth: cardWidth,
      cardHeight: cardHeight,
      thumbnailWidth: thumbnailWidth,
      thumbnailHeight: thumbnailHeight,
    );
  }

  void _goToPage(int page) {
    if (page >= 0 && page < _totalPages && _pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _goToPage(_currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    // Handle empty state
    if (widget.stacks.isEmpty) {
      return widget.emptyWidget ?? _buildEmptyState(colorScheme);
    }

    return Column(
      children: [
        // Main grid area
        widget.fixedHeight != null
            ? SizedBox(
              height: widget.fixedHeight,
              child: _buildGridContent(colorScheme),
            )
            : Expanded(child: _buildGridContent(colorScheme)),

        // Page indicator (shown only if total pages > 1)
        if (widget.showPageIndicator &&
            (_totalPages > 1 || widget.forceShowPagination)) ...[
          const SizedBox(height: 16),
          FondePageIndicator(
            dotsCount: _totalPages,
            position: _currentPage.toDouble(),
            onDotTapped: (index) => _goToPage(index),
          ),
        ],
      ],
    );
  }

  Widget _buildGridContent(AppColorScheme colorScheme) {
    return Row(
      children: [
        // Left navigation button
        if (widget.showNavigationButtons &&
            (_totalPages > 1 || widget.forceShowPagination)) ...[
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0 ? _previousPage : null,
            color: colorScheme.uiAreas.sideBar.activeItemText,
          ),
          const SizedBox(width: 8),
        ],

        // Grid content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _totalPages,
            itemBuilder: (context, pageIndex) {
              return _buildPageGrid(pageIndex, colorScheme);
            },
          ),
        ),

        // Right navigation button
        if (widget.showNavigationButtons &&
            (_totalPages > 1 || widget.forceShowPagination)) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
            color: colorScheme.uiAreas.sideBar.activeItemText,
          ),
        ],
      ],
    );
  }

  Widget _buildPageGrid(int pageIndex, AppColorScheme colorScheme) {
    final startIndex = pageIndex * _stacksPerPage;
    final endIndex = (startIndex + _stacksPerPage).clamp(
      0,
      widget.stacks.length,
    );
    final pageStacks = widget.stacks.sublist(startIndex, endIndex);

    return Padding(
      // Use new gridPadding, fallback to old padding for compatibility
      padding:
          widget.gridPadding != EdgeInsets.zero
              ? widget.gridPadding
              : widget.padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use unified card dimension calculation
          final dimensions = _calculateCardDimensions(constraints.maxWidth);
          final childAspectRatio =
              (dimensions.cardHeight > 0)
                  ? dimensions.cardWidth / dimensions.cardHeight
                  : 1.0;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.gridColumns,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: pageStacks.length,
            itemBuilder: (context, index) {
              final stack = pageStacks[index];
              return _buildStackCard(stack, colorScheme, dimensions);
            },
          );
        },
      ),
    );
  }

  Widget _buildStackCard(
    StackData stack,
    AppColorScheme colorScheme,
    CardDimensions dimensions,
  ) {
    final isSelected = widget.selectedStack?.id == stack.id;

    // Show special card for new stack option
    if (stack.id == '__new_stack__') {
      return _buildNewStackCard(stack, colorScheme);
    }

    // "Frame and title" design: card contains only thumbnail, stack name below
    return _StackCardWithHover(
      stack: stack,
      isSelected: isSelected,
      colorScheme: colorScheme,
      dimensions: dimensions,
      onTap: () => widget.onStackSelected?.call(stack),
      onDoubleTap: () => widget.onStackDoubleClicked?.call(stack),
      onStackAction: widget.onStackAction,
      customActionItems: widget.customActionItems,
    );
  }

  Widget _buildThumbnail(StackData stack, AppColorScheme colorScheme) {
    if (stack.thumbnailUrl != null) {
      return _buildThumbnailImage(stack.thumbnailUrl!, colorScheme);
    } else {
      return _buildThumbnailPlaceholder(colorScheme);
    }
  }

  Widget _buildThumbnailImage(
    String thumbnailPath,
    AppColorScheme colorScheme,
  ) {
    // Support only local files within stack
    return Image.file(
      File(thumbnailPath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder:
          (context, error, stackTrace) =>
              _buildThumbnailPlaceholder(colorScheme),
    );
  }

  Widget _buildThumbnailPlaceholder(AppColorScheme colorScheme) {
    return Container(
      color: colorScheme.uiAreas.sideBar.background.withValues(alpha: 0.3),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Icon(
          Icons.layers,
          size: 32,
          color: colorScheme.uiAreas.sideBar.inactiveItemText.withValues(
            alpha: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(AppColorScheme colorScheme) {
    // Empty slot displays nothing
    return Container();
  }

  Widget _buildEmptyState(AppColorScheme colorScheme) {
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
            'No stacks',
            variant: AppTextVariant.bodyText,
            color: colorScheme.uiAreas.sideBar.activeItemText,
          ),
        ],
      ),
    );
  }

  /// Build new stack card (adjusted to match "frame and title" design)
  Widget _buildNewStackCard(StackData stack, AppColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight =
            constraints.maxHeight - AppStackGrid.titleSpaceHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card section (new creation icon)
            SizedBox(
              height: cardHeight,
              child: Material(
                type: MaterialType.transparency,
                child: FondeGestureDetector(
                  onTap: () => widget.onStackSelected?.call(stack),
                  onTapCancel: () {
                    // Empty implementation to enable immediate execution mode
                  },
                  onDoubleTap: () => widget.onStackDoubleClicked?.call(stack),
                  child: FondeRectangleBorder(
                    cornerRadius: FondeBorderRadiusValues.small,
                    side: BorderSide(
                      color: colorScheme.status.info,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 48,
                        color: colorScheme.status.info,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Stack name (below card)
            SizedBox(height: AppStackGrid._spaceBetweenThumbnailAndTitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                height: AppStackGrid._titleHeight,
                child: AppText(
                  stack.name,
                  variant: AppTextVariant.itemTitle,
                  color: colorScheme.status.info,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Stack card widget that manages hover state
class _StackCardWithHover extends ConsumerStatefulWidget {
  const _StackCardWithHover({
    required this.stack,
    required this.isSelected,
    required this.colorScheme,
    required this.dimensions,
    required this.onTap,
    required this.onDoubleTap,
    this.onStackAction,
    this.customActionItems,
  });

  final StackData stack;
  final bool isSelected;
  final AppColorScheme colorScheme;
  final CardDimensions dimensions;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final void Function(StackData stack, String action)? onStackAction;
  final List<FondePopupMenuEntry<String>> Function(StackData stack)?
  customActionItems;

  @override
  ConsumerState<_StackCardWithHover> createState() =>
      _StackCardWithHoverState();
}

class _StackCardWithHoverState extends ConsumerState<_StackCardWithHover> {
  bool _isHovered = false;
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        children: [
          // Main stack card
          FondeGestureDetector(
            onTap: widget.onTap,
            onTapCancel: () {
              // Provide onTapCancel to enable immediate execution mode
              // On double-tap, execute open action while maintaining selection state
              // (deselection not needed - double-tap means "select and open")
            },
            onDoubleTap: widget.onDoubleTap,
            child: FondeRectangleBorder(
              cornerRadius: FondeBorderRadiusValues.small,
              // Card background is transparent (no highlight on thumbnail)
              color: Colors.transparent,
              side:
                  widget.isSelected
                      ? BorderSide(
                        color: widget.colorScheme.base.selection,
                        width: AppStackGrid._cardBorderWidth,
                      )
                      : BorderSide(
                        color: Colors.transparent,
                        width: AppStackGrid._cardBorderWidth,
                      ),
              // Remove padding to eliminate gaps
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thumbnail section (using calculated dimensions, no highlight)
                  SizedBox(
                    height: widget.dimensions.thumbnailHeight,
                    child: FondeRectangleBorder(
                      cornerRadius: FondeBorderRadiusValues.small,
                      side: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      child: _buildThumbnail(),
                    ),
                  ),
                  // Remove space between thumbnail and title
                  // Apply highlight background and text color to title section (rectangle, no border)
                  Container(
                    color:
                        widget.isSelected
                            ? widget.colorScheme.base.selection
                            : Colors.transparent,
                    // Remove horizontal padding
                    height: AppStackGrid._titleHeight,
                    child: Center(
                      child: AppText(
                        widget.stack.name,
                        variant: AppTextVariant.itemTitle,
                        color:
                            widget.isSelected
                                ? widget
                                    .colorScheme
                                    .interactive
                                    .list
                                    .selectedText
                                : widget
                                    .colorScheme
                                    .uiAreas
                                    .sideBar
                                    .activeItemText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sample template badge display
          if (_isTemplateStack())
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.colorScheme.status.info,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  'Template',
                  variant: AppTextVariant.bodyText,
                  color: Colors.white,
                ),
              ),
            ),

          // Show action button on hover or when menu is open
          if ((_isHovered || _isMenuOpen) && widget.onStackAction != null)
            Positioned(
              top: 8,
              right: 8,
              child: _StackActionButton(
                stack: widget.stack,
                colorScheme: widget.colorScheme,
                onStackAction: widget.onStackAction!,
                customActionItems: widget.customActionItems,
                onMenuOpenChanged: (isOpen) {
                  setState(() {
                    _isMenuOpen = isOpen;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Determine if this is a sample template stack
  bool _isTemplateStack() {
    return widget.stack.metadata['isTemplate'] == true;
  }

  Widget _buildThumbnail() {
    if (widget.stack.thumbnailUrl != null) {
      return _buildThumbnailImage(widget.stack.thumbnailUrl!);
    } else {
      return _buildThumbnailPlaceholder();
    }
  }

  Widget _buildThumbnailImage(String thumbnailPath) {
    // Support only local files within stack
    return Image.file(
      File(thumbnailPath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder:
          (context, error, stackTrace) => _buildThumbnailPlaceholder(),
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(
      color: widget.colorScheme.uiAreas.sideBar.background.withValues(
        alpha: 0.3,
      ),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Icon(
          Icons.layers,
          size: 32,
          color: widget.colorScheme.uiAreas.sideBar.inactiveItemText.withValues(
            alpha: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Stack action button widget
class _StackActionButton extends ConsumerWidget {
  const _StackActionButton({
    required this.stack,
    required this.colorScheme,
    required this.onStackAction,
    this.customActionItems,
    this.onMenuOpenChanged,
  });

  final StackData stack;
  final AppColorScheme colorScheme;
  final void Function(StackData stack, String action) onStackAction;
  final List<FondePopupMenuEntry<String>> Function(StackData stack)?
  customActionItems;
  final ValueChanged<bool>? onMenuOpenChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FondePopupMenu<String>.circleActionButton(
      icon: AppIcons.ellipsis,
      iconSize: 16,
      iconColor: colorScheme.interactive.actionButton.iconColor,
      backgroundColor: colorScheme.interactive.actionButton.background,
      hoverColor: colorScheme.interactive.actionButton.background,
      size: 32,
      tooltip: 'Stack actions',
      onOpenStateChanged: onMenuOpenChanged,
      items:
          customActionItems?.call(stack) ??
          [
            FondePopupMenuItemEntry<String>(
              FondePopupMenuItem<String>(
                value: 'archive',
                title: 'Archive',
                icon: Icons.archive_outlined,
                onSelected: () => onStackAction(stack, 'archive'),
              ),
            ),
          ],
    );
  }
}

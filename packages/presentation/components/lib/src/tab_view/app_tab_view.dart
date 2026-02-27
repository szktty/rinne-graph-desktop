/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'app_tab_bar.dart';

/// Definition of tab content.
class AppTabContent {
  /// The ID of the tab (must match the ID of AppTab).
  final String id;

  /// The content widget of the tab.
  final Widget content;

  const AppTabContent({required this.id, required this.content});
}

/// App app-specific tab view widget.
/// Used in combination with AppTabBar to provide a tab-switchable view.
class AppTabView extends StatefulWidget {
  /// List of tabs.
  final List<AppTab> tabs;

  /// List of tab contents.
  final List<AppTabContent> contents;

  /// ID of the initially selected tab.
  final String? initialSelectedTabId;

  /// Callback when a tab is selected.
  final void Function(String tabId)? onTabSelected;

  /// Callback when a tab is closed.
  final void Function(String tabId)? onTabClosed;

  /// Placement of the tab bar.
  final TabBarPosition tabBarPosition;

  /// Height of the tab bar.
  final double tabBarHeight;

  /// Background color of the tab bar.
  final Color? tabBarBackgroundColor;

  /// Background color of the content area.
  final Color? contentBackgroundColor;

  /// Divider between the tab bar and the content.
  final bool showDivider;

  /// Color of the divider.
  final Color? dividerColor;

  /// Thickness of the divider.
  final double dividerThickness;

  /// Padding of the content.
  final EdgeInsets contentPadding;

  /// Builder for customizing the tab bar.
  final Widget Function(
    BuildContext context,
    List<AppTab> tabs,
    String selectedTabId,
    void Function(String) onTabSelected,
    void Function(String)? onTabClosed,
  )?
  tabBarBuilder;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Tab alignment method (e.g., center alignment).
  final TabAlignment alignment;

  const AppTabView({
    super.key,
    required this.tabs,
    required this.contents,
    this.initialSelectedTabId,
    this.onTabSelected,
    this.onTabClosed,
    this.tabBarPosition = TabBarPosition.top,
    this.tabBarHeight = 48.0,
    this.tabBarBackgroundColor,
    this.contentBackgroundColor,
    this.showDivider = true,
    this.dividerColor,
    this.dividerThickness = 1.0,
    this.contentPadding = EdgeInsets.zero,
    this.tabBarBuilder,
    this.disableZoom = false,
    this.alignment = TabAlignment.center,
  }) : assert(
         tabs.length == contents.length,
         'tabs and contents must have the same length. tabs: ${tabs.length}, contents: ${contents.length}',
       );

  @override
  State<AppTabView> createState() => _AppTabViewState();
}

/// Position of the tab bar.
enum TabBarPosition {
  /// Place at the top.
  top,

  /// Place at the bottom.
  bottom,
}

class _AppTabViewState extends State<AppTabView> {
  late String _selectedTabId;

  @override
  void initState() {
    super.initState();
    _selectedTabId =
        widget.initialSelectedTabId ??
        (widget.tabs.isNotEmpty ? widget.tabs.first.id : '');
  }

  @override
  void didUpdateWidget(AppTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the tab list is changed and the current selection ID is gone, select the first tab.
    if (widget.tabs.isNotEmpty &&
        !widget.tabs.any((tab) => tab.id == _selectedTabId)) {
      setState(() {
        _selectedTabId = widget.tabs.first.id;
      });
    } else if (widget.tabs.isEmpty) {
      setState(() {
        _selectedTabId = '';
      });
    }
  }

  void _handleTabSelected(String tabId) {
    if (_selectedTabId != tabId) {
      setState(() {
        _selectedTabId = tabId;
      });
      widget.onTabSelected?.call(tabId);
    }
  }

  void _handleTabClosed(String tabId) {
    // If the closed tab was selected, select another tab (executed before updating the parent state).
    if (_selectedTabId == tabId && widget.tabs.length > 1) {
      final closedIndex = widget.tabs.indexWhere((tab) => tab.id == tabId);
      final nextIndex =
          closedIndex >= widget.tabs.length - 1
              ? widget.tabs.length -
                  2 // If it is the last tab, the previous tab.
              : closedIndex + 1; // Otherwise, the next tab.
      if (nextIndex >= 0 && nextIndex < widget.tabs.length) {
        final nextTab = widget.tabs[nextIndex];
        if (nextTab.id != tabId) {
          _handleTabSelected(nextTab.id);
        }
      }
    }

    // Notify the parent.
    widget.onTabClosed?.call(tabId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        final zoomScale =
            widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
        final borderScale =
            widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

        // Get the App color scheme using core_themes
        final appColorScheme = ref.watch(effectiveColorSchemeProvider);

        // Build the tab bar
        final tabBar =
            widget.tabBarBuilder?.call(
              context,
              widget.tabs,
              _selectedTabId,
              _handleTabSelected,
              widget.onTabClosed != null ? _handleTabClosed : null,
            ) ??
            AppTabBar(
              tabs: widget.tabs,
              selectedTabId: _selectedTabId,
              onTabSelected: _handleTabSelected,
              onTabClosed: widget.onTabClosed != null ? _handleTabClosed : null,
              height: (widget.tabBarHeight * zoomScale).toDouble(),
              backgroundColor: widget.tabBarBackgroundColor,
              disableZoom: widget.disableZoom,
              alignment: widget.alignment,
            );

        // Get the currently selected content
        Widget? selectedContent;
        for (final content in widget.contents) {
          if (content.id == _selectedTabId) {
            selectedContent = content.content;
            break;
          }
        }

        // Content area
        final contentArea = Container(
          color: widget.contentBackgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              (widget.contentPadding.left * zoomScale).toDouble(),
              (widget.contentPadding.top * zoomScale).toDouble(),
              (widget.contentPadding.right * zoomScale).toDouble(),
              (widget.contentPadding.bottom * zoomScale).toDouble(),
            ),
            child: selectedContent ?? const SizedBox.shrink(),
          ),
        );

        // Divider
        final divider =
            widget.showDivider
                ? Container(
                  height: (widget.dividerThickness * borderScale).toDouble(),
                  color:
                      widget.dividerColor ??
                      appColorScheme.base.divider.withValues(alpha: 0.2),
                )
                : null;

        // Build the layout
        if (widget.tabBarPosition == TabBarPosition.top) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  tabBar,
                  if (divider != null) divider,
                  Expanded(child: contentArea),
                ],
              );
            },
          );
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: contentArea),
                  if (divider != null) divider,
                  tabBar,
                ],
              );
            },
          );
        }
      },
    );
  }
}

/// A widget that provides lazy loading of content.
class AppTabLazyContent extends StatefulWidget {
  /// The content builder.
  final Widget Function(BuildContext context) builder;

  /// The widget to display on initial load.
  final Widget? placeholder;

  const AppTabLazyContent({super.key, required this.builder, this.placeholder});

  @override
  State<AppTabLazyContent> createState() => _AppTabLazyContentState();
}

class _AppTabLazyContentState extends State<AppTabLazyContent> {
  bool _isBuilt = false;
  Widget? _content;

  @override
  void initState() {
    super.initState();
    // Build the content in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _content = widget.builder(context);
          _isBuilt = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isBuilt && _content != null) {
      return _content!;
    }
    return widget.placeholder ??
        const Center(child: CircularProgressIndicator());
  }
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './master_detail_state.dart';
import '../widgets/app_divider.dart';

/// Signature for building master items
typedef MasterItemBuilder =
    Widget Function(
      BuildContext context,
      String itemId,
      bool isSelected,
      VoidCallback onSelect,
    );

/// A layout widget that implements the master-detail pattern with Riverpod integration
class MasterDetailLayout extends ConsumerWidget {
  const MasterDetailLayout({
    required this.items,
    required this.masterItemBuilder,
    required this.detailBuilder,
    this.initialMasterWidth = 280,
    this.minMasterWidth = 200,
    this.maxMasterWidth = 400,
    this.breakpoint = 600,
    this.showDetailOnInit = false,
    this.initialSelectedId,
    this.dividerColor,
    this.masterBackgroundColor,
    this.detailBackgroundColor,
    this.resizeBarColor,
    this.resizeBarWidth = 2.0,
    this.masterPadding = const EdgeInsets.only(top: 20.0, right: 20.0),
    this.detailPadding = const EdgeInsets.only(top: 20.0, right: 20.0),
    super.key,
  });

  /// List of item IDs to display in master view
  final List<String> items;

  /// Builder for individual items in master view
  final MasterItemBuilder masterItemBuilder;

  /// Builder for the detail view
  final Widget Function(
    BuildContext context,
    String? selectedId,
    VoidCallback showMaster,
  )
  detailBuilder;

  /// Initial width of master view in desktop mode
  final double initialMasterWidth;

  /// Minimum width of master view when resizing
  final double minMasterWidth;

  /// Maximum width of master view when resizing
  final double maxMasterWidth;

  /// Breakpoint width for responsive layout
  final double breakpoint;

  /// Whether to show detail on init in mobile mode
  final bool showDetailOnInit;

  /// Color of divider between views
  final Color? dividerColor;

  /// Background colors
  final Color? masterBackgroundColor;
  final Color? detailBackgroundColor;

  /// Color of the resize bar
  final Color? resizeBarColor;

  /// Width of the resize bar
  final double resizeBarWidth;

  /// Padding for the master view
  final EdgeInsetsGeometry masterPadding;

  /// Padding for the detail view
  final EdgeInsetsGeometry detailPadding;

  /// Initial selected item ID
  final String? initialSelectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Set initial selected item
    final selectedId = ref.watch(selectedItemProvider);
    final masterWidth = ref.watch(masterWidthProvider);
    final isDetailVisible = ref.watch(detailVisibilityProvider);

    // Set initial selected item (if selectedId is null and initialSelectedId is specified)
    if (selectedId == null && initialSelectedId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(selectedItemProvider.notifier)
            .setSelectedId(initialSelectedId);
      });
    }

    // Set initial visibility
    if (ref.read(detailVisibilityProvider) != showDetailOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(detailVisibilityProvider.notifier)
            .setVisible(showDetailOnInit);
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > breakpoint;

        // Build master view
        Widget buildMasterView(bool showingDetail) {
          return Padding(
            padding: masterPadding,
            child: ListView.builder(
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemId = items[index];
                return masterItemBuilder(
                  context,
                  itemId,
                  itemId == selectedId,
                  () {
                    ref
                        .read(selectedItemProvider.notifier)
                        .setSelectedId(itemId);
                    // In mobile mode, show detail view when item is selected
                    if (!isDesktop) {
                      ref
                          .read(detailVisibilityProvider.notifier)
                          .setVisible(true);
                    }
                  },
                );
              },
            ),
          );
        }

        // Desktop layout: side by side
        if (isDesktop) {
          return Row(
            children: [
              Container(
                width: masterWidth,
                color: masterBackgroundColor,
                child: buildMasterView(true),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final newWidth = masterWidth + details.delta.dx;
                    if (newWidth >= minMasterWidth &&
                        newWidth <= maxMasterWidth) {
                      ref.read(masterWidthProvider.notifier).setWidth(newWidth);
                    }
                  },
                  child: Container(
                    width: resizeBarWidth + 8.0, // Extend tappable area
                    height: double.infinity,
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: SizedBox(
                      width: resizeBarWidth,
                      height: double.infinity,
                      child: AppVerticalDivider(
                        thickness: resizeBarWidth,
                        color: resizeBarColor ?? dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: detailBackgroundColor,
                  child: Padding(
                    padding: detailPadding,
                    child: detailBuilder(
                      context,
                      selectedId,
                      () => ref
                          .read(detailVisibilityProvider.notifier)
                          .setVisible(false),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Mobile layout: stack with navigation
        return isDetailVisible
            ? Padding(
              padding: detailPadding,
              child: detailBuilder(
                context,
                selectedId,
                () => ref
                    .read(detailVisibilityProvider.notifier)
                    .setVisible(false),
              ),
            )
            : buildMasterView(false);
      },
    );
  }
}

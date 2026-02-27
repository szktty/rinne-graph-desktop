/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:app/app.dart';
import 'package:features_metadata_editor/metadata_editor.dart'
    as metadata_editor;

import '../graph_navigator_sidebar.dart';

/// Sidebar builder (primary/secondary display and control)
class SidebarBuilder {
  const SidebarBuilder._();

  static Widget buildPrimary(AppActivityItemType selectedType) {
    Widget sidebarContent;
    switch (selectedType) {
      case AppActivityItemType.lens:
        sidebarContent = const GraphNavigatorSidebarContent();
        break;
      case AppActivityItemType.labelList:
        sidebarContent = const metadata_editor.LabelListSidebar();
        break;
      case AppActivityItemType.stackSwitcher:
        // Empty sidebar when switching stacks
        sidebarContent = const SizedBox.shrink();
        break;
      default:
        sidebarContent = const _UnimplementedSidebarPlaceholder();
    }
    return Sidebar(child: sidebarContent);
  }

  static Widget buildSecondary(AppActivityItemType selectedType) {
    switch (selectedType) {
      case AppActivityItemType.labelList:
        // In the label list screen, display the editor according to the selected label
        return Consumer(
          builder: (context, ref, child) {
            final selectedLabel = ref.watch(
              metadata_editor.selectedLabelForEditProvider,
            );
            if (selectedLabel != null) {
              return const Sidebar(child: metadata_editor.LabelEditorSidebar());
            }
            return const SizedBox.shrink();
          },
        );
      default:
        // For other screens, use standard DetailsPane
        return const DetailsPane();
    }
  }

  static bool shouldShowPrimary(
    AppActivityItemType selectedType,
    bool isPrimarySidebarVisible,
  ) {
    switch (selectedType) {
      case AppActivityItemType.stackSwitcher:
        // Hide primary sidebar when switching stacks
        return false;
      default:
        return isPrimarySidebarVisible;
    }
  }

  static bool shouldShowSecondary(
    AppActivityItemType selectedType,
    bool isSecondarySidebarVisible,
  ) {
    switch (selectedType) {
      case AppActivityItemType.labelList:
        // In the label list screen, display only if a label is selected
        return isSecondarySidebarVisible;
      case AppActivityItemType.stackSwitcher:
        // Hide secondary sidebar when switching stacks
        return false;
      default:
        return isSecondarySidebarVisible;
    }
  }
}

class _UnimplementedSidebarPlaceholder extends ConsumerWidget {
  const _UnimplementedSidebarPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedActivityItemProvider);
    return Center(
      child: AppText(
        '${selectedType.label} Sidebar (unimplemented)',
        variant: AppTextVariant.bodyText,
      ),
    );
  }
}

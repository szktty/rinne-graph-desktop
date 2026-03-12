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

import '../../screens/graph_editor_screen.dart';

/// Main content area builder
class ContentBuilder {
  const ContentBuilder._();

  static Widget buildContent(WidgetRef ref, int selectedActivityIndex) {
    final selectedActivityType = ref.watch(selectedActivityItemProvider);

    switch (selectedActivityType) {
      case AppActivityItemType.lens:
        return const GraphEditorScreen();
      case AppActivityItemType.labelList:
        return const metadata_editor.LabelListScreen();
      case AppActivityItemType.propertyList:
        return FondeMainContentArea(
          child: Center(
            child: AppText(
              'Property List Screen (unimplemented)',
              variant: AppTextVariant.textBody,
            ),
          ),
        );
      case AppActivityItemType.stackSwitcher:
        // stackSwitcher is dialog-based, show graph view as the main content
        return const GraphEditorScreen();
      case AppActivityItemType.settings:
        return FondeMainContentArea(
          child: Center(
            child: AppText(
              'Settings Screen (unimplemented)',
              variant: AppTextVariant.textBody,
            ),
          ),
        );
    }
  }
}

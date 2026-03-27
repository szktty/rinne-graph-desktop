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
import 'package:features_record_editor/record_editor.dart';

import '../typography/app_text.dart';

/// Details pane displayed in the secondary sidebar.
///
/// Displays and edits (in the future) detailed information of the selected
/// graph entity.
class DetailsPane extends ConsumerWidget {
  /// Create a details pane.
  const DetailsPane({super.key, this.disableZoom = false});

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Record rebuild start
    debugPrint('[DetailsPane] ===== REBUILD START =====');

    // Watch the selected entity
    final selectedEntity = ref.watch(selectedEntityForEditorProvider);
    debugPrint('[DetailsPane] Selected entity: ${selectedEntity?.id}');
    debugPrint('[DetailsPane] Entity type: ${selectedEntity?.runtimeType}');
    debugPrint('[DetailsPane] Entity is null: ${selectedEntity == null}');

    // If there is a selected entity, set it to activeEntityProvider
    if (selectedEntity != null) {
      debugPrint('[DetailsPane] ✅ Setting active entity: ${selectedEntity.id}');
      // Update activeEntityProvider in the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(activeEntityProvider.notifier).setEntity(selectedEntity);
        debugPrint('[DetailsPane] ✅ Active entity set in post frame callback');
      });
    } else {
      debugPrint('[DetailsPane] ❌ No entity selected - showing placeholder');
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: appColorScheme.base.divider, width: 1.0),
        ),
        color: appColorScheme.base.background,
      ),
      child:
          selectedEntity != null
              ? const TabbedRecordEditor()
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppText(
                    'Select a node or link on the graph to see details here.',
                    variant: AppTextVariant.bodyText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
    );
  }
}

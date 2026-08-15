/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:features_import_export/features_import_export.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/entity_deletion_providers.dart';
import '../providers/graph_providers.dart';

/// A class that provides implementations for menu actions
class MenuActions {
  /// Deletes whatever is selected in the graph, asking first when the deletion
  /// would take more than the selected entity with it.
  ///
  /// A node drags its links along — the storage cascades — so deleting one is
  /// confirmed whenever it has any. An isolated node, and any link, is deleted
  /// on the spot: the confirmation would cost more than the mistake it saves,
  /// and re-drawing a single link is cheap.
  static Future<void> deleteSelectedEntity(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final selectedId = ref.read(selectedGraphEntityIdProvider);
    if (selectedId == null) {
      FondeSnackBar.showInfo(
        context: context,
        message: '削除するノードまたはリンクを選択してください',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final actions = ref.read(entityDeletionActionsProvider);
    final target = actions.describe(selectedId);
    if (target == null) {
      // The selection outlived the entity — nothing to delete.
      return;
    }

    if (target.cascades) {
      final confirmed = await showFondeConfirmationDialog(
        context,
        message: '「${target.displayName}」を削除しますか？',
        warningItems: [
          '接続している ${target.connectedLinkCount} 本のリンクも削除されます',
          // Dropped once undo covers deletion; until then this is simply true.
          'この操作は取り消せません',
        ],
        cancelLabel: 'キャンセル',
        confirmLabel: '削除',
        isDestructive: true,
      );
      if (confirmed != true) return;
    }

    await actions.delete(target);
  }

  /// Displays the new stack creation dialog
  static void showCreateStackDialog(BuildContext context) {
    FondeSnackBar.showInfo(
      context: context,
      message: 'Please create a new stack in the stack collection screen',
      duration: const Duration(seconds: 2),
    );
  }

  /// Creates a sample stack
  static void createSampleStack(BuildContext context) async {
    FondeSnackBar.showInfo(
      context: context,
      message: 'Sample stack creation feature is under development',
      duration: const Duration(seconds: 2),
    );
  }

  /// Closes the active stack
  static void closeActiveStack(BuildContext context) {
    FondeSnackBar.showInfo(
      context: context,
      message: 'Closing stack feature is under development',
      duration: const Duration(seconds: 2),
    );
  }

  /// Imports a spreadsheet or CSV file.
  ///
  /// The whole flow — file picker, destination, progress, result — already
  /// lived in [CsvImportIntegration]; this is the call that was missing.
  static void handleCsvImport(BuildContext context, WidgetRef ref) {
    CsvImportIntegration.handleCsvImport(
      context,
      ProviderScope.containerOf(context, listen: false),
    );
  }

  /// Undo operation
  static void performUndo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Undo feature is under development'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Redo operation
  static void performRedo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redo feature is under development'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Cut operation
  static void performCut(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cut feature is under development'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Copy operation
  static void performCopy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copy feature is under development'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Paste operation
  static void performPaste(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paste feature is under development'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Select All operation
  static void performSelectAll(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Select All feature is under development'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

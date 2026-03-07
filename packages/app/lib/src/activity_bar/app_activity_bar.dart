/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:features_settings/features_settings.dart';
import 'package:features_welcome/features_welcome.dart';

import 'app_activity_item_type.dart';

/// Provider that manages the currently selected activity item
final selectedActivityItemProvider = StateProvider<AppActivityItemType>(
  (ref) => AppActivityItemType.lens,
);

/// Application-specific launch bar (activity bar)
class AppActivityBar extends ConsumerWidget {
  const AppActivityBar({super.key});

  /// Displays the settings screen as a dialog
  Future<void> _showSettingsDialog(BuildContext context) async {
    try {
      await showSettingsDialog(context);
      debugPrint('Settings dialog displayed');
    } catch (e) {
      debugPrint('Failed to display settings dialog: $e');
    }
  }

  /// Displays the welcome screen as a dialog (for stack switching)
  Future<void> _showWelcomeDialog(BuildContext context) async {
    try {
      debugPrint('Welcome dialog displayed');
    } catch (e) {
      debugPrint('Failed to display welcome dialog: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedActivityItemProvider);

    return FondeLaunchBar(
      selectedIndex: selectedType.index,
      topItems:
          AppActivityItemType.values
              .where((type) => type.isMainItem)
              .map(
                (type) => type.toLaunchBarItem(
                  logicalIndex: type.index,
                  onTap:
                      () =>
                          ref
                              .read(selectedActivityItemProvider.notifier)
                              .state = type,
                ),
              )
              .toList(),
      bottomItems:
          AppActivityItemType.values
              .where((type) => !type.isMainItem)
              .map(
                (type) => type.toLaunchBarItem(
                  logicalIndex: type.index,
                  onTap: () {
                    if (type == AppActivityItemType.settings) {
                      _showSettingsDialog(context);
                    } else if (type == AppActivityItemType.stackSwitcher) {
                      _showWelcomeDialog(context);
                    } else {
                      ref.read(selectedActivityItemProvider.notifier).state =
                          type;
                    }
                  },
                ),
              )
              .toList(),
    );
  }
}

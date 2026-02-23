import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:features_settings/features_settings.dart';
import 'package:features_welcome/features_welcome.dart';

import 'app_activity_item_type.dart';

/// Provider that manages the currently selected activity item
final selectedActivityItemProvider = StateProvider<AppActivityItemType>(
  (ref) => AppActivityItemType.lens,
);

/// Application-specific activity bar
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
      // showWelcomeDialog(
      //   context,
      //   showCloseButton: true,
      // );
      debugPrint('Welcome dialog displayed');
    } catch (e) {
      debugPrint('Failed to display welcome dialog: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedActivityItemProvider);

    return ActivityBar(
      selectedIndex: selectedType.index,
      topItems:
          AppActivityItemType.values
              .where((type) => type.isMainItem)
              .map(
                (type) => type.toActivityBarItem(
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
                (type) => type.toActivityBarItem(
                  logicalIndex: type.index,
                  onTap: () {
                    if (type == AppActivityItemType.settings) {
                      // 設定画面をダイアログとして表示
                      _showSettingsDialog(context);
                    } else if (type == AppActivityItemType.stackSwitcher) {
                      // ウェルカム画面をダイアログとして表示
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

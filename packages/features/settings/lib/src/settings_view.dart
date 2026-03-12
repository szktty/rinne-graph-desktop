/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:features_settings/src/widgets/settings_panel.dart';
import 'package:features_settings/src/widgets/settings_screens/appearance_settings_view.dart';
// Keyboard shortcut customization feature to be implemented in the future
import 'package:features_settings/src/widgets/settings_screens/accessibility_settings_view.dart';
import 'package:features_settings/src/widgets/settings_screens/metadata_management_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

import 'models/settings_item.dart';

/// Main view of the settings screen.
/// This component can be used standalone or wrapped with [SettingsWindow]
/// to display as a window.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsPanel(
      items: _defaultSettingsItems,
      initialSelectedId: 'appearance', // Select appearance menu by default
      searchable: false,
      emptySelectionBuilder:
          (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FondeIcons.settings, size: 48, color: Colors.black38),
                const SizedBox(height: 16),
                FondeBodyText('Select a setting item from the left menu'),
              ],
            ),
          ),
    );
  }

  /// Default settings item list.
  static final List<SettingsItem> _defaultSettingsItems = [
    SettingsItem(
      id: 'appearance',
      icon: FondeIcons.appearance,
      title: 'Appearance',
      builder: () => const AppearanceSettingsView(),
      keywords: const [
        'Appearance',
        'Theme',
        'Appearance',
        'Color',
        'Light',
        'Dark',
        'System',
        'Theme Color',
        'Accent',
        'Animation',
        'Motion',
        'Effects',
      ],
    ),

    SettingsItem(
      id: 'metadata-management',
      icon: FondeIcons.tag,
      title: 'Metadata Management',
      builder: () => const MetadataManagementView(),
      keywords: const [
        'メタデータ',
        'metadata',
        'ラベル',
        'label',
        'Property',
        'property',
        'Property Type',
        'property type',
        'Data Management',
        'data management',
      ],
    ),

    // Keyboard shortcut customization feature to be implemented in the future
    // SettingsItem(
    //   id: 'keyboard-shortcuts',
    //   icon: FondeIcons.keyboard,
    //   title: 'Keyboard Shortcuts',
    //   builder: () => const AdvancedKeyboardShortcutsView(),
    //   keywords: const [
    //     'Keyboard',
    //     'Shortcut',
    //     'Key',
    //     'Hotkey',
    //     'Command',
    //     'Keybind',
    //     'Keymap',
    //     'keyboard',
    //     'shortcut',
    //     'hotkey',
    //   ],
    // ),
    SettingsItem(
      id: 'accessibility',
      icon: FondeIcons.accessibility,
      title: 'Accessibility',
      builder: () => const AccessibilitySettingsView(),
      keywords: const [
        'Accessibility',
        'accessibility',
        'Zoom',
        'zoom',
        'Font Size',
        'font',
        'Contrast',
        'contrast',
        'Barrier-free',
      ],
    ),
  ];
}

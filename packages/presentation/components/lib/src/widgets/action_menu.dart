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
import '../icons/app_icons.dart';

/// Represents an item in an action menu.
///
/// Holds a label, a callback, and a flag for dangerous operations.
class ActionMenuItem {
  final String label;
  final VoidCallback onPressed;
  final bool isDangerous;

  const ActionMenuItem({
    required this.label,
    required this.onPressed,
    this.isDangerous = false,
  });
}

/// An action menu widget that displays a context menu.
///
/// Displays multiple action items as a vertical menu.
/// Dangerous operations are displayed in red.
class ActionMenu extends ConsumerWidget {
  final List<ActionMenuItem> items;

  const ActionMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(AppIcons.moreVert),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren:
          items
              .map(
                (item) => MenuItemButton(
                  onPressed: item.onPressed,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color:
                          item.isDangerous ? appColorScheme.status.error : null,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

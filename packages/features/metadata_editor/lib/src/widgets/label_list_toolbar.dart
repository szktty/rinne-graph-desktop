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
import 'package:core_themes/core_themes.dart';

import '../providers/label_list_providers.dart';

/// Toolbar for the label list.
class LabelListToolbar extends ConsumerWidget {
  const LabelListToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(labelSearchQueryProvider);
    final sortMethod = ref.watch(labelSortMethodProvider);
    final appColorScheme = ref.watch(appColorSchemeProvider);

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.panel.background,
        border: Border(
          bottom: BorderSide(color: appColorScheme.base.divider, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            // Add button
            AppButton(
              label: 'Add',
              leadingIcon: Icon(AppIcons.plus),
              onPressed: () {
                _showAddLabelDialog(context, ref);
              },
            ),

            const SizedBox(width: 16),

            // Sort menu button
            AppDropdownMenu<LabelSortMethod>(
              initialSelection: sortMethod,
              dropdownMenuEntries:
                  LabelSortMethod.values.map((method) {
                    return DropdownMenuEntry(
                      value: method,
                      label: method.label,
                    );
                  }).toList(),
              onSelected: (LabelSortMethod? newMethod) {
                if (newMethod != null) {
                  ref.read(labelSortMethodProvider.notifier).state = newMethod;
                }
              },
              hintText: 'Sort',
            ),

            const Spacer(),

            // Search field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: AppTextField(
                  controller: TextEditingController(text: searchQuery),
                  hintText: 'Search labels...',
                  prefixIcon: Icon(AppIcons.search),
                  onChanged: (String value) {
                    ref.read(labelSearchQueryProvider.notifier).state = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLabelDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement add label dialog
    debugPrint('Display add label dialog');

    // Temporary implementation: Notify with a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Label adding feature is not yet implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

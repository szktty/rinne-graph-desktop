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
import 'package:presentation_components/presentation_components.dart';

import '../providers/filter_providers.dart';
import 'filter_dialog.dart';

/// Filter toolbar widget
///
/// Provides filter functionality including a search field and a button to open the dialog
class FilterToolbar extends ConsumerWidget {
  const FilterToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = accessibilityConfig.zoomScale;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field (editable without opening a dialog)
        SizedBox(
          width: 200 * zoomScale,
          height: 32,
          child: _FilterSearchField(),
        ),

        SizedBox(width: 8 * zoomScale),

        // Button to open filter dialog
        _FilterDialogButton(),
      ],
    );
  }
}

/// Filter search field
class _FilterSearchField extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FilterSearchField> createState() => _FilterSearchFieldState();
}

class _FilterSearchFieldState extends ConsumerState<_FilterSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterStateProvider);
    final filterNotifier = ref.read(filterStateProvider.notifier);

    // Sync controller text with state
    if (_controller.text != filterState.searchQuery) {
      _controller.text = filterState.searchQuery;
    }

    return FondeTextField(
      controller: _controller,
      hintText: 'Filter...',
      prefixIcon: const Icon(Icons.search, size: 18),
      onChanged: (value) {
        filterNotifier.updateSearchQuery(value);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      radius: 12.0,
      borderWidth: 1.5,
    );
  }
}

/// Button to open filter dialog
class _FilterDialogButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = accessibilityConfig.zoomScale;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        icon: Icon(
          Icons.filter_list,
          size: 18 * zoomScale,
          color: appColorScheme.base.foreground,
        ),
        tooltip: 'Filter settings',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const FilterDialog(),
          );
        },
        padding: EdgeInsets.zero,
        splashRadius: 16,
      ),
    );
  }
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:presentation_components/presentation_components.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';

/// Sentinel value representing "All Languages" (no filter).
const _allLanguagesValue = '';

/// Language filter dropdown for the welcome screen stack grid.
///
/// Dynamically builds language options from the available stack list,
/// and filters stacks by the selected language.
class WelcomeLanguageFilterDropdown extends ConsumerWidget {
  /// The stacks to derive language options from.
  final List<core_stack.Stack> stacks;

  const WelcomeLanguageFilterDropdown({
    required this.stacks,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(welcomeLanguageFilterProvider);

    // Collect unique languages from stacks
    final languageCodes = <String>{};
    var hasUnspecified = false;
    for (final stack in stacks) {
      final lang = stack.info.language;
      if (lang != null && lang.isNotEmpty) {
        languageCodes.add(lang);
      } else {
        hasUnspecified = true;
      }
    }

    // If there are no language variations, don't show the dropdown
    if (languageCodes.isEmpty && !hasUnspecified) {
      return const SizedBox.shrink();
    }
    if (languageCodes.length <= 1 && !hasUnspecified) {
      return const SizedBox.shrink();
    }

    final sortedLanguages = languageCodes.toList()..sort();

    // Build dropdown menu entries
    final entries = <DropdownMenuEntry<String>>[
      DropdownMenuEntry<String>(
        value: _allLanguagesValue,
        label: _getAllLabel(context),
      ),
      if (hasUnspecified)
        DropdownMenuEntry<String>(
          value: welcomeLanguageFilterUnspecified,
          label: _getUnspecifiedLabel(context),
        ),
      ...sortedLanguages.map(
        (code) => DropdownMenuEntry<String>(
          value: code,
          label: _getLanguageName(context, code),
        ),
      ),
    ];

    return AppDropdownMenu<String>(
      initialSelection: currentFilter ?? _allLanguagesValue,
      dropdownMenuEntries: entries,
      position: AppDropdownMenuPosition.below,
      onSelected: (value) {
        if (value == null || value.isEmpty) {
          ref.read(welcomeLanguageFilterProvider.notifier).setFilter(null);
        } else {
          ref.read(welcomeLanguageFilterProvider.notifier).setFilter(value);
        }
      },
    );
  }

  /// Get the "All Languages" label.
  String _getAllLabel(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ja' ? 'すべての言語' : 'All Languages';
  }

  /// Get the "Unspecified" label.
  String _getUnspecifiedLabel(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ja' ? '未指定' : 'Unspecified';
  }

  /// Get a localized language name from its ISO 639-1 code.
  String _getLanguageName(BuildContext context, String code) {
    final locale = Localizations.localeOf(context);
    final isJa = locale.languageCode == 'ja';

    switch (code) {
      case 'en':
        return isJa ? '英語' : 'English';
      case 'ja':
        return isJa ? '日本語' : 'Japanese';
      default:
        return code;
    }
  }
}

/// Filters a list of stacks based on the current language filter value.
List<core_stack.Stack> filterStacksByLanguage(
  List<core_stack.Stack> stacks,
  String? languageFilter,
) {
  if (languageFilter == null) {
    return stacks;
  }

  if (languageFilter == welcomeLanguageFilterUnspecified) {
    return stacks
        .where((s) => s.info.language == null || s.info.language!.isEmpty)
        .toList();
  }

  return stacks.where((s) => s.info.language == languageFilter).toList();
}

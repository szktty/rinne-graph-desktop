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
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:core_settings/core_settings.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

part 'welcome_providers.g.dart';

/// Provider that manages the display settings for the welcome page.
@riverpod
class ShowWelcomeScreen extends _$ShowWelcomeScreen {
  @override
  bool build() {
    // Display welcome screen by default
    _loadSettings();
    return true;
  }

  /// Loads settings asynchronously.
  void _loadSettings() async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      final value = await storageService.getBool('showWelcomeScreen');

      if (value != null) {
        debugPrint('Welcome settings loaded: $value');
        state = value;
      } else {
        debugPrint('Welcome settings do not exist, using default values');
      }
    } catch (e) {
      debugPrint('Error loading welcome settings: $e');
    }
  }

  /// Updates and saves settings.
  void setShowWelcome(bool value) {
    state = value;
    _saveSettings(value);
  }

  /// Saves settings.
  void _saveSettings(bool value) async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      await storageService.setBool('showWelcomeScreen', value);
      debugPrint('Welcome settings saved: $value');
    } catch (e) {
      debugPrint('Error saving welcome settings: $e');
    }
  }
}

/// Provider that manages the stack selected on the welcome screen.
@riverpod
class SelectedWelcomeStack extends _$SelectedWelcomeStack {
  @override
  core_stack.Stack? build() => null;

  void selectStack(core_stack.Stack? stack) {
    state = stack;
  }

  void clearSelection() {
    state = null;
  }
}

/// Provider that manages the stack display mode.
final stackDisplayModeProvider = StateProvider<StackDisplayModeType>(
  (ref) => StackDisplayModeType.active,
);

/// Types of stack display modes.
enum StackDisplayModeType {
  /// Display active stacks only.
  active,

  /// Display archived stacks only.
  archived,

  /// Display sample stack templates only.
  sampleTemplate,
}

/// Provider that manages the archived state of asset-based stacks.
final assetStackArchiveStateProvider = StateProvider<Map<String, bool>>(
  (ref) => {},
);

/// Sentinel value for "unspecified language" filter option.
const welcomeLanguageFilterUnspecified = '__unspecified__';

/// Provider that manages the language filter for the welcome screen.
///
/// - `null` = show all languages (no filter)
/// - `'__unspecified__'` = show only stacks with no language set
/// - any ISO 639-1 code (e.g. `'en'`, `'ja'`) = show only that language
@riverpod
class WelcomeLanguageFilter extends _$WelcomeLanguageFilter {
  @override
  String? build() {
    _loadSettings();
    return null;
  }

  void _loadSettings() async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      final value = await storageService.getString('welcomeLanguageFilter');
      if (value != null) {
        state = value;
      }
    } catch (e) {
      debugPrint('Error loading language filter settings: $e');
    }
  }

  void setFilter(String? value) {
    state = value;
    _saveSettings(value);
  }

  void _saveSettings(String? value) async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      if (value == null) {
        await storageService.remove('welcomeLanguageFilter');
      } else {
        await storageService.setString('welcomeLanguageFilter', value);
      }
    } catch (e) {
      debugPrint('Error saving language filter settings: $e');
    }
  }
}

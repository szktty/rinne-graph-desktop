import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Data for aggregating and managing temporary flag states within the Shell
class ShellStateData {
  final bool commandsRegistered;
  final bool screenshotServerStarted;
  final bool devStacksImported;
  final bool remoteCommandServerStarted;
  // Display state of important dialog (with optional tag)
  final bool importantDialogOpen;
  final String? importantDialogTag;

  const ShellStateData({
    this.commandsRegistered = false,
    this.screenshotServerStarted = false,
    this.devStacksImported = false,
    this.remoteCommandServerStarted = false,
    this.importantDialogOpen = false,
    this.importantDialogTag,
  });

  ShellStateData copyWith({
    bool? commandsRegistered,
    bool? screenshotServerStarted,
    bool? devStacksImported,
    bool? remoteCommandServerStarted,
    bool? importantDialogOpen,
    String? importantDialogTag,
  }) {
    return ShellStateData(
      commandsRegistered: commandsRegistered ?? this.commandsRegistered,
      screenshotServerStarted:
          screenshotServerStarted ?? this.screenshotServerStarted,
      devStacksImported: devStacksImported ?? this.devStacksImported,
      remoteCommandServerStarted:
          remoteCommandServerStarted ?? this.remoteCommandServerStarted,
      importantDialogOpen: importantDialogOpen ?? this.importantDialogOpen,
      importantDialogTag: importantDialogTag ?? this.importantDialogTag,
    );
  }
}

/// StateNotifier + Provider for aggregating and managing flags within the Shell
class ShellStateManager extends StateNotifier<ShellStateData> {
  ShellStateManager() : super(const ShellStateData());

  void markCommandsRegistered() {
    if (!state.commandsRegistered) {
      state = state.copyWith(commandsRegistered: true);
    }
  }

  void markScreenshotServerStarted() {
    if (!state.screenshotServerStarted) {
      state = state.copyWith(screenshotServerStarted: true);
    }
  }

  void markDevStacksImported() {
    if (!state.devStacksImported) {
      state = state.copyWith(devStacksImported: true);
    }
  }

  void markRemoteCommandServerStarted() {
    if (!state.remoteCommandServerStarted) {
      state = state.copyWith(remoteCommandServerStarted: true);
    }
  }

  void markImportantDialogOpened(String tag) {
    state = state.copyWith(importantDialogOpen: true, importantDialogTag: tag);
  }

  void markImportantDialogClosed() {
    state = state.copyWith(
      importantDialogOpen: false,
      importantDialogTag: null,
    );
  }
}

final shellStateManagerProvider =
    StateNotifierProvider<ShellStateManager, ShellStateData>(
      (ref) => ShellStateManager(),
    );

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider that manages the width of the sidebar.
class SidebarWidthNotifier extends StateNotifier<double> {
  SidebarWidthNotifier() : super(320.0); // Default width

  /// Sets the width of the sidebar.
  void setWidth(double width) {
    // Limit minimum and maximum width
    const minWidth = 240.0;
    const maxWidth = 480.0;

    final clampedWidth = width.clamp(minWidth, maxWidth);
    if (state != clampedWidth) {
      state = clampedWidth;
    }
  }

  /// Changes the width of the sidebar relatively.
  void adjustWidth(double delta) {
    setWidth(state + delta);
  }
}

/// Primary sidebar width provider.
final sidebarWidthProvider =
    StateNotifierProvider<SidebarWidthNotifier, double>(
      (ref) => SidebarWidthNotifier(),
    );

/// Provider that manages the width of the secondary sidebar.
class SecondarySidebarWidthNotifier extends StateNotifier<double> {
  SecondarySidebarWidthNotifier() : super(288.0); // Default width

  /// Sets the width of the secondary sidebar.
  void setWidth(double width) {
    // Limit minimum and maximum width
    const minWidth = 200.0;
    const maxWidth = 400.0;

    final clampedWidth = width.clamp(minWidth, maxWidth);
    if (state != clampedWidth) {
      state = clampedWidth;
    }
  }

  /// Changes the width of the secondary sidebar relatively.
  void adjustWidth(double delta) {
    setWidth(state + delta);
  }
}

/// Secondary sidebar width provider.
final secondarySidebarWidthProvider =
    StateNotifierProvider<SecondarySidebarWidthNotifier, double>(
      (ref) => SecondarySidebarWidthNotifier(),
    );

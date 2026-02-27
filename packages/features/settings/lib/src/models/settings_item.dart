/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/widgets.dart';

/// A model representing a settings item.
class SettingsItem {
  const SettingsItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.builder,
    required this.keywords,
    this.badge,
  });

  /// The unique ID of the settings item.
  final String id;

  /// The icon for the settings item.
  final IconData icon;

  /// The title of the settings item.
  final String title;

  /// A function that builds the detail screen for the settings item.
  final Widget Function() builder;

  /// Keywords used for searching.
  final List<String> keywords;

  /// Optional badge (e.g., for displaying new features).
  final Widget? badge;
}

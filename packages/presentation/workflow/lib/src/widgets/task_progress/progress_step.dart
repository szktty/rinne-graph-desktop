/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Definition of progress step
class ProgressStep {
  /// Constructor
  const ProgressStep({
    required this.range,
    this.animationDuration = const Duration(milliseconds: 500),
    this.label,
  });

  /// Progress range (start and end percentage)
  final (double, double) range;

  /// Animation duration
  final Duration animationDuration;

  /// Optional label
  final String? label;
}

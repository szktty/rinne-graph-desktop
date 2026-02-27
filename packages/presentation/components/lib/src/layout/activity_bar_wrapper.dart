/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';

/// Wrapper widget for the activity bar.
///
/// Applies a fixed width constraint to the activity bar and supports zoom scaling.
class ActivityBarWrapper extends StatelessWidget {
  const ActivityBarWrapper({
    required this.child,
    this.zoomScale = 1.0,
    this.width = 44.0,
    super.key,
  });

  /// The widget for the activity bar.
  final Widget child;

  /// The zoom scale.
  final double zoomScale;

  /// The width of the activity bar (default: 44px).
  final double width;

  @override
  Widget build(BuildContext context) {
    final scaledWidth = width * zoomScale;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: scaledWidth, maxWidth: scaledWidth),
      child: child,
    );
  }
}

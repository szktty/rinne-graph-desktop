/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import '../identifiable_widget/identifiable_widget.dart';

/// A basic interface for identifying navigation elements.
///
/// Navigation-related widgets are expected to implement this interface and have
/// a unique ID.
abstract class IdentifiableNavigationItem extends IdentifiableWidget {
  /// Creates a new [IdentifiableNavigationItem].
  ///
  /// [id] - The unique identifier for the navigation item.
  const IdentifiableNavigationItem({required super.id, super.key});
}

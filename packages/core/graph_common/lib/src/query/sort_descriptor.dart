/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Sort descriptor
class SortDescriptor {
  /// Creates a new sort descriptor
  const SortDescriptor(this.property, {this.ascending = true});

  /// The name of the property to sort by
  final String property;

  /// The direction of the sort (ascending/descending)
  final bool ascending;

  @override
  String toString() {
    return '$property ${ascending ? 'asc' : 'desc'}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SortDescriptor &&
        other.property == property &&
        other.ascending == ascending;
  }

  @override
  int get hashCode => Object.hash(property, ascending);
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Simplified mock GraphContext that is just a placeholder for testing.
///
/// The undo system tests don't actually need a fully functional graph context,
/// they just need something to pass to the commands for testing the undo logic.
class MockGraphContext {
  /// Simple storage for testing.
  final Map<String, dynamic> storage = {};

  /// Track operations for testing.
  final List<String> operations = [];

  void recordOperation(String operation) {
    operations.add(operation);
  }

  void clear() {
    storage.clear();
    operations.clear();
  }
}

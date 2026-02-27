/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'unique_id.dart';

/// Interface for generating IDs
///
/// Generates unique IDs used throughout the application.
/// Implementation classes can provide different generation strategies (UUID, sequential, test, etc.).
abstract interface class IdGenerator {
  /// Generates a new ID
  UniqueId generate();
}

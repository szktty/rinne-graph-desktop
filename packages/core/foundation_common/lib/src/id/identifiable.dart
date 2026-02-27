/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'unique_id.dart';

/// Mixin representing an object with a unique ID
mixin Identifiable {
  /// Object's unique ID
  UniqueId get id;
}

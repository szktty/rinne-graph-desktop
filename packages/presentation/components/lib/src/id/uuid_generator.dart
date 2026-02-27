/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:uuid/uuid.dart';

/// UUID-based ID generator.
class UuidGenerator implements IdGenerator {
  static final _uuid = Uuid();

  @override
  UniqueId generate() {
    return UniqueId.fromString(_uuid.v7());
  }

  /// Generates an ID from a string.
  static UniqueId fromString(String value) {
    return UniqueId.fromString(value);
  }
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueFoundationExtension<T> on AsyncValue<T> {
  T get unwrap {
    return when(
      data: (data) => data,
      loading: () => throw StateError('data is still loading'),
      error: (error, _) => throw StateError('data loading failed: $error'),
    );
  }
}

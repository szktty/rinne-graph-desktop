/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/widgets.dart';
import 'package:app/app.dart';

/// Builder extracted ActivityBar construction logic
/// Currently, it simply delegates and returns the AppActivityBar provided by the app.
class ActivityBarBuilder {
  const ActivityBarBuilder._();

  static Widget buildBar() {
    // Handle additional decorations or wrappers here if needed
    return const AppActivityBar();
  }
}

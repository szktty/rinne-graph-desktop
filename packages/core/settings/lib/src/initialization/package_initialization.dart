/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Class for defining package initialization
class SettingsPackageInitialization {
  const SettingsPackageInitialization({required this.warmUps, this.initialize});

  /// Function that returns list of providers that need warm-up
  final List<AsyncValue<dynamic>> Function(WidgetRef) warmUps;

  /// Processing executed during initialization
  /// This processing is executed after warm-up is complete
  final void Function(WidgetRef)? initialize;
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Core Events package
///
/// This package provides event sourcing functionality for the application.
library;

// src/capsules.dart removed - migrated to providers if needed
export 'src/event.dart';
export 'src/event_bus.dart';
export 'src/event_dispatcher.dart';
export 'src/event_subscriber.dart';
export 'src/signals/signal_event_bus.dart';

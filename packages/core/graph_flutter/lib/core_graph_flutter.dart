/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Core graph database functionality with Flutter integration
///
/// This package provides integrated functionality for using graph database features
/// in Flutter applications.
library;

// Re-export core_graph_common
export 'package:core_graph_common/core_graph_common.dart';

// Export Flutter-specific functionality (Riverpod providers)
export 'src/providers/index.dart';

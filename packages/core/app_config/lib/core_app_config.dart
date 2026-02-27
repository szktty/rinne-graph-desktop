/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Application configuration management package
///
/// Provides a file-based configuration system that allows switching
/// debug mode and startup settings via command-line arguments or environment variables.
library core_app_config;

// Models
export 'src/models/app_config.dart';

// Services
export 'src/services/app_config_loader.dart';

// Providers
export 'src/providers/app_config_providers.dart';

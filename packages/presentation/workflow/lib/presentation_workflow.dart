/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Workflow presentation package for App.
library;

// Widgets
export 'src/widgets/task_progress_modal.dart';
export 'src/widgets/task_panel/movable_task_panel.dart';
export 'src/widgets/task_panel/task_list_view.dart';
export 'src/widgets/movable_panel/movable_panel_container.dart';

// Models
export 'src/models/panel_geometry.dart';

// Providers (Riverpod)
export 'src/providers/task_panel_providers.dart';
export 'src/providers/task_progress_providers.dart';

// Capsules removed - migrated to Riverpod providers

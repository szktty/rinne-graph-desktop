/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Undo/redo system for App graph operations.
///
/// This library provides comprehensive undo/redo functionality for graph database
/// operations.
library;

// Core interfaces and classes
export 'src/commands/undoable_command.dart';
export 'src/core/undo_manager.dart';
export 'src/core/undo_error.dart';

// Command implementations
export 'src/commands/node_commands.dart';
export 'src/commands/link_commands.dart';
export 'src/commands/bulk_commands.dart';

// Models and state
export 'src/models/undo_history_change.dart';
export 'src/models/undo_actions.dart';
export 'src/models/undo_history_state.dart';
export 'src/models/snapshots.dart';

export 'src/integration/actions.dart' hide UndoShortcutsConstants;
export 'src/integration/shortcuts.dart';

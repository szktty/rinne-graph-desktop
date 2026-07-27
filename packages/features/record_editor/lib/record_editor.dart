/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Entry point for the record editor feature
library;

// Exports
//
// Not exported, and unreachable as a result: RecordEditorScreen,
// RecordEditor and the PropertyEditor / CustomReorderableList pair it
// builds on. They are the pre-tab editor, superseded by TabbedRecordEditor.
// The reordering machinery in CustomReorderableList is worth keeping until
// property reordering is either implemented on the new editor or ruled out —
// exporting it only made the rest look reachable.
export 'src/widgets/tabbed_record_editor.dart';
export 'src/widgets/graph_entity_properties_display.dart';

export 'src/providers/record_editor_providers.dart';
export 'src/providers/selected_entity_providers.dart';
export 'src/providers/entity_properties_providers.dart';
export 'src/providers/tab_view_providers.dart';

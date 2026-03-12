/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

import '../widgets/tabbed_record_editor.dart';

/// Record editor screen
class RecordEditorScreen extends ConsumerWidget {
  /// Constructor
  const RecordEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: MainShellLayout(
        toolbar: const SizedBox.shrink(), // Empty toolbar
        content: const Center(
          child: Text(
            'Select a record to view details.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        secondarySidebar: const TabbedRecordEditor(),
        showSecondarySidebar: true,
      ),
    );
  }
}

/// Record editor activity bar item
class RecordEditorFondeLaunchBarItem extends FondeLaunchBarItem {
  /// Constructor
  RecordEditorFondeLaunchBarItem({
    required VoidCallback onTap,
    required super.logicalIndex,
  }) : super(icon: Icons.edit_note, label: 'Record Editor', onTap: onTap);
}

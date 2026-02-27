/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/label_list_toolbar.dart';
import '../widgets/label_table_view.dart';

/// Label list screen
/// Used as content for AppShell
class LabelListScreen extends ConsumerWidget {
  const LabelListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Toolbar
        const LabelListToolbar(),

        // Main content
        const Expanded(child: LabelTableView()),
      ],
    );
  }
}

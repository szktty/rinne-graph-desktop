/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

import '../providers/graph_filter_providers.dart';

/// The sidebar tab that decides which labels and link types are drawn.
///
/// Unticking a label removes those nodes from the graph and the table rather
/// than fading them: when the question is "what do the classes look like", the
/// characters are not context, they are in the way.
class GraphFilterTabContent extends ConsumerWidget {
  const GraphFilterTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(graphEntityCountsProvider);
    final filter = ref.watch(graphFilterProvider);
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    if (counts.isEmpty) {
      return _EmptyHint(colorScheme: colorScheme);
    }

    final notifier = ref.read(graphFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ShowEverythingRow(enabled: filter.isActive, onPressed: notifier.reset),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              if (counts.nodeLabels.isNotEmpty)
                _FilterSection(
                  title: 'Nodes',
                  counts: counts.nodeLabels,
                  hidden: filter.hiddenNodeLabels,
                  // Node chips take the graph's own node colour, so the list
                  // reads against the canvas rather than as abstract tags.
                  accent: colorScheme.appSpecific.graph.nodeBase,
                  onToggle: notifier.toggleNodeLabel,
                ),
              if (counts.linkTypes.isNotEmpty)
                _FilterSection(
                  title: 'Links',
                  counts: counts.linkTypes,
                  hidden: filter.hiddenLinkTypes,
                  accent: Colors.grey.shade600,
                  labelPrefix: '→ ',
                  onToggle: notifier.toggleLinkType,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One collapsible group of chips — the node labels, or the link types.
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.counts,
    required this.hidden,
    required this.accent,
    required this.onToggle,
    this.labelPrefix = '',
  });

  final String title;
  final Map<String, int> counts;
  final Set<String> hidden;
  final Color accent;
  final String labelPrefix;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return FondeExpansionTile(
      title: AppText(title, variant: AppTextVariant.sectionTitleUtility),
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final entry in counts.entries)
              FilterChip(
                // The count is what tells a label worth hiding from one that
                // is barely there, so it belongs on the chip, not a tooltip.
                label: Text('$labelPrefix${entry.key}  ${entry.value}'),
                selected: !hidden.contains(entry.key),
                selectedColor: accent.withValues(alpha: 0.2),
                checkmarkColor: accent,
                side: BorderSide(color: accent),
                onSelected: (_) => onToggle(entry.key),
              ),
          ],
        ),
      ],
    );
  }
}

/// Clears the filter. Disabled while nothing is hidden, so the row doubles as
/// an indication of whether anything is being held back.
class _ShowEverythingRow extends StatelessWidget {
  const _ShowEverythingRow({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: enabled ? onPressed : null,
          icon: const Icon(Icons.filter_alt_off, size: 18),
          label: const Text('Show everything'),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.colorScheme});

  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final faded = colorScheme.uiAreas.sideBar.inactiveItemText;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_outlined, size: 40, color: faded),
            const SizedBox(height: 12),
            Text(
              'Nothing to filter yet',
              textAlign: TextAlign.center,
              style: TextStyle(color: faded),
            ),
            const SizedBox(height: 6),
            Text(
              'Labels appear here once the open stack has nodes carrying them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: faded.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

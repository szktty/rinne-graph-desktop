/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_themes/core_themes.dart';
import 'package:plough/plough.dart' as plough;
import 'package:presentation_components/presentation_components.dart';

import '../../../providers/graph_providers.dart';
import '../providers/link_creation_providers.dart';

/// Draws the in-progress link and hosts the panel that names it.
///
/// Mounted outside the [plough.GraphViewport], so its local coordinates are
/// viewport-local screen coordinates — the same space
/// [plough.GraphViewportController.sceneToScreen] produces.
class LinkCreationOverlay extends ConsumerWidget {
  const LinkCreationOverlay({required this.viewportController, super.key});

  final plough.GraphViewportController viewportController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tapLinkCreationProvider);
    if (!state.isActive) return const SizedBox.shrink();

    final ploughGraph = ref.watch(graphViewCacheProvider).ploughGraph;
    if (ploughGraph == null) return const SizedBox.shrink();

    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    // The controller is a ValueNotifier<Matrix4>; without listening to it the
    // line would freeze in place while the canvas pans or zooms underneath.
    return AnimatedBuilder(
      animation: viewportController,
      builder: (context, _) {
        final source = _centerOf(ploughGraph, state.sourceNodeId);
        final target =
            _centerOf(ploughGraph, state.targetNodeId) ??
            _centerOf(ploughGraph, state.hoverTargetNodeId) ??
            state.pointerScenePosition;

        return Stack(
          children: [
            if (source != null && target != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _LinkPreviewPainter(
                      start: viewportController.sceneToScreen(source),
                      end: viewportController.sceneToScreen(target),
                      color: colorScheme.appSpecific.graph.selectionHighlight,
                      haloColor: colorScheme.appSpecific.graph.background,
                      // Solid once both ends are settled, dashed while the free
                      // end still follows the pointer.
                      dashed: state.step != LinkCreationStep.confirming,
                    ),
                  ),
                ),
              ),
            if (state.step == LinkCreationStep.confirming &&
                source != null &&
                target != null)
              _ConfirmationPanel(
                anchor: viewportController.sceneToScreen(
                  Offset(
                    (source.dx + target.dx) / 2,
                    (source.dy + target.dy) / 2,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Centre of a node in **scene** coordinates.
  ///
  /// `geometry.bounds` is already logical/scene space despite the name used by
  /// some callers — the viewport's Transform only scales at paint time and does
  /// not affect layout.
  Offset? _centerOf(plough.Graph graph, core_graph.EntityId? id) {
    if (id == null) return null;
    final node = graph.getNode(
      plough.GraphId(type: plough.GraphIdType.node, value: id.value),
    );
    return node?.geometry?.bounds.center;
  }
}

/// Panel that names the link and commits it.
class _ConfirmationPanel extends ConsumerStatefulWidget {
  const _ConfirmationPanel({required this.anchor});

  final Offset anchor;

  @override
  ConsumerState<_ConfirmationPanel> createState() => _ConfirmationPanelState();
}

class _ConfirmationPanelState extends ConsumerState<_ConfirmationPanel> {
  static const double _width = 260;

  late final TextEditingController _labelController;
  late final FocusNode _focusNode;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    return Positioned(
      left: widget.anchor.dx - _width / 2,
      top: widget.anchor.dy + 16,
      width: _width,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.uiAreas.panel.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.base.divider),
          boxShadow: [
            BoxShadow(color: colorScheme.base.shadow, blurRadius: 12),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FondeTextField(
              controller: _labelController,
              focusNode: _focusNode,
              hintText: 'Link type',
              onSubmitted: (_) => _commit(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FondeButton.cancel(
                  onPressed:
                      _saving
                          ? null
                          : () =>
                              ref
                                  .read(tapLinkCreationProvider.notifier)
                                  .cancel(),
                  label: 'Cancel',
                ),
                const SizedBox(width: 8),
                FondeButton.primary(
                  onPressed: _saving ? null : _commit,
                  label: 'Create',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _commit() async {
    if (_saving) return;
    final state = ref.read(tapLinkCreationProvider);
    final sourceId = state.sourceNodeId;
    final targetId = state.targetNodeId;
    if (sourceId == null || targetId == null) return;

    setState(() => _saving = true);
    try {
      await _createLink(sourceId, targetId, _labelController.text.trim());
      ref.read(tapLinkCreationProvider.notifier).finish();
    } catch (e) {
      debugPrint('[LinkCreation] failed to create link: $e');
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _createLink(
    core_graph.EntityId sourceId,
    core_graph.EntityId targetId,
    String label,
  ) async {
    final storage = ref.read(activeStackGraphStorageProvider);
    if (storage == null) return;

    final graphContext = core_graph.GraphContext(storage: storage);
    await graphContext.initialize();

    // The label *is* the link type. Rendering falls back to the type when a
    // link carries no `label` property (see graph_view's conversion), which is
    // how every sample stack displays its links, so storing the same string in
    // both places would only create a second copy that can drift.
    final type = label.isNotEmpty ? label : 'related';

    await graphContext.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: core_graph.EntityDescription(
        type: 'Link',
        propertyTypes: const {},
      ),
    );

    final activeGraph = ref.read(core_graph.activeGraphProvider);
    if (activeGraph != null) {
      final updatedLinks = await graphContext.queryLinks(
        core_graph.GraphQuery<core_graph.Link>(entityType: core_graph.Link),
      );
      var newGraph = activeGraph;
      for (final link in updatedLinks.items) {
        newGraph = newGraph.addLink(link);
      }
      ref.read(core_graph.activeGraphProvider.notifier).setGraph(newGraph);
    }

    // The storage belongs to activeStackGraphStorageProvider, which closes it
    // in onDispose. Closing it here would shut the shared connection while the
    // stack is still open.
  }
}

/// Straight line with an arrowhead, drawn in screen space.
class _LinkPreviewPainter extends CustomPainter {
  _LinkPreviewPainter({
    required this.start,
    required this.end,
    required this.color,
    required this.haloColor,
    required this.dashed,
  });

  static const double _strokeWidth = 3;

  /// Width of the contrasting outline drawn under the line.
  static const double _haloWidth = _strokeWidth + 4;

  final Offset start;
  final Offset end;
  final Color color;

  /// Drawn beneath the line so it stays legible over a node, whose fill can be
  /// close to the highlight colour depending on the theme.
  final Color haloColor;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    // Halo first, line on top.
    _drawStroke(
      canvas,
      Paint()
        ..color = haloColor
        ..strokeWidth = _haloWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    _drawStroke(
      canvas,
      Paint()
        ..color = color
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    _drawArrowhead(canvas, haloColor, _haloWidth);
    _drawArrowhead(canvas, color, 0);
  }

  void _drawStroke(Canvas canvas, Paint paint) {
    if (dashed) {
      _drawDashedLine(canvas, paint);
    } else {
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint) {
    const dash = 8.0;
    const gap = 5.0;
    final delta = end - start;
    final distance = delta.distance;
    if (distance < 1) return;
    final step = delta / distance;

    var travelled = 0.0;
    while (travelled < distance) {
      final segment = math.min(dash, distance - travelled);
      canvas.drawLine(
        start + step * travelled,
        start + step * (travelled + segment),
        paint,
      );
      travelled += dash + gap;
    }
  }

  /// Draws the arrowhead in [fillColor], grown by [outset] on every side so the
  /// halo pass sits proud of the coloured one.
  void _drawArrowhead(Canvas canvas, Color fillColor, double outset) {
    const length = 15.0;
    const spread = 0.45; // radians either side of the shaft
    final delta = end - start;
    if (delta.distance < 1) return;

    final angle = math.atan2(delta.dy, delta.dx);
    final path =
        Path()
          ..moveTo(end.dx, end.dy)
          ..lineTo(
            end.dx - length * math.cos(angle - spread),
            end.dy - length * math.sin(angle - spread),
          )
          ..lineTo(
            end.dx - length * math.cos(angle + spread),
            end.dy - length * math.sin(angle + spread),
          )
          ..close();

    if (outset > 0) {
      // Stroking the same path outwards is enough of an outline here; no need
      // to offset the geometry itself.
      canvas.drawPath(
        path,
        Paint()
          ..color = fillColor
          ..strokeWidth = outset
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );
      return;
    }
    canvas.drawPath(path, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(_LinkPreviewPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.color != color ||
        oldDelegate.haloColor != haloColor ||
        oldDelegate.dashed != dashed;
  }
}

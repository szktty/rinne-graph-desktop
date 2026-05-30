/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../providers/link_creation_providers.dart';

/// Widget to draw link creation arrow overlay
class LinkCreationArrowOverlay extends ConsumerWidget {
  final ValueNotifier<Matrix4> transformationController;

  const LinkCreationArrowOverlay({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkCreationState = ref.watch(linkCreationModeProvider);
    final dragPosition = ref.watch(linkCreationDragPositionProvider);

    // Only show overlay if in link creation mode and dragging
    if (!linkCreationState.isActive ||
        linkCreationState.sourceNodeId == null ||
        dragPosition == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: LinkCreationArrowPainter(
        sourceNodeId: linkCreationState.sourceNodeId!,
        dragPosition: dragPosition,
        transformationMatrix: transformationController.value,
      ),
    );
  }
}

/// Custom painter for link creation arrow
class LinkCreationArrowPainter extends CustomPainter {
  final core_graph.EntityId sourceNodeId;
  final Offset dragPosition;
  final Matrix4 transformationMatrix;

  LinkCreationArrowPainter({
    required this.sourceNodeId,
    required this.dragPosition,
    required this.transformationMatrix,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: Get source node position from graph and draw arrow
    // For now, just draw a simple line from center to drag position
    final paint =
        Paint()
          ..color = Colors.blue.withValues(alpha: 0.7)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    // Draw line from center to drag position
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      dragPosition,
      paint,
    );

    // Draw arrowhead at drag position
    _drawArrowhead(canvas, dragPosition, paint);
  }

  void _drawArrowhead(Canvas canvas, Offset position, Paint paint) {
    const arrowSize = 10.0;
    const arrowAngle = 0.5; // radians

    final arrowPaint =
        Paint()
          ..color = Colors.blue.withValues(alpha: 0.7)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;

    // Draw triangle arrowhead
    final path = Path();
    path.moveTo(position.dx, position.dy);
    path.lineTo(
      position.dx - arrowSize * (1 + arrowAngle),
      position.dy - arrowSize,
    );
    path.lineTo(
      position.dx - arrowSize * (1 - arrowAngle),
      position.dy - arrowSize,
    );
    path.close();

    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(LinkCreationArrowPainter oldDelegate) {
    return oldDelegate.sourceNodeId != sourceNodeId ||
        oldDelegate.dragPosition != dragPosition ||
        oldDelegate.transformationMatrix != transformationMatrix;
  }
}

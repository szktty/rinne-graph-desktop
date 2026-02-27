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

/// Widget to display a long arrow line
///
/// Used to visually represent connection relationships like source → target.
/// Arrow direction, length, color, and thickness are customizable.
class AppArrowLine extends ConsumerWidget {
  const AppArrowLine({
    super.key,
    this.width = 80.0,
    this.height = 2.0,
    this.color,
    this.direction = ArrowDirection.right,
    this.arrowSize = 8.0,
  });

  /// Total width of the arrow
  final double width;

  /// Arrow thickness (line height)
  final double height;

  /// Arrow color (obtained from theme if null)
  final Color? color;

  /// Direction of the arrow
  final ArrowDirection direction;

  /// Size of the arrow head
  final double arrowSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final effectiveColor =
        color ?? appColorScheme.base.foreground.withValues(alpha: 0.6);

    return SizedBox(
      width: width,
      height: arrowSize,
      child: CustomPaint(
        painter: _ArrowLinePainter(
          color: effectiveColor,
          lineHeight: height,
          direction: direction,
          arrowSize: arrowSize,
        ),
      ),
    );
  }
}

/// Direction of the arrow
enum ArrowDirection { left, right, up, down }

class _ArrowLinePainter extends CustomPainter {
  const _ArrowLinePainter({
    required this.color,
    required this.lineHeight,
    required this.direction,
    required this.arrowSize,
  });

  final Color color;
  final double lineHeight;
  final ArrowDirection direction;
  final double arrowSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = lineHeight
          ..strokeCap = StrokeCap.round;

    switch (direction) {
      case ArrowDirection.right:
        _paintRightArrow(canvas, size, paint);
        break;
      case ArrowDirection.left:
        _paintLeftArrow(canvas, size, paint);
        break;
      case ArrowDirection.up:
        _paintUpArrow(canvas, size, paint);
        break;
      case ArrowDirection.down:
        _paintDownArrow(canvas, size, paint);
        break;
    }
  }

  void _paintRightArrow(Canvas canvas, Size size, Paint paint) {
    final double lineY = size.height / 2;
    final double arrowStartX = size.width - arrowSize;

    // Draw horizontal line (extend to arrow)
    canvas.drawLine(
      Offset(0, lineY),
      Offset(size.width - arrowSize / 2, lineY),
      paint,
    );

    // Draw arrow head
    final arrowPath =
        Path()
          ..moveTo(arrowStartX, lineY - arrowSize / 2)
          ..lineTo(size.width, lineY)
          ..lineTo(arrowStartX, lineY + arrowSize / 2);

    paint.style = PaintingStyle.stroke;
    paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(arrowPath, paint);
  }

  void _paintLeftArrow(Canvas canvas, Size size, Paint paint) {
    final double lineY = size.height / 2;
    final double arrowEndX = arrowSize;

    // Draw horizontal line (extend to arrow)
    canvas.drawLine(
      Offset(arrowSize / 2, lineY),
      Offset(size.width, lineY),
      paint,
    );

    // Draw arrow head
    final arrowPath =
        Path()
          ..moveTo(arrowEndX, lineY - arrowSize / 2)
          ..lineTo(0, lineY)
          ..lineTo(arrowEndX, lineY + arrowSize / 2);

    paint.style = PaintingStyle.stroke;
    paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(arrowPath, paint);
  }

  void _paintUpArrow(Canvas canvas, Size size, Paint paint) {
    final double lineX = size.width / 2;
    final double arrowEndY = arrowSize;
    // Draw vertical line (extend to arrow)
    canvas.drawLine(
      Offset(lineX, arrowSize / 2),
      Offset(lineX, size.height),
      paint,
    );

    // Draw arrow head
    final arrowPath =
        Path()
          ..moveTo(lineX - arrowSize / 2, arrowEndY)
          ..lineTo(lineX, 0)
          ..lineTo(lineX + arrowSize / 2, arrowEndY);

    paint.style = PaintingStyle.stroke;
    paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(arrowPath, paint);
  }

  void _paintDownArrow(Canvas canvas, Size size, Paint paint) {
    final double lineX = size.width / 2;
    final double arrowStartY = size.height - arrowSize;

    // Draw vertical line (extend to arrow)
    canvas.drawLine(
      Offset(lineX, 0),
      Offset(lineX, size.height - arrowSize / 2),
      paint,
    );

    // Draw arrow head
    final arrowPath =
        Path()
          ..moveTo(lineX - arrowSize / 2, arrowStartY)
          ..lineTo(lineX, size.height)
          ..lineTo(lineX + arrowSize / 2, arrowStartY);

    paint.style = PaintingStyle.stroke;
    paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _ArrowLinePainter ||
        oldDelegate.color != color ||
        oldDelegate.lineHeight != lineHeight ||
        oldDelegate.direction != direction ||
        oldDelegate.arrowSize != arrowSize;
  }
}

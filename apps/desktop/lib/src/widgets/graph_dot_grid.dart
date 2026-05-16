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

/// Widget to draw dot grid background
class DotGridBackground extends ConsumerStatefulWidget {
  final ValueNotifier<Matrix4> transformationController;

  const DotGridBackground({super.key, required this.transformationController});

  @override
  ConsumerState<DotGridBackground> createState() => _DotGridBackgroundState();
}

class _DotGridBackgroundState extends ConsumerState<DotGridBackground> {
  late Matrix4 _transformationMatrix;

  @override
  void initState() {
    super.initState();
    _transformationMatrix = widget.transformationController.value;
    widget.transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    widget.transformationController.removeListener(_onTransformationChanged);
    super.dispose();
  }

  void _onTransformationChanged() {
    setState(() {
      _transformationMatrix = widget.transformationController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Ensure background responds to hit test
    return CustomPaint(
      painter: DotGridPainter(
        transformation: _transformationMatrix,
        appColorScheme: appColorScheme,
      ),
      size: Size.infinite,
    );
  }
}

/// CustomPainter to draw dot grid
class DotGridPainter extends CustomPainter {
  final Matrix4 transformation;
  final AppColorScheme appColorScheme;

  const DotGridPainter({
    required this.transformation,
    required this.appColorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Extract scale and translation from the transformation matrix.
    // The matrix maps world coordinates → screen coordinates as:
    //   screenX = worldX * scale + tx
    //   screenY = worldY * scale + ty
    final scale = transformation.getMaxScaleOnAxis();
    final translation = transformation.getTranslation();
    final tx = translation.x;
    final ty = translation.y;

    const baseSpacing = 40.0;
    const baseDotSize = 1.5;

    final dotSize = (baseDotSize * scale).clamp(0.5, 4.0);

    final dotColor = appColorScheme.appSpecific.graph.gridLine.withValues(
      alpha: 0.3,
    );
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Convert the four screen-space corners to world space to find the
    // visible world-coordinate range.  This works for any tx/ty/scale.
    //   worldX = (screenX - tx) / scale
    final worldLeft = (0 - tx) / scale;
    final worldTop = (0 - ty) / scale;
    final worldRight = (size.width - tx) / scale;
    final worldBottom = (size.height - ty) / scale;

    // Snap to the nearest grid lines just outside the visible range.
    final firstWorldX = (worldLeft / baseSpacing).floor() * baseSpacing;
    final firstWorldY = (worldTop / baseSpacing).floor() * baseSpacing;

    for (double wx = firstWorldX; wx <= worldRight + baseSpacing; wx += baseSpacing) {
      for (double wy = firstWorldY; wy <= worldBottom + baseSpacing; wy += baseSpacing) {
        final screenX = wx * scale + tx;
        final screenY = wy * scale + ty;
        canvas.drawCircle(Offset(screenX, screenY), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotGridPainter oldDelegate) {
    return transformation != oldDelegate.transformation ||
        appColorScheme != oldDelegate.appColorScheme;
  }
}

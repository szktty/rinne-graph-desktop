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
  final TransformationController transformationController;

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
    print('[DEBUG] Background: TransformationController changed');
    print(
      '[DEBUG] Background: New matrix: ${widget.transformationController.value}',
    );
    setState(() {
      _transformationMatrix = widget.transformationController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get theme via @packages/core/themes/
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    print('[DEBUG] Background: Building with matrix: $_transformationMatrix');

    // Ensure background responds to hit test
    return Container(
      // Set graph view background color - set color to ensure hit test passes
      color: appColorScheme.appSpecific.graph.background,
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onTap: () {
          print('[DEBUG] 🎨🎯 BACKGROUND TAPPED SUCCESSFULLY!');
        },
        onPanStart: (details) {
          print('[DEBUG] 🎨🚀 BACKGROUND PAN START: ${details.localPosition}');
        },
        onPanUpdate: (details) {
          print('[DEBUG] 🎨📍 BACKGROUND PAN UPDATE: ${details.localPosition}');
        },
        onPanEnd: (details) {
          print('[DEBUG] 🎨🏁 BACKGROUND PAN END');
        },
        behavior:
            HitTestBehavior
                .opaque, // Important: pass hit test even for transparent areas
        child: CustomPaint(
          painter: DotGridPainter(
            transformation: _transformationMatrix,
            appColorScheme: appColorScheme,
          ),
          size: Size.infinite,
        ),
      ),
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
    // Get zoom scale and offset from transformation matrix
    final scale = transformation.getMaxScaleOnAxis();
    final translation = transformation.getTranslation();
    final offsetX = translation.x;
    final offsetY = translation.y;

    // Basic dot settings
    const baseSpacing = 40.0; // Basic dot spacing
    const baseDotSize = 1.5; // Basic dot size

    // Adjust spacing and dot size based on zoom
    final spacing = baseSpacing * scale;
    final dotSize = (baseDotSize * scale).clamp(0.5, 4.0);

    // Dot color (theme-aware)
    // Use grid line color for better visibility
    final dotColor = appColorScheme.appSpecific.graph.gridLine.withValues(
      alpha: 0.3,
    );

    final paint =
        Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;

    // Calculate drawing range (for performance optimization)
    final startX = (-offsetX / spacing).floor() * spacing;
    final startY = (-offsetY / spacing).floor() * spacing;
    final endX = startX + (size.width / scale + spacing * 2);
    final endY = startY + (size.height / scale + spacing * 2);

    // Draw dots
    for (double x = startX; x <= endX; x += spacing) {
      for (double y = startY; y <= endY; y += spacing) {
        // Convert world coordinates to screen coordinates
        final screenX = x * scale + offsetX;
        final screenY = y * scale + offsetY;

        // Draw only if within screen
        if (screenX >= -dotSize &&
            screenX <= size.width + dotSize &&
            screenY >= -dotSize &&
            screenY <= size.height + dotSize) {
          canvas.drawCircle(Offset(screenX, screenY), dotSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotGridPainter oldDelegate) {
    return transformation != oldDelegate.transformation ||
        appColorScheme != oldDelegate.appColorScheme;
  }
}

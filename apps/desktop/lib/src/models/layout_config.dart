/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';
import 'package:plough/plough.dart' show GraphTreeLayoutDirection;

/// Base class for App-specific graph layout configurations.
@immutable
sealed class AppLayoutConfig {
  const AppLayoutConfig();
}

/// Configuration for the Force-Directed layout.
@immutable
class ForceDirectedLayoutConfig extends AppLayoutConfig {
  /// Strength of repulsion between nodes.
  final double repulsionStrength;

  /// Optimal distance between linked nodes.
  final double linkDistance;

  /// Number of iterations for the simulation.
  final int iterations;

  const ForceDirectedLayoutConfig({
    this.repulsionStrength = 100.0,
    this.linkDistance = 50.0,
    this.iterations = 100,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForceDirectedLayoutConfig &&
          runtimeType == other.runtimeType &&
          repulsionStrength == other.repulsionStrength &&
          linkDistance == other.linkDistance &&
          iterations == other.iterations;

  @override
  int get hashCode => Object.hash(repulsionStrength, linkDistance, iterations);
}

/// Configuration for the Tree layout.
@immutable
class TreeLayoutConfig extends AppLayoutConfig {
  /// Direction of the tree layout (e.g., top-to-bottom).
  final GraphTreeLayoutDirection direction;

  /// Horizontal spacing between nodes at the same level.
  final double levelSpacing;

  /// Vertical spacing between different levels.
  final double nodeSpacing;

  const TreeLayoutConfig({
    this.direction = GraphTreeLayoutDirection.topToBottom,
    this.levelSpacing = 50.0,
    this.nodeSpacing = 80.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeLayoutConfig &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          levelSpacing == other.levelSpacing &&
          nodeSpacing == other.nodeSpacing;

  @override
  int get hashCode => Object.hash(direction, levelSpacing, nodeSpacing);
}

/// Configuration for the Random layout.
@immutable
class RandomLayoutConfig extends AppLayoutConfig {
  /// Seed for the random number generator for reproducible layouts.
  /// If null, a random seed is used.
  final int? seed;

  const RandomLayoutConfig({this.seed});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RandomLayoutConfig &&
          runtimeType == other.runtimeType &&
          seed == other.seed;

  @override
  int get hashCode => seed.hashCode;
}

// Add other layout configurations as needed (e.g., ManualLayoutConfig)

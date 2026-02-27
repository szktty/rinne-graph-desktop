/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_undo/undo.dart';

/// Mock command for testing undo functionality.
class MockCommand extends NonMergeableCommand {
  @override
  final String id;

  @override
  final String description;

  @override
  final DateTime timestamp;

  final int memoryUsage;

  bool wasExecuted = false;
  bool wasUndone = false;
  bool wasRedone = false;

  MockCommand(
    this.id,
    this.description, {
    this.memoryUsage = 64,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  Future<void> execute(dynamic context) async {
    // Simulate some work
    await Future.delayed(const Duration(milliseconds: 1));
    wasExecuted = true;
  }

  @override
  Future<void> undo(dynamic context) async {
    // Simulate some work
    await Future.delayed(const Duration(milliseconds: 1));
    wasUndone = true;
  }

  @override
  Future<void> redo(dynamic context) async {
    // Simulate some work
    await Future.delayed(const Duration(milliseconds: 1));
    wasRedone = true;
  }

  @override
  int get estimatedMemoryUsage => memoryUsage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockCommand &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description;

  @override
  int get hashCode => Object.hash(id, description);
}

/// Mock mergeable command for testing command merging.
class MockMergeableCommand extends MergeableCommand {
  @override
  final String id;

  @override
  final String description;

  @override
  final DateTime timestamp;

  final int memoryUsage;
  final bool canMerge;

  bool wasExecuted = false;
  bool wasUndone = false;
  bool wasRedone = false;
  bool wasMerged = false;

  MockMergeableCommand? _mergeTarget;

  MockMergeableCommand(
    this.id,
    this.description, {
    this.memoryUsage = 64,
    this.canMerge = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Set which command this should merge with.
  void setMergeTarget(MockMergeableCommand target) {
    _mergeTarget = target;
  }

  @override
  Future<void> execute(dynamic context) async {
    await Future.delayed(const Duration(milliseconds: 1));
    wasExecuted = true;
  }

  @override
  Future<void> undo(dynamic context) async {
    await Future.delayed(const Duration(milliseconds: 1));
    wasUndone = true;
  }

  @override
  Future<void> redo(dynamic context) async {
    await Future.delayed(const Duration(milliseconds: 1));
    wasRedone = true;
  }

  @override
  bool canMergeWithSpecific(UndoableCommand other) {
    return canMerge && other == _mergeTarget;
  }

  @override
  UndoableCommand? mergeWith(UndoableCommand other) {
    if (!canMergeWith(other) || other is! MockMergeableCommand) {
      return null;
    }

    final merged = MockMergeableCommand(
      '${id}_merged_${other.id}',
      'Merged: $description + ${other.description}',
      memoryUsage: memoryUsage + other.memoryUsage,
      canMerge: false,
      timestamp: other.timestamp,
    );
    merged.wasMerged = true;
    return merged;
  }

  @override
  int get estimatedMemoryUsage => memoryUsage;
}

/// Mock slow command for testing concurrent operations.
class MockSlowCommand extends NonMergeableCommand {
  @override
  final String id;

  @override
  final String description;

  @override
  final DateTime timestamp;

  final Duration delay;

  bool wasExecuted = false;
  bool wasUndone = false;
  bool wasRedone = false;

  MockSlowCommand(
    this.id,
    this.description, {
    this.delay = const Duration(milliseconds: 100),
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  Future<void> execute(dynamic context) async {
    await Future.delayed(delay);
    wasExecuted = true;
  }

  @override
  Future<void> undo(dynamic context) async {
    await Future.delayed(delay);
    wasUndone = true;
  }

  @override
  Future<void> redo(dynamic context) async {
    await Future.delayed(delay);
    wasRedone = true;
  }

  @override
  int get estimatedMemoryUsage => 64;
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:presentation_components/presentation_components.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

/// A wrapper that adapts core_stack.Stack to the StackData interface
class CoreStackWrapper implements StackData {
  final core_stack.Stack _stack;

  CoreStackWrapper(this._stack);

  @override
  String get id => _stack.info.name; // Using name as StackInfo does not have an ID

  @override
  String get name => _stack.info.name;

  @override
  String? get thumbnailUrl => null; // No thumbnail in core_stack

  @override
  List<String> get categories => _stack.info.tags; // Using tags as categories

  @override
  int get nodeCount => 0; // 0 if actual value cannot be obtained

  @override
  int get linkCount => 0; // 0 if actual value cannot be obtained

  @override
  String get updatedAt => _stack.info.lastModifiedAt.toString(); // Using last modified date/time

  @override
  bool get isFavorite => false; // false if no favorite information

  @override
  Map<String, dynamic> get metadata => {
    'description': _stack.info.description,
    'author': _stack.info.author,
    'tags': _stack.info.tags,
    'version': _stack.info.version,
    'createdAt': _stack.info.createdAt.toString(),
    'lastModifiedAt': _stack.info.lastModifiedAt.toString(),
  };

  core_stack.Stack get originalStack => _stack;
}

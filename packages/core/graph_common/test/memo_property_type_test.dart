/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:test/test.dart';
// Prefixed because core_graph_common's query predicates export names that
// collide with matcher's (`contains`, `isNull`).
import 'package:core_graph_common/core_graph_common.dart' as graph;

void main() {
  group('MemoPropertyType', () {
    const type = graph.MemoPropertyType();

    test('accepts a memo at exactly the limit', () {
      final value = 'あ' * graph.MemoPropertyType.maxLength;
      expect(type.isValid(value), isTrue);
      expect(type.validate(value).isValid, isTrue);
    });

    test('rejects a memo one character over the limit', () {
      final value = 'あ' * (graph.MemoPropertyType.maxLength + 1);
      expect(type.isValid(value), isFalse);
      expect(type.validate(value).isValid, isFalse);
    });

    test('accepts an empty memo', () {
      expect(type.isValid(''), isTrue);
    });

    // The point of counting grapheme clusters: these would each be several
    // UTF-16 code units, so Flutter's own maxLength would cut them off early.
    test('counts an emoji with ZWJ joins as one character', () {
      const family = '👨‍👩‍👧';
      expect(family.length, greaterThan(1), reason: 'sanity: multi-code-unit');
      expect(graph.MemoPropertyType.lengthOf(family), 1);
    });

    test('accepts a memo of emoji at the limit', () {
      final value = '👨‍👩‍👧' * graph.MemoPropertyType.maxLength;
      expect(type.isValid(value), isTrue);
    });

    test('rejects a memo of emoji one character over the limit', () {
      final value = '👨‍👩‍👧' * (graph.MemoPropertyType.maxLength + 1);
      expect(type.isValid(value), isFalse);
    });

    test('counts a combining sequence as one character', () {
      // 'e' followed by a combining acute accent.
      const combined = 'é';
      expect(combined.length, 2, reason: 'sanity: two code units');
      expect(graph.MemoPropertyType.lengthOf(combined), 1);
    });

    test('reports the actual length when over the limit', () {
      final value = 'あ' * (graph.MemoPropertyType.maxLength + 5);
      final result = type.validate(value);
      expect(result.isValid, isFalse);
      expect(result.error, contains('505'));
    });

    test('rejects non-string values', () {
      expect(type.isValid(42), isFalse);
      expect(type.validate(42).isValid, isFalse);
    });

    // PropertyType.validate's doc comment claims null is always valid, but no
    // implementation behaves that way — TextPropertyType rejects it with
    // "Value must be a string" too. Pinning the behaviour that actually ships,
    // matching the sibling types rather than the stale comment.
    test('rejects null, matching the other property types', () {
      expect(type.validate(null).isValid, isFalse);
    });

    test('converts values to strings', () {
      expect(type.convertValue(42), '42');
      expect(type.convertValue(null), isNull);
    });

    test('is named memo and is distinct from text', () {
      expect(type.name, 'memo');
      expect(type, isNot(isA<graph.TextPropertyType>()));
    });
  });
}

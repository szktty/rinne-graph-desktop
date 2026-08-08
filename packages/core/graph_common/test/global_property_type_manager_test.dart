/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
// Prefixed because core_graph_common's query predicates export names that
// collide with matcher's (`contains`, `isNull`).
import 'package:core_graph_common/core_graph_common.dart' as graph;

void main() {
  group('GlobalPropertyTypeManager label scoping', () {
    late Directory stackDir;

    setUp(() {
      stackDir = Directory.systemTemp.createTempSync('property_types_test');
    });

    tearDown(() {
      if (stackDir.existsSync()) {
        stackDir.deleteSync(recursive: true);
      }
    });

    File propertyTypesFile() =>
        File('${stackDir.path}/meta/property_types.json');

    Map<String, dynamic> readFile() =>
        json.decode(propertyTypesFile().readAsStringSync())
            as Map<String, dynamic>;

    graph.GlobalPropertyTypeDefinition memoDefinition() {
      final now = DateTime.now();
      return graph.GlobalPropertyTypeDefinition(
        typeName: 'memo',
        name: 'Notes',
        description: 'Free-form notes',
        constraints: const {'max_length': graph.MemoPropertyType.maxLength},
        uiHints: const {},
        createdAt: now,
        updatedAt: now,
      );
    }

    test('persists label-scoped definitions across a reload', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      await manager.setLabelPropertyType('titan', 'notes', memoDefinition());

      // A fresh manager reads only what reached disk.
      final reloaded = graph.GlobalPropertyTypeManager(stackDir.path);
      final resolved = await reloaded.getPropertyTypeForLabels('notes', [
        'titan',
      ]);

      expect(resolved, isNotNull);
      expect(resolved!.typeName, 'memo');
    });

    test('writes label_property_types under the label key', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      await manager.setLabelPropertyType('titan', 'notes', memoDefinition());

      final labelTypes =
          readFile()['label_property_types'] as Map<String, dynamic>;
      final forTitan = labelTypes['titan'] as Map<String, dynamic>;
      final notes = forTitan['notes'] as Map<String, dynamic>;

      expect(notes['type'], 'memo');
    });

    test('omits label_property_types when no label is scoped', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      // Touching a stack-wide definition alone must not introduce the key.
      await manager.setPropertyType('title', memoDefinition());

      expect(readFile().containsKey('label_property_types'), isFalse);
    });

    test('falls back to the stack-wide definition for other labels', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      await manager.setLabelPropertyType('titan', 'notes', memoDefinition());

      // 'god' has no scoped definition, so resolution falls through to the
      // stack-wide map — where the defaults put a plain text 'description'.
      final resolved = await manager.getPropertyTypeForLabels('description', [
        'god',
      ]);

      expect(resolved?.typeName, 'text');
    });

    test('resolves a label-scoped type ahead of the stack-wide one', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      // 'description' exists stack-wide as text; scope it to memo for titans.
      await manager.setLabelPropertyType(
        'titan',
        'description',
        memoDefinition(),
      );

      expect(
        (await manager.getPropertyTypeForLabels('description', [
          'titan',
        ]))?.typeName,
        'memo',
      );
      expect(
        (await manager.getPropertyTypeForLabels('description', [
          'god',
        ]))?.typeName,
        'text',
      );
    });

    // Regression: two managers on one stack — the app briefly built a second
    // when the stack path was set twice — each created the default definitions
    // and wrote at the same time, leaving property_types.json truncated
    // mid-object and unparseable. Writes within a manager are serialised, but
    // separate instances cannot see each other's queue, so the file has to
    // survive being written by both.
    test('leaves valid JSON when two managers write at once', () async {
      final first = graph.GlobalPropertyTypeManager(stackDir.path);
      final second = graph.GlobalPropertyTypeManager(stackDir.path);

      await Future.wait([
        first.setLabelPropertyType('titan', 'notes', memoDefinition()),
        second.setLabelPropertyType('god', 'notes', memoDefinition()),
      ]);

      // Parsing at all is the assertion; the corrupt file threw here.
      final parsed = readFile();
      expect(parsed['version'], '1.1.0');
      expect(parsed['label_property_types'], isA<Map<String, dynamic>>());
    });

    // Serialising within one manager: the default-definitions save and the
    // save from the call that triggered the load must not interleave.
    test('leaves valid JSON when saves overlap on one manager', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);

      await Future.wait([
        manager.setLabelPropertyType('titan', 'notes', memoDefinition()),
        manager.setPropertyType('title', memoDefinition()),
        manager.setLabelPropertyType('god', 'notes', memoDefinition()),
      ]);

      final parsed = readFile();
      expect(parsed['version'], '1.1.0');

      final labelTypes = parsed['label_property_types'] as Map<String, dynamic>;
      expect(labelTypes.keys, containsAll(<String>['titan', 'god']));
    });

    // Renaming a property has to take its type along, or a renamed memo comes
    // back as plain text and stops being length-checked.
    test('renameLabelPropertyType moves the definition', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      await manager.setLabelPropertyType('titan', 'memo', memoDefinition());

      await manager.renameLabelPropertyType('titan', 'memo', 'notes');

      expect(
        (await manager.getPropertyTypeForLabels('notes', ['titan']))?.typeName,
        'memo',
      );
      // The old name must not keep resolving to memo.
      expect(
        (await manager.getPropertyTypeForLabels('memo', ['titan']))?.typeName,
        isNot('memo'),
      );

      final forTitan =
          readFile()['label_property_types']['titan'] as Map<String, dynamic>;
      expect(forTitan.containsKey('memo'), isFalse);
      expect(forTitan.containsKey('notes'), isTrue);
    });

    test('renameLabelPropertyType ignores an untyped property', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      // Nothing scoped to this label at all; must not throw or create one.
      await manager.renameLabelPropertyType('titan', 'absent', 'other');

      expect(
        (await manager.getPropertyTypeForLabels('other', ['titan']))?.typeName,
        isNot('memo'),
      );
    });

    // The stack-switch bug: a manager reused across stacks would otherwise keep
    // serving the previous stack's label definitions.
    test('clearCache drops label-scoped definitions', () async {
      final manager = graph.GlobalPropertyTypeManager(stackDir.path);
      await manager.setLabelPropertyType('titan', 'notes', memoDefinition());

      propertyTypesFile().deleteSync();
      manager.clearCache();

      final resolved = await manager.getPropertyTypeForLabels('notes', [
        'titan',
      ]);
      expect(resolved, isNull);
    });
  });
}

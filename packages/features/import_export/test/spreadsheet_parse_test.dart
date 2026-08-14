/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:typed_data';

import 'package:excel_community/excel_community.dart';
import 'package:features_import_export/src/services/csv_import_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// A workbook is read the same way a CSV is, so the two have to agree.
///
/// The row parsers were written for CSV and are reused unchanged for
/// spreadsheets; these tests pin the part that differs — turning a sheet into
/// the grid those parsers expect — and check it against the CSV reader's
/// output rather than against itself.
void main() {
  /// Builds an xlsx in memory from [sheets], each a table whose first row is
  /// the header.
  Uint8List buildWorkbook(Map<String, List<List<CellValue?>>> sheets) {
    final excel = Excel.createExcel();
    for (final entry in sheets.entries) {
      final sheet = excel[entry.key];
      for (final row in entry.value) {
        sheet.appendRow(row);
      }
    }
    // createExcel seeds a default sheet that would otherwise be parsed too.
    for (final name in excel.tables.keys.toList()) {
      if (!sheets.containsKey(name)) excel.delete(name);
    }
    return Uint8List.fromList(excel.encode()!);
  }

  group('a sheet and the equivalent CSV agree', () {
    test('nodes carry the same ids, labels and typed properties', () {
      final fromCsv = CsvImportService.parseCsv(
        'id,labels,name,age\n'
        'p1,person,Alice,30\n'
        'p2,person,Bob,25\n',
      );

      final fromXlsx = CsvImportService.parseXlsx(
        buildWorkbook({
          'nodes': [
            [
              TextCellValue('id'),
              TextCellValue('labels'),
              TextCellValue('name'),
              TextCellValue('age'),
            ],
            [
              TextCellValue('p1'),
              TextCellValue('person'),
              TextCellValue('Alice'),
              IntCellValue(30),
            ],
            [
              TextCellValue('p2'),
              TextCellValue('person'),
              TextCellValue('Bob'),
              IntCellValue(25),
            ],
          ],
        }),
      ).tables;

      expect(fromXlsx, hasLength(1));
      final csvNodes = fromCsv.nodes;
      final xlsxNodes = fromXlsx.single.nodes;

      expect(xlsxNodes.map((n) => n.customId), csvNodes.map((n) => n.customId));
      expect(xlsxNodes.map((n) => n.labels), csvNodes.map((n) => n.labels));
      expect(
        xlsxNodes.map((n) => n.properties),
        csvNodes.map((n) => n.properties),
      );
      // The point of the comparison: a number stays a number in both readers.
      expect(xlsxNodes.first.properties['age'], 30);
    });

    test('links carry the same endpoints and type', () {
      final fromCsv = CsvImportService.parseCsv(
        'source,target,type\n'
        'p1,p2,knows\n',
      );

      final fromXlsx = CsvImportService.parseXlsx(
        buildWorkbook({
          'links': [
            [
              TextCellValue('source'),
              TextCellValue('target'),
              TextCellValue('type'),
            ],
            [TextCellValue('p1'), TextCellValue('p2'), TextCellValue('knows')],
          ],
        }),
      ).tables;

      final csvLink = fromCsv.links.single;
      final xlsxLink = fromXlsx.single.links.single;
      expect(xlsxLink.sourceId, csvLink.sourceId);
      expect(xlsxLink.targetId, csvLink.targetId);
      expect(xlsxLink.type, csvLink.type);
    });
  });

  group('a workbook holding several sheets', () {
    test('reads nodes and links from one file, nodes first', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          // Deliberately out of order: links are declared before nodes.
          'links': [
            [
              TextCellValue('source'),
              TextCellValue('target'),
              TextCellValue('type'),
            ],
            [TextCellValue('p1'), TextCellValue('p2'), TextCellValue('knows')],
          ],
          'nodes': [
            [TextCellValue('id')],
            [TextCellValue('p1')],
            [TextCellValue('p2')],
          ],
        }),
      ).tables;

      expect(results, hasLength(2));
      // Links resolve their endpoints against nodes already in the graph, so
      // the node sheet has to be imported first however the file is arranged.
      expect(results.first.type, CsvDataType.node);
      expect(results.last.type, CsvDataType.link);
    });

    test('skips a sheet that is not graph data', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          'notes': [
            [TextCellValue('memo'), TextCellValue('written')],
            [TextCellValue('buy milk'), TextCellValue('today')],
          ],
          'nodes': [
            [TextCellValue('id')],
            [TextCellValue('p1')],
          ],
        }),
      ).tables;

      // The notes tab is ignored rather than failing the whole import.
      expect(results, hasLength(1));
      expect(results.single.type, CsvDataType.node);
      expect(results.single.nodes.single.customId, 'p1');
    });

    test('is empty when no sheet holds graph data', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          'notes': [
            [TextCellValue('memo')],
            [TextCellValue('buy milk')],
          ],
        }),
      ).tables;

      expect(results, isEmpty);
    });
  });

  group('cell values', () {
    test('an empty cell drops the property rather than storing a blank', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          'nodes': [
            [
              TextCellValue('id'),
              TextCellValue('name'),
              TextCellValue('nickname'),
            ],
            [TextCellValue('p1'), TextCellValue('Alice'), null],
          ],
        }),
      ).tables;

      final node = results.single.nodes.single;
      expect(node.properties, {'name': 'Alice'});
      expect(node.properties.containsKey('nickname'), isFalse);
    });

    test('a date becomes an unambiguous string', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          'nodes': [
            [TextCellValue('id'), TextCellValue('born')],
            [TextCellValue('p1'), DateCellValue(year: 1990, month: 4, day: 2)],
          ],
        }),
      ).tables;

      final born = results.single.nodes.single.properties['born'] as String;
      expect(born, startsWith('1990-04-02'));
    });

    test('a bool survives as a bool', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          'nodes': [
            [TextCellValue('id'), TextCellValue('active')],
            [TextCellValue('p1'), BoolCellValue(true)],
          ],
        }),
      ).tables;

      expect(results.single.nodes.single.properties['active'], true);
    });
  });

  group('the `\$` schema prefix is stripped, as in CSV', () {
    test('from labels, types and property keys', () {
      final results = CsvImportService.parseXlsx(
        buildWorkbook({
          'nodes': [
            [
              TextCellValue('id'),
              TextCellValue('labels'),
              TextCellValue(r'$name'),
            ],
            [
              TextCellValue('p1'),
              TextCellValue(r'$person, $employee'),
              TextCellValue('Alice'),
            ],
          ],
        }),
      ).tables;

      final node = results.single.nodes.single;
      expect(node.labels, {'person', 'employee'});
      expect(node.properties.keys, ['name']);
    });
  });
}

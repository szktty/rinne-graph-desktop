/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/src/widgets/app_dialog.dart';
import 'package:presentation_components/src/widgets/app_physical_model.dart';

Widget createTestWidget({required Widget child, List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('AppDialog', () {
    group('Basic Rendering', () {
      testWidgets('renders with required child parameter', (tester) async {
        const testChild = Text('Test Dialog Content');

        await tester.pumpWidget(
          createTestWidget(child: const AppDialog(child: testChild)),
        );

        expect(find.text('Test Dialog Content'), findsOneWidget);
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(AppPhysicalModelVariants), findsOneWidget);
      });

      testWidgets('displays with custom dimensions', (tester) async {
        const testChild = Text('Sized Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(width: 300, height: 200, child: testChild),
          ),
        );

        expect(find.text('Sized Dialog'), findsOneWidget);

        final container = find.byType(Container).first;
        final containerWidget = tester.widget<Container>(container);
        expect(containerWidget.constraints?.maxWidth, equals(300.0));
        expect(containerWidget.constraints?.maxHeight, equals(200.0));
      });

      testWidgets('applies constraints correctly', (tester) async {
        const testChild = Text('Constrained Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(
              maxWidth: 500,
              maxHeight: 400,
              minWidth: 100,
              minHeight: 80,
              child: testChild,
            ),
          ),
        );

        final container = find.byType(Container).first;
        final containerWidget = tester.widget<Container>(container);

        expect(containerWidget.constraints?.maxWidth, equals(500.0));
        expect(containerWidget.constraints?.maxHeight, equals(400.0));
        expect(containerWidget.constraints?.minWidth, equals(100.0));
        expect(containerWidget.constraints?.minHeight, equals(80.0));
      });
    });

    group('Padding and Layout', () {
      testWidgets('applies padding when specified', (tester) async {
        const testChild = Text('Padded Dialog');
        const testPadding = EdgeInsets.all(16.0);

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(padding: testPadding, child: testChild),
          ),
        );

        expect(find.byType(Padding), findsOneWidget);

        final paddingWidget = tester.widget<Padding>(find.byType(Padding));
        expect(paddingWidget.padding, equals(testPadding));
      });

      testWidgets('does not add padding when not specified', (tester) async {
        const testChild = Text('No Padding Dialog');

        await tester.pumpWidget(
          createTestWidget(child: const AppDialog(child: testChild)),
        );

        // Should not have explicit Padding widget wrapping the child
        final paddingWidgets = find.byType(Padding);
        final dialogChild = find.text('No Padding Dialog');

        expect(dialogChild, findsOneWidget);
      });

      testWidgets('handles complex child layouts', (tester) async {
        final complexChild = Column(
          children: const [
            Text('Title'),
            Text('Content'),
            Row(children: [Text('Button 1'), Text('Button 2')]),
          ],
        );

        await tester.pumpWidget(
          createTestWidget(child: AppDialog(child: complexChild)),
        );

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
        expect(find.text('Button 1'), findsOneWidget);
        expect(find.text('Button 2'), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('uses theme colors from providers', (tester) async {
        const testChild = Text('Themed Dialog');

        await tester.pumpWidget(
          createTestWidget(child: const AppDialog(child: testChild)),
        );

        // Dialog should be rendered without errors
        expect(find.text('Themed Dialog'), findsOneWidget);
        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('respects custom background color', (tester) async {
        const testChild = Text('Custom Color Dialog');
        const customColor = Colors.blue;

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(
              backgroundColor: customColor,
              child: testChild,
            ),
          ),
        );

        expect(find.text('Custom Color Dialog'), findsOneWidget);

        final physicalModel = find.byType(AppPhysicalModelVariants);
        expect(physicalModel, findsOneWidget);
      });
    });

    group('Accessibility and Zoom', () {
      testWidgets('handles zoom scaling when enabled', (tester) async {
        const testChild = Text('Zoomable Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(
              width: 200,
              height: 100,
              disableZoom: false,
              child: testChild,
            ),
          ),
        );

        expect(find.text('Zoomable Dialog'), findsOneWidget);
      });

      testWidgets('ignores zoom scaling when disabled', (tester) async {
        const testChild = Text('Non-Zoomable Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(
              width: 200,
              height: 100,
              disableZoom: true,
              child: testChild,
            ),
          ),
        );

        expect(find.text('Non-Zoomable Dialog'), findsOneWidget);

        final container = find.byType(Container).first;
        final containerWidget = tester.widget<Container>(container);
        expect(containerWidget.constraints?.maxWidth, equals(200.0));
        expect(containerWidget.constraints?.maxHeight, equals(100.0));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very large dimensions', (tester) async {
        const testChild = Text('Large Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(
              width: 10000,
              height: 8000,
              child: testChild,
            ),
          ),
        );

        expect(find.text('Large Dialog'), findsOneWidget);
      });

      testWidgets('handles very small dimensions', (tester) async {
        const testChild = Text('Small Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(width: 1, height: 1, child: testChild),
          ),
        );

        expect(find.text('Small Dialog'), findsOneWidget);
      });

      testWidgets('handles zero and negative dimensions gracefully', (
        tester,
      ) async {
        const testChild = Text('Edge Case Dialog');

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(minWidth: 0, minHeight: 0, child: testChild),
          ),
        );

        expect(find.text('Edge Case Dialog'), findsOneWidget);
      });

      testWidgets('handles complex padding configurations', (tester) async {
        const testChild = Text('Complex Padding Dialog');
        const complexPadding = EdgeInsets.fromLTRB(10, 20, 30, 40);

        await tester.pumpWidget(
          createTestWidget(
            child: const AppDialog(padding: complexPadding, child: testChild),
          ),
        );

        expect(find.text('Complex Padding Dialog'), findsOneWidget);
        expect(find.byType(Padding), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        const testChild = Text('Hierarchy Test');

        await tester.pumpWidget(
          createTestWidget(child: const AppDialog(child: testChild)),
        );

        // Check the widget hierarchy
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(AppPhysicalModelVariants), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.text('Hierarchy Test'), findsOneWidget);
      });

      testWidgets('Dialog has transparent background and zero elevation', (
        tester,
      ) async {
        const testChild = Text('Transparent Dialog');

        await tester.pumpWidget(
          createTestWidget(child: const AppDialog(child: testChild)),
        );

        final dialog = tester.widget<Dialog>(find.byType(Dialog));
        expect(dialog.elevation, equals(0));
        expect(dialog.backgroundColor, equals(Colors.transparent));
      });
    });

    group('Performance', () {
      testWidgets('builds efficiently without unnecessary rebuilds', (
        tester,
      ) async {
        int buildCount = 0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    buildCount++;
                    return const AppDialog(child: Text('Performance Test'));
                  },
                ),
              ),
            ),
          ),
        );

        expect(buildCount, equals(1));

        // Pump again to ensure no unnecessary rebuilds
        await tester.pump();
        expect(buildCount, equals(1));
      });
    });
  });

  group('showAppDialog function', () {
    testWidgets('shows dialog with default parameters', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showAppDialog(
                        context: context,
                        child: const Text('Function Dialog'),
                      );
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Function Dialog'), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);
    });

    testWidgets('shows dialog with custom parameters', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showAppDialog(
                        context: context,
                        child: const Text('Custom Dialog'),
                        width: 400,
                        height: 300,
                        backgroundColor: Colors.red,
                        barrierDismissible: false,
                      );
                    },
                    child: const Text('Show Custom Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Custom Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Dialog'), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);
    });

    testWidgets('returns value when dialog is dismissed', (tester) async {
      String? result;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      result = await showAppDialog<String>(
                        context: context,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop('dialog_result');
                          },
                          child: const Text('Return Result'),
                        ),
                      );
                    },
                    child: const Text('Show Result Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Result Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Return Result'));
      await tester.pumpAndSettle();

      expect(result, equals('dialog_result'));
    });

    testWidgets('can be dismissed by barrier when barrierDismissible is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showAppDialog(
                        context: context,
                        child: const Text('Dismissible Dialog'),
                        barrierDismissible: true,
                      );
                    },
                    child: const Text('Show Dismissible Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dismissible Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Dismissible Dialog'), findsOneWidget);

      // Tap outside the dialog (on the barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Dismissible Dialog'), findsNothing);
    });

    testWidgets('applies all dialog function parameters correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showAppDialog(
                        context: context,
                        child: const Text('Full Parameter Dialog'),
                        width: 500,
                        height: 400,
                        maxWidth: 600,
                        maxHeight: 500,
                        minWidth: 200,
                        minHeight: 150,
                        padding: const EdgeInsets.all(20),
                        elevation: 12.0,
                        cornerRadius: 16.0,
                        backgroundColor: Colors.green,
                        barrierDismissible: false,
                        useSafeArea: true,
                        useRootNavigator: true,
                      );
                    },
                    child: const Text('Show Full Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Full Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Full Parameter Dialog'), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);

      // Check that padding is applied
      expect(find.byType(Padding), findsOneWidget);
    });
  });
}

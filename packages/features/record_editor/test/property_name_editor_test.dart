/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the property name editor's focus wiring.
///
/// The widget itself is private to graph_entity_properties_display.dart and
/// reaching it needs the whole Riverpod-backed panel, so the structure under
/// test is reproduced here: what broke was how the FocusNode was wired, not
/// anything about the surrounding panel.
class _NameEditor extends StatefulWidget {
  const _NameEditor({required this.initialName, required this.onFinish});

  final String initialName;
  final ValueChanged<String> onFinish;

  @override
  State<_NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<_NameEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _focusNode.requestFocus();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus || _finished) return;
    _finished = true;
    widget.onFinish(_controller.text);
  }

  void _finish(String newName) {
    if (_finished) return;
    _finished = true;
    widget.onFinish(newName);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onSubmitted: _finish,
    );
  }
}

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('property name editor focus wiring', () {
    // Regression: the node was handed to both a wrapping Focus and the
    // TextField inside it, so the framework tried to reparent the node under
    // itself — "Tried to make a child into a parent of itself" — and the panel
    // blew up as soon as a property name was clicked.
    testWidgets('builds without a focus reparenting assertion', (tester) async {
      await tester.pumpWidget(
        _host(_NameEditor(initialName: 'memo', onFinish: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('takes focus when it appears', (tester) async {
      await tester.pumpWidget(
        _host(_NameEditor(initialName: 'memo', onFinish: (_) {})),
      );
      await tester.pumpAndSettle();

      final node = tester.widget<TextField>(find.byType(TextField)).focusNode;
      expect(node?.hasFocus, isTrue);
    });

    testWidgets('commits the edited name on Enter', (tester) async {
      String? committed;
      await tester.pumpWidget(
        _host(_NameEditor(initialName: 'memo', onFinish: (v) => committed = v)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'notes');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(committed, 'notes');
    });

    testWidgets('commits the edited name when focus is lost', (tester) async {
      String? committed;
      await tester.pumpWidget(
        _host(_NameEditor(initialName: 'memo', onFinish: (v) => committed = v)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'notes');
      tester.widget<TextField>(find.byType(TextField)).focusNode?.unfocus();
      await tester.pumpAndSettle();

      expect(committed, 'notes');
    });

    // Enter submits and then drops focus; without the guard the name would be
    // committed twice, and the second commit would rename an already-renamed
    // property.
    testWidgets('commits once when Enter is followed by blur', (tester) async {
      var commits = 0;
      await tester.pumpWidget(
        _host(_NameEditor(initialName: 'memo', onFinish: (_) => commits++)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'notes');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      tester.widget<TextField>(find.byType(TextField)).focusNode?.unfocus();
      await tester.pumpAndSettle();

      expect(commits, 1);
    });
  });
}

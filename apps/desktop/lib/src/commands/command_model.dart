/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アプリ内で実行可能なコマンドのモデル
@immutable
class AppCommand {
  final String id; // 例: "navigation.selectActivity"
  final String title; // UI表示用タイトル
  final String category; // 例: "navigation" / "sidebar" / "settings"
  final String? description; // 補足説明（任意）

  /// 実行可否（コンテキスト依存で無効化可能）
  final bool Function(WidgetRef ref)? canExecute;

  /// 実行本体（任意の引数を受ける）
  final Future<dynamic> Function(WidgetRef ref, Map<String, dynamic> args) run;

  const AppCommand({
    required this.id,
    required this.title,
    required this.category,
    required this.run,
    this.description,
    this.canExecute,
  });
}

/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stack_creation_dialog_providers.g.dart';

/// Form name state for stack creation dialog
@riverpod
class FormNameState extends _$FormNameState {
  @override
  String build() => '';

  void setName(String name) {
    state = name;
  }
}

/// Form save path state for stack creation dialog
@riverpod
class FormSavePathState extends _$FormSavePathState {
  @override
  String build() => '';

  void setSavePath(String savePath) {
    state = savePath;
  }
}

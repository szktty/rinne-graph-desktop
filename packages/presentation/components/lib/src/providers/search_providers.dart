/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_providers.g.dart';

/// Provider that manages the current search query string.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String? query) => state = query ?? '';
  void clearQuery() => state = '';
}

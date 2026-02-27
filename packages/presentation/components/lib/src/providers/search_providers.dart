/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_providers.g.dart';

/// Provider that manages the current search query.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  /// Update the search query.
  void updateQuery(String? newQuery) {
    state = newQuery ?? '';
  }

  /// Clear the search query.
  void clearQuery() {
    state = '';
  }
}

/// Provider that manages the state and actions of the search field.
@riverpod
SearchFieldManager searchFieldManager(Ref ref) {
  return SearchFieldManager(ref);
}

/// Search field manager class.
class SearchFieldManager {
  final Ref _ref;

  SearchFieldManager(this._ref);

  /// The current search query.
  String get query => _ref.read(searchQueryProvider);

  /// Update the search query.
  void updateQuery(String? newQuery) {
    _ref.read(searchQueryProvider.notifier).updateQuery(newQuery);
  }

  /// Clear the search query.
  void clearQuery() {
    _ref.read(searchQueryProvider.notifier).clearQuery();
  }
}

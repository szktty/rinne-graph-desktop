/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_providers.dart';

/// A provider that returns a filtered list of items from searchable items and a search query.
///
/// [items] - The list of items to search.
/// [getSearchKeywords] - A function to get search keywords from an item.
Provider<List<T>> searchedItemsProvider<T>({
  required List<T> items,
  required List<String> Function(T) getSearchKeywords,
}) {
  return Provider<List<T>>((ref) {
    final query = ref.watch(searchQueryProvider).toLowerCase();

    if (query.isEmpty) {
      return items;
    }

    return items.where((item) {
      final keywords = getSearchKeywords(item);
      return keywords.any((keyword) => keyword.toLowerCase().contains(query));
    }).toList();
  });
}

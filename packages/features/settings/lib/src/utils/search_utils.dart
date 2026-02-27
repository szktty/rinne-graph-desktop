/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Utility function to search for settings items.
///
/// [items]: The list of items to search.
/// [getSearchKeywords]: A function to get search keywords from each item.
/// [query]: The search query.
///
/// Returns: A list of items that match the query.
List<T> searchSettings<T>({
  required List<T> items,
  required List<String> Function(T) getSearchKeywords,
  required String query,
}) {
  if (query.isEmpty) {
    return items;
  }

  return items.where((item) {
    final keywords = getSearchKeywords(item);
    return keywords.any(
      (keyword) => keyword.toLowerCase().contains(query.toLowerCase()),
    );
  }).toList();
}

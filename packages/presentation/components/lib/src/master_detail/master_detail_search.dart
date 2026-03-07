import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/src/widgets/master_detail/master_detail_search.dart'
    show fondeSearchedItemsProvider;

export 'package:fonde_ui/src/widgets/master_detail/master_detail_search.dart'
    show fondeSearchedItemsProvider;

/// A provider that returns a filtered list of items from searchable items and a search query.
///
/// [items] - The list of items to search.
/// [getSearchKeywords] - A function to get search keywords from an item.
Provider<List<T>> searchedItemsProvider<T>({
  required List<T> items,
  required List<String> Function(T) getSearchKeywords,
}) {
  return fondeSearchedItemsProvider<T>(
    items: items,
    getSearchKeywords: getSearchKeywords,
  );
}

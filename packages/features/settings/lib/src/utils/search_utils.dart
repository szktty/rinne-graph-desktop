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

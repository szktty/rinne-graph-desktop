// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchFieldManagerHash() =>
    r'81e0dd0a7a213391f29c84d97fd43c1903183e84';

/// Provider that manages the state and actions of the search field.
///
/// Copied from [searchFieldManager].
@ProviderFor(searchFieldManager)
final searchFieldManagerProvider =
    AutoDisposeProvider<SearchFieldManager>.internal(
      searchFieldManager,
      name: r'searchFieldManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchFieldManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchFieldManagerRef = AutoDisposeProviderRef<SearchFieldManager>;
String _$searchQueryHash() => r'49c37e916e32687802556ef05ce9c1eebfcbe776';

/// Provider that manages the current search query.
///
/// Copied from [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
      SearchQuery.new,
      name: r'searchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

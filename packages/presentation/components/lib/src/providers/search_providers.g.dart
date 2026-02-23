// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the current search query.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// Provider that manages the current search query.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// Provider that manages the current search query.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'49c37e916e32687802556ef05ce9c1eebfcbe776';

/// Provider that manages the current search query.

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the state and actions of the search field.

@ProviderFor(searchFieldManager)
final searchFieldManagerProvider = SearchFieldManagerProvider._();

/// Provider that manages the state and actions of the search field.

final class SearchFieldManagerProvider
    extends
        $FunctionalProvider<
          SearchFieldManager,
          SearchFieldManager,
          SearchFieldManager
        >
    with $Provider<SearchFieldManager> {
  /// Provider that manages the state and actions of the search field.
  SearchFieldManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFieldManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFieldManagerHash();

  @$internal
  @override
  $ProviderElement<SearchFieldManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchFieldManager create(Ref ref) {
    return searchFieldManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFieldManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFieldManager>(value),
    );
  }
}

String _$searchFieldManagerHash() =>
    r'81e0dd0a7a213391f29c84d97fd43c1903183e84';

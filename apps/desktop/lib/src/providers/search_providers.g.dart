// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider managing exploration options state

@ProviderFor(ExplorationOptionsState)
final explorationOptionsStateProvider = ExplorationOptionsStateProvider._();

/// Provider managing exploration options state
final class ExplorationOptionsStateProvider
    extends $NotifierProvider<ExplorationOptionsState, ExplorationOptions> {
  /// Provider managing exploration options state
  ExplorationOptionsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'explorationOptionsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$explorationOptionsStateHash();

  @$internal
  @override
  ExplorationOptionsState create() => ExplorationOptionsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExplorationOptions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExplorationOptions>(value),
    );
  }
}

String _$explorationOptionsStateHash() =>
    r'd43881cd97bf8c8b12f06c2a139039d242e4556e';

/// Provider managing exploration options state

abstract class _$ExplorationOptionsState extends $Notifier<ExplorationOptions> {
  ExplorationOptions build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExplorationOptions, ExplorationOptions>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExplorationOptions, ExplorationOptions>,
              ExplorationOptions,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing search pattern state

@ProviderFor(SearchPatternState)
final searchPatternStateProvider = SearchPatternStateProvider._();

/// Provider managing search pattern state
final class SearchPatternStateProvider
    extends $NotifierProvider<SearchPatternState, SearchPatternStateData> {
  /// Provider managing search pattern state
  SearchPatternStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchPatternStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchPatternStateHash();

  @$internal
  @override
  SearchPatternState create() => SearchPatternState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchPatternStateData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchPatternStateData>(value),
    );
  }
}

String _$searchPatternStateHash() =>
    r'88026ad6a9d729b1d9f481b23774f4bfb70f1d52';

/// Provider managing search pattern state

abstract class _$SearchPatternState extends $Notifier<SearchPatternStateData> {
  SearchPatternStateData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<SearchPatternStateData, SearchPatternStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchPatternStateData, SearchPatternStateData>,
              SearchPatternStateData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing search result state

@ProviderFor(SearchResultState)
final searchResultStateProvider = SearchResultStateProvider._();

/// Provider managing search result state
final class SearchResultStateProvider
    extends $NotifierProvider<SearchResultState, SearchResult?> {
  /// Provider managing search result state
  SearchResultStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultStateHash();

  @$internal
  @override
  SearchResultState create() => SearchResultState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchResult?>(value),
    );
  }
}

String _$searchResultStateHash() => r'd90dee229910fb74783197092cbb010b2cb6a91e';

/// Provider managing search result state

abstract class _$SearchResultState extends $Notifier<SearchResult?> {
  SearchResult? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchResult?, SearchResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchResult?, SearchResult?>,
              SearchResult?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing search execution state

@ProviderFor(SearchExecuting)
final searchExecutingProvider = SearchExecutingProvider._();

/// Provider managing search execution state
final class SearchExecutingProvider
    extends $NotifierProvider<SearchExecuting, bool> {
  /// Provider managing search execution state
  SearchExecutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchExecutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchExecutingHash();

  @$internal
  @override
  SearchExecuting create() => SearchExecuting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$searchExecutingHash() => r'5a2ddf0a9f3fc3e0b56fc706df63362976403ca0';

/// Provider managing search execution state

abstract class _$SearchExecuting extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing search error state

@ProviderFor(SearchError)
final searchErrorProvider = SearchErrorProvider._();

/// Provider managing search error state
final class SearchErrorProvider
    extends $NotifierProvider<SearchError, String?> {
  /// Provider managing search error state
  SearchErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchErrorHash();

  @$internal
  @override
  SearchError create() => SearchError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$searchErrorHash() => r'2aedb9afd5490b01a8ab10cb39940cf80fd04b56';

/// Provider managing search error state

abstract class _$SearchError extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Search execution service provider

@ProviderFor(searchExecutionService)
final searchExecutionServiceProvider = SearchExecutionServiceProvider._();

/// Search execution service provider

final class SearchExecutionServiceProvider
    extends
        $FunctionalProvider<
          SearchExecutionService?,
          SearchExecutionService?,
          SearchExecutionService?
        >
    with $Provider<SearchExecutionService?> {
  /// Search execution service provider
  SearchExecutionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchExecutionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchExecutionServiceHash();

  @$internal
  @override
  $ProviderElement<SearchExecutionService?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchExecutionService? create(Ref ref) {
    return searchExecutionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchExecutionService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchExecutionService?>(value),
    );
  }
}

String _$searchExecutionServiceHash() =>
    r'a58b8688c789f70eb1c98714068d9a41b40819e4';

/// Search pattern translation service provider

@ProviderFor(searchPatternTranslator)
final searchPatternTranslatorProvider = SearchPatternTranslatorProvider._();

/// Search pattern translation service provider

final class SearchPatternTranslatorProvider
    extends
        $FunctionalProvider<
          SearchPatternTranslator,
          SearchPatternTranslator,
          SearchPatternTranslator
        >
    with $Provider<SearchPatternTranslator> {
  /// Search pattern translation service provider
  SearchPatternTranslatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchPatternTranslatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchPatternTranslatorHash();

  @$internal
  @override
  $ProviderElement<SearchPatternTranslator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchPatternTranslator create(Ref ref) {
    return searchPatternTranslator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchPatternTranslator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchPatternTranslator>(value),
    );
  }
}

String _$searchPatternTranslatorHash() =>
    r'b10ded99d677a6c0c8cfe57cb2ee228f29118cb1';

/// Keyword search input text

@ProviderFor(KeywordSearchQuery)
final keywordSearchQueryProvider = KeywordSearchQueryProvider._();

/// Keyword search input text
final class KeywordSearchQueryProvider
    extends $NotifierProvider<KeywordSearchQuery, String> {
  /// Keyword search input text
  KeywordSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordSearchQueryHash();

  @$internal
  @override
  KeywordSearchQuery create() => KeywordSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$keywordSearchQueryHash() =>
    r'02f59f667c9b5f5c6ae94fea6b652fca99e79180';

/// Keyword search input text

abstract class _$KeywordSearchQuery extends $Notifier<String> {
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

@ProviderFor(KeywordSearchFiltersState)
final keywordSearchFiltersStateProvider = KeywordSearchFiltersStateProvider._();

final class KeywordSearchFiltersStateProvider
    extends $NotifierProvider<KeywordSearchFiltersState, KeywordSearchFilters> {
  KeywordSearchFiltersStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordSearchFiltersStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordSearchFiltersStateHash();

  @$internal
  @override
  KeywordSearchFiltersState create() => KeywordSearchFiltersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeywordSearchFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeywordSearchFilters>(value),
    );
  }
}

String _$keywordSearchFiltersStateHash() =>
    r'81e75bf46e017349b5f2bba238d8fcd76eed57cb';

abstract class _$KeywordSearchFiltersState
    extends $Notifier<KeywordSearchFilters> {
  KeywordSearchFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<KeywordSearchFilters, KeywordSearchFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KeywordSearchFilters, KeywordSearchFilters>,
              KeywordSearchFilters,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Keyword search result (separate from Path Search result)

@ProviderFor(KeywordSearchResult)
final keywordSearchResultProvider = KeywordSearchResultProvider._();

/// Keyword search result (separate from Path Search result)
final class KeywordSearchResultProvider
    extends $NotifierProvider<KeywordSearchResult, SearchResult?> {
  /// Keyword search result (separate from Path Search result)
  KeywordSearchResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordSearchResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordSearchResultHash();

  @$internal
  @override
  KeywordSearchResult create() => KeywordSearchResult();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchResult?>(value),
    );
  }
}

String _$keywordSearchResultHash() =>
    r'3dca6e3fa92aabd5c3d768c1b406c6ccea02079c';

/// Keyword search result (separate from Path Search result)

abstract class _$KeywordSearchResult extends $Notifier<SearchResult?> {
  SearchResult? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchResult?, SearchResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchResult?, SearchResult?>,
              SearchResult?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Keyword search executing flag (separate from Path Search)

@ProviderFor(KeywordSearchExecuting)
final keywordSearchExecutingProvider = KeywordSearchExecutingProvider._();

/// Keyword search executing flag (separate from Path Search)
final class KeywordSearchExecutingProvider
    extends $NotifierProvider<KeywordSearchExecuting, bool> {
  /// Keyword search executing flag (separate from Path Search)
  KeywordSearchExecutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordSearchExecutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordSearchExecutingHash();

  @$internal
  @override
  KeywordSearchExecuting create() => KeywordSearchExecuting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$keywordSearchExecutingHash() =>
    r'fd2487c2ba23320cf9452b2dfe4f314322249d30';

/// Keyword search executing flag (separate from Path Search)

abstract class _$KeywordSearchExecuting extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Available node labels from real graph data

@ProviderFor(availableNodeLabels)
final availableNodeLabelsProvider = AvailableNodeLabelsProvider._();

/// Available node labels from real graph data

final class AvailableNodeLabelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Available node labels from real graph data
  AvailableNodeLabelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableNodeLabelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableNodeLabelsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return availableNodeLabels(ref);
  }
}

String _$availableNodeLabelsHash() =>
    r'db4e24c0ec8ca23db3f210e5578c6a7750759814';

/// Available link types from real graph data

@ProviderFor(availableLinkTypes)
final availableLinkTypesProvider = AvailableLinkTypesProvider._();

/// Available link types from real graph data

final class AvailableLinkTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Available link types from real graph data
  AvailableLinkTypesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableLinkTypesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableLinkTypesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return availableLinkTypes(ref);
  }
}

String _$availableLinkTypesHash() =>
    r'992cd555a34163fb01b728b532e214af21a3ea76';

@ProviderFor(SearchHighlight)
final searchHighlightProvider = SearchHighlightProvider._();

final class SearchHighlightProvider
    extends $NotifierProvider<SearchHighlight, SearchHighlightState> {
  SearchHighlightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchHighlightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchHighlightHash();

  @$internal
  @override
  SearchHighlight create() => SearchHighlight();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchHighlightState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchHighlightState>(value),
    );
  }
}

String _$searchHighlightHash() => r'3c4fdbc5bb2257f66ac290d0fac99a51028889a6';

abstract class _$SearchHighlight extends $Notifier<SearchHighlightState> {
  SearchHighlightState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchHighlightState, SearchHighlightState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchHighlightState, SearchHighlightState>,
              SearchHighlightState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Search execution action provider

@ProviderFor(SearchActions)
final searchActionsProvider = SearchActionsProvider._();

/// Search execution action provider
final class SearchActionsProvider
    extends $NotifierProvider<SearchActions, void> {
  /// Search execution action provider
  SearchActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchActionsHash();

  @$internal
  @override
  SearchActions create() => SearchActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$searchActionsHash() => r'85a2d060cc0ec790766226b18da689026f08b18b';

/// Search execution action provider

abstract class _$SearchActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

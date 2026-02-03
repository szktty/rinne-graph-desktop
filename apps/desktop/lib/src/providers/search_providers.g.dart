// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchExecutionServiceHash() =>
    r'388cb9004516275722aacf0a6bd9cc19a1cb2dc7';

/// Search execution service provider
///
/// Copied from [searchExecutionService].
@ProviderFor(searchExecutionService)
final searchExecutionServiceProvider =
    AutoDisposeProvider<SearchExecutionService?>.internal(
      searchExecutionService,
      name: r'searchExecutionServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchExecutionServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchExecutionServiceRef =
    AutoDisposeProviderRef<SearchExecutionService?>;
String _$searchPatternTranslatorHash() =>
    r'a7cc3a75500ceefd368d8f15d510eb86e6b61485';

/// Search pattern translation service provider
///
/// Copied from [searchPatternTranslator].
@ProviderFor(searchPatternTranslator)
final searchPatternTranslatorProvider =
    AutoDisposeProvider<SearchPatternTranslator>.internal(
      searchPatternTranslator,
      name: r'searchPatternTranslatorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchPatternTranslatorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchPatternTranslatorRef =
    AutoDisposeProviderRef<SearchPatternTranslator>;
String _$explorationOptionsStateHash() =>
    r'd43881cd97bf8c8b12f06c2a139039d242e4556e';

/// Provider managing exploration options state
///
/// Copied from [ExplorationOptionsState].
@ProviderFor(ExplorationOptionsState)
final explorationOptionsStateProvider = AutoDisposeNotifierProvider<
  ExplorationOptionsState,
  ExplorationOptions
>.internal(
  ExplorationOptionsState.new,
  name: r'explorationOptionsStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$explorationOptionsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExplorationOptionsState = AutoDisposeNotifier<ExplorationOptions>;
String _$searchPatternStateHash() =>
    r'88026ad6a9d729b1d9f481b23774f4bfb70f1d52';

/// Provider managing search pattern state
///
/// Copied from [SearchPatternState].
@ProviderFor(SearchPatternState)
final searchPatternStateProvider = AutoDisposeNotifierProvider<
  SearchPatternState,
  SearchPatternStateData
>.internal(
  SearchPatternState.new,
  name: r'searchPatternStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchPatternStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchPatternState = AutoDisposeNotifier<SearchPatternStateData>;
String _$searchResultStateHash() => r'd90dee229910fb74783197092cbb010b2cb6a91e';

/// Provider managing search result state
///
/// Copied from [SearchResultState].
@ProviderFor(SearchResultState)
final searchResultStateProvider =
    AutoDisposeNotifierProvider<SearchResultState, SearchResult?>.internal(
      SearchResultState.new,
      name: r'searchResultStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchResultStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchResultState = AutoDisposeNotifier<SearchResult?>;
String _$searchExecutingHash() => r'5a2ddf0a9f3fc3e0b56fc706df63362976403ca0';

/// Provider managing search execution state
///
/// Copied from [SearchExecuting].
@ProviderFor(SearchExecuting)
final searchExecutingProvider =
    AutoDisposeNotifierProvider<SearchExecuting, bool>.internal(
      SearchExecuting.new,
      name: r'searchExecutingProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchExecutingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchExecuting = AutoDisposeNotifier<bool>;
String _$searchErrorHash() => r'2aedb9afd5490b01a8ab10cb39940cf80fd04b56';

/// Provider managing search error state
///
/// Copied from [SearchError].
@ProviderFor(SearchError)
final searchErrorProvider =
    AutoDisposeNotifierProvider<SearchError, String?>.internal(
      SearchError.new,
      name: r'searchErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchError = AutoDisposeNotifier<String?>;
String _$searchActionsHash() => r'85a2d060cc0ec790766226b18da689026f08b18b';

/// Search execution action provider
///
/// Copied from [SearchActions].
@ProviderFor(SearchActions)
final searchActionsProvider =
    AutoDisposeNotifierProvider<SearchActions, void>.internal(
      SearchActions.new,
      name: r'searchActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

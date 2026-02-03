// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_status_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedEntityInfoHash() =>
    r'3d9d68926bb0bbcf0a30fc06adcaa69790b46567';

/// Provider that provides detailed information about the selected entity
///
/// Copied from [SelectedEntityInfo].
@ProviderFor(SelectedEntityInfo)
final selectedEntityInfoProvider = AutoDisposeAsyncNotifierProvider<
  SelectedEntityInfo,
  SelectedEntityData?
>.internal(
  SelectedEntityInfo.new,
  name: r'selectedEntityInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedEntityInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedEntityInfo = AutoDisposeAsyncNotifier<SelectedEntityData?>;
String _$graphStatisticsInfoHash() =>
    r'6e29362e09d5625d69fb217ba03dff951ed4e1ee';

/// Provider that provides graph statistics information
///
/// Copied from [GraphStatisticsInfo].
@ProviderFor(GraphStatisticsInfo)
final graphStatisticsInfoProvider = AutoDisposeAsyncNotifierProvider<
  GraphStatisticsInfo,
  GraphStatisticsData?
>.internal(
  GraphStatisticsInfo.new,
  name: r'graphStatisticsInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$graphStatisticsInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GraphStatisticsInfo = AutoDisposeAsyncNotifier<GraphStatisticsData?>;
String _$searchFilterStateHash() => r'ab89552d2e51dc4c375d34315a936c467bf8618f';

/// Provider that manages search and filter state
///
/// Copied from [SearchFilterState].
@ProviderFor(SearchFilterState)
final searchFilterStateProvider =
    AutoDisposeNotifierProvider<SearchFilterState, SearchFilterData>.internal(
      SearchFilterState.new,
      name: r'searchFilterStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchFilterStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchFilterState = AutoDisposeNotifier<SearchFilterData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

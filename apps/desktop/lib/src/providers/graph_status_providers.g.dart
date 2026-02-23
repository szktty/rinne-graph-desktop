// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_status_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides detailed information about the selected entity

@ProviderFor(SelectedEntityInfo)
final selectedEntityInfoProvider = SelectedEntityInfoProvider._();

/// Provider that provides detailed information about the selected entity
final class SelectedEntityInfoProvider
    extends $AsyncNotifierProvider<SelectedEntityInfo, SelectedEntityData?> {
  /// Provider that provides detailed information about the selected entity
  SelectedEntityInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityInfoHash();

  @$internal
  @override
  SelectedEntityInfo create() => SelectedEntityInfo();
}

String _$selectedEntityInfoHash() =>
    r'3d9d68926bb0bbcf0a30fc06adcaa69790b46567';

/// Provider that provides detailed information about the selected entity

abstract class _$SelectedEntityInfo
    extends $AsyncNotifier<SelectedEntityData?> {
  FutureOr<SelectedEntityData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SelectedEntityData?>, SelectedEntityData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SelectedEntityData?>, SelectedEntityData?>,
              AsyncValue<SelectedEntityData?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that provides graph statistics information

@ProviderFor(GraphStatisticsInfo)
final graphStatisticsInfoProvider = GraphStatisticsInfoProvider._();

/// Provider that provides graph statistics information
final class GraphStatisticsInfoProvider
    extends $AsyncNotifierProvider<GraphStatisticsInfo, GraphStatisticsData?> {
  /// Provider that provides graph statistics information
  GraphStatisticsInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphStatisticsInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphStatisticsInfoHash();

  @$internal
  @override
  GraphStatisticsInfo create() => GraphStatisticsInfo();
}

String _$graphStatisticsInfoHash() =>
    r'6e29362e09d5625d69fb217ba03dff951ed4e1ee';

/// Provider that provides graph statistics information

abstract class _$GraphStatisticsInfo
    extends $AsyncNotifier<GraphStatisticsData?> {
  FutureOr<GraphStatisticsData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<GraphStatisticsData?>, GraphStatisticsData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<GraphStatisticsData?>,
                GraphStatisticsData?
              >,
              AsyncValue<GraphStatisticsData?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages search and filter state

@ProviderFor(SearchFilterState)
final searchFilterStateProvider = SearchFilterStateProvider._();

/// Provider that manages search and filter state
final class SearchFilterStateProvider
    extends $NotifierProvider<SearchFilterState, SearchFilterData> {
  /// Provider that manages search and filter state
  SearchFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFilterStateHash();

  @$internal
  @override
  SearchFilterState create() => SearchFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilterData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilterData>(value),
    );
  }
}

String _$searchFilterStateHash() => r'ab89552d2e51dc4c375d34315a936c467bf8618f';

/// Provider that manages search and filter state

abstract class _$SearchFilterState extends $Notifier<SearchFilterData> {
  SearchFilterData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchFilterData, SearchFilterData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilterData, SearchFilterData>,
              SearchFilterData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

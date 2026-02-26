// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_view_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the tab view state of the entity editor

@ProviderFor(TabViewState)
final tabViewStateProvider = TabViewStateProvider._();

/// Provider that manages the tab view state of the entity editor
final class TabViewStateProvider
    extends $NotifierProvider<TabViewState, String?> {
  /// Provider that manages the tab view state of the entity editor
  TabViewStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tabViewStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tabViewStateHash();

  @$internal
  @override
  TabViewState create() => TabViewState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$tabViewStateHash() => r'0b990e1279b9fc47b8b05deb955773be39f62bdf';

/// Provider that manages the tab view state of the entity editor

abstract class _$TabViewState extends $Notifier<String?> {
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

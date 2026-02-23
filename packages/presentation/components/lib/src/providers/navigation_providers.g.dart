// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state of groups.

@ProviderFor(NavigationState)
final navigationStateProvider = NavigationStateProvider._();

/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state of groups.
final class NavigationStateProvider
    extends $NotifierProvider<NavigationState, NavigationStateData> {
  /// Provider for managing navigation state.
  ///
  /// Manages the selection state of navigation items and the expansion state of groups.
  NavigationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationStateHash();

  @$internal
  @override
  NavigationState create() => NavigationState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NavigationStateData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NavigationStateData>(value),
    );
  }
}

String _$navigationStateHash() => r'24ecf9fbd99ba50d4d8d08aa20a5309dabd566dd';

/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state of groups.

abstract class _$NavigationState extends $Notifier<NavigationStateData> {
  NavigationStateData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NavigationStateData, NavigationStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NavigationStateData, NavigationStateData>,
              NavigationStateData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

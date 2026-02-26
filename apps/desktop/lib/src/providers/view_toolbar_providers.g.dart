// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_toolbar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// View type state management provider

@ProviderFor(ViewToolbarState)
final viewToolbarStateProvider = ViewToolbarStateProvider._();

/// View type state management provider
final class ViewToolbarStateProvider
    extends $NotifierProvider<ViewToolbarState, String> {
  /// View type state management provider
  ViewToolbarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'viewToolbarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$viewToolbarStateHash();

  @$internal
  @override
  ViewToolbarState create() => ViewToolbarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$viewToolbarStateHash() => r'dcb2f19f50e3ad8bb51e119e103fed0b43574a0a';

/// View type state management provider

abstract class _$ViewToolbarState extends $Notifier<String> {
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

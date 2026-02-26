// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_creation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tap-based link creation mode state provider

@ProviderFor(TapLinkCreation)
final tapLinkCreationProvider = TapLinkCreationProvider._();

/// Tap-based link creation mode state provider
final class TapLinkCreationProvider
    extends $NotifierProvider<TapLinkCreation, TapLinkCreationState> {
  /// Tap-based link creation mode state provider
  TapLinkCreationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tapLinkCreationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tapLinkCreationHash();

  @$internal
  @override
  TapLinkCreation create() => TapLinkCreation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TapLinkCreationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TapLinkCreationState>(value),
    );
  }
}

String _$tapLinkCreationHash() => r'1d5ff73c42bc249b766e3791f4ff7e1575196a20';

/// Tap-based link creation mode state provider

abstract class _$TapLinkCreation extends $Notifier<TapLinkCreationState> {
  TapLinkCreationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TapLinkCreationState, TapLinkCreationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TapLinkCreationState, TapLinkCreationState>,
              TapLinkCreationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

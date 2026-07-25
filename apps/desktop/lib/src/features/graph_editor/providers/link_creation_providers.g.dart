// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_creation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Link creation state provider.
///
/// A single state machine backs all three entry points — the toolbar button,
/// Alt+drag and Alt+tap — because they differ only in how they start and what
/// they do after committing.

@ProviderFor(TapLinkCreation)
final tapLinkCreationProvider = TapLinkCreationProvider._();

/// Link creation state provider.
///
/// A single state machine backs all three entry points — the toolbar button,
/// Alt+drag and Alt+tap — because they differ only in how they start and what
/// they do after committing.
final class TapLinkCreationProvider
    extends $NotifierProvider<TapLinkCreation, TapLinkCreationState> {
  /// Link creation state provider.
  ///
  /// A single state machine backs all three entry points — the toolbar button,
  /// Alt+drag and Alt+tap — because they differ only in how they start and what
  /// they do after committing.
  TapLinkCreationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tapLinkCreationProvider',
        isAutoDispose: false,
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

String _$tapLinkCreationHash() => r'85ded8dc866b803afd76cd7be2f80395b1433227';

/// Link creation state provider.
///
/// A single state machine backs all three entry points — the toolbar button,
/// Alt+drag and Alt+tap — because they differ only in how they start and what
/// they do after committing.

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

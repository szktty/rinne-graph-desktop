// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_creation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Link creation mode state provider

@ProviderFor(LinkCreationMode)
final linkCreationModeProvider = LinkCreationModeProvider._();

/// Link creation mode state provider
final class LinkCreationModeProvider
    extends $NotifierProvider<LinkCreationMode, LinkCreationState> {
  /// Link creation mode state provider
  LinkCreationModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkCreationModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkCreationModeHash();

  @$internal
  @override
  LinkCreationMode create() => LinkCreationMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkCreationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkCreationState>(value),
    );
  }
}

String _$linkCreationModeHash() => r'1988170108a1b49c9f6e1830787c5eaf9dbda1be';

/// Link creation mode state provider

abstract class _$LinkCreationMode extends $Notifier<LinkCreationState> {
  LinkCreationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LinkCreationState, LinkCreationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LinkCreationState, LinkCreationState>,
              LinkCreationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for the pointer position during drag

@ProviderFor(LinkCreationDragPosition)
final linkCreationDragPositionProvider = LinkCreationDragPositionProvider._();

/// Provider for the pointer position during drag
final class LinkCreationDragPositionProvider
    extends $NotifierProvider<LinkCreationDragPosition, Offset?> {
  /// Provider for the pointer position during drag
  LinkCreationDragPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkCreationDragPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkCreationDragPositionHash();

  @$internal
  @override
  LinkCreationDragPosition create() => LinkCreationDragPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Offset? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Offset?>(value),
    );
  }
}

String _$linkCreationDragPositionHash() =>
    r'5b275cfb2fb08c38fa9acdd0ddb0d2b28536dc1b';

/// Provider for the pointer position during drag

abstract class _$LinkCreationDragPosition extends $Notifier<Offset?> {
  Offset? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Offset?, Offset?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Offset?, Offset?>,
              Offset?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

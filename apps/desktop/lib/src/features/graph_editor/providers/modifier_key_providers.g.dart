// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_key_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Alt/Option was held when the current gesture started.
///
/// Sampled at pointer-down rather than read live, because plough dispatches
/// `onTap` from behind its tap-recognition timer: by the time a behavior runs,
/// the user may already have released the key. A `Listener` runs before the
/// gesture arena resolves, so it observes the modifier at the instant the
/// gesture physically began.

@ProviderFor(AltPressed)
final altPressedProvider = AltPressedProvider._();

/// Whether Alt/Option was held when the current gesture started.
///
/// Sampled at pointer-down rather than read live, because plough dispatches
/// `onTap` from behind its tap-recognition timer: by the time a behavior runs,
/// the user may already have released the key. A `Listener` runs before the
/// gesture arena resolves, so it observes the modifier at the instant the
/// gesture physically began.
final class AltPressedProvider extends $NotifierProvider<AltPressed, bool> {
  /// Whether Alt/Option was held when the current gesture started.
  ///
  /// Sampled at pointer-down rather than read live, because plough dispatches
  /// `onTap` from behind its tap-recognition timer: by the time a behavior runs,
  /// the user may already have released the key. A `Listener` runs before the
  /// gesture arena resolves, so it observes the modifier at the instant the
  /// gesture physically began.
  AltPressedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'altPressedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$altPressedHash();

  @$internal
  @override
  AltPressed create() => AltPressed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$altPressedHash() => r'7662d1b9cca3e4e8fc4ff89b3a0a8049a99ebbcc';

/// Whether Alt/Option was held when the current gesture started.
///
/// Sampled at pointer-down rather than read live, because plough dispatches
/// `onTap` from behind its tap-recognition timer: by the time a behavior runs,
/// the user may already have released the key. A `Listener` runs before the
/// gesture arena resolves, so it observes the modifier at the instant the
/// gesture physically began.

abstract class _$AltPressed extends $Notifier<bool> {
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

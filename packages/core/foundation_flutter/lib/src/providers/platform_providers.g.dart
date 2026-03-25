// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies platform information.

@ProviderFor(isMacOSPlatform)
final isMacOSPlatformProvider = IsMacOSPlatformProvider._();

/// Provider that supplies platform information.

final class IsMacOSPlatformProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that supplies platform information.
  IsMacOSPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isMacOSPlatformProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isMacOSPlatformHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isMacOSPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isMacOSPlatformHash() => r'0ee2515c413e87f32493fe8625b985ad3e0c97b7';

/// Class for managing platform information.

@ProviderFor(platformInfo)
final platformInfoProvider = PlatformInfoProvider._();

/// Class for managing platform information.

final class PlatformInfoProvider
    extends $FunctionalProvider<PlatformInfo, PlatformInfo, PlatformInfo>
    with $Provider<PlatformInfo> {
  /// Class for managing platform information.
  PlatformInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformInfoHash();

  @$internal
  @override
  $ProviderElement<PlatformInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlatformInfo create(Ref ref) {
    return platformInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlatformInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlatformInfo>(value),
    );
  }
}

String _$platformInfoHash() => r'7d0f569a5616715d1fc30f10d58a480afec7e794';

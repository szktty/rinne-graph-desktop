// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies an instance of VersionService.

@ProviderFor(versionService)
final versionServiceProvider = VersionServiceProvider._();

/// Provider that supplies an instance of VersionService.

final class VersionServiceProvider
    extends $FunctionalProvider<VersionService, VersionService, VersionService>
    with $Provider<VersionService> {
  /// Provider that supplies an instance of VersionService.
  VersionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionServiceHash();

  @$internal
  @override
  $ProviderElement<VersionService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VersionService create(Ref ref) {
    return versionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionService>(value),
    );
  }
}

String _$versionServiceHash() => r'b882b107acb68f577faca322335c28183cb7e9a9';

/// Provider that asynchronously retrieves version information.

@ProviderFor(versionInfo)
final versionInfoProvider = VersionInfoProvider._();

/// Provider that asynchronously retrieves version information.

final class VersionInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<VersionInfo>,
          VersionInfo,
          FutureOr<VersionInfo>
        >
    with $FutureModifier<VersionInfo>, $FutureProvider<VersionInfo> {
  /// Provider that asynchronously retrieves version information.
  VersionInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionInfoHash();

  @$internal
  @override
  $FutureProviderElement<VersionInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VersionInfo> create(Ref ref) {
    return versionInfo(ref);
  }
}

String _$versionInfoHash() => r'31ab194eb982e04db1e16c20a42d1522422744c2';

/// Provider that asynchronously retrieves the technical version string.

@ProviderFor(technicalVersionString)
final technicalVersionStringProvider = TechnicalVersionStringProvider._();

/// Provider that asynchronously retrieves the technical version string.

final class TechnicalVersionStringProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Provider that asynchronously retrieves the technical version string.
  TechnicalVersionStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'technicalVersionStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$technicalVersionStringHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return technicalVersionString(ref);
  }
}

String _$technicalVersionStringHash() =>
    r'9efe42264396fdef63498115bd72e55045666aaf';

/// Provider that asynchronously retrieves the display version string.

@ProviderFor(displayVersionString)
final displayVersionStringProvider = DisplayVersionStringProvider._();

/// Provider that asynchronously retrieves the display version string.

final class DisplayVersionStringProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Provider that asynchronously retrieves the display version string.
  DisplayVersionStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayVersionStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayVersionStringHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return displayVersionString(ref);
  }
}

String _$displayVersionStringHash() =>
    r'402b7473c9f9ea6aa7ae21f65f70186bc0d523a1';

/// System information service provider.

@ProviderFor(systemInfoService)
final systemInfoServiceProvider = SystemInfoServiceProvider._();

/// System information service provider.

final class SystemInfoServiceProvider
    extends
        $FunctionalProvider<
          SystemInfoService,
          SystemInfoService,
          SystemInfoService
        >
    with $Provider<SystemInfoService> {
  /// System information service provider.
  SystemInfoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemInfoServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemInfoServiceHash();

  @$internal
  @override
  $ProviderElement<SystemInfoService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemInfoService create(Ref ref) {
    return systemInfoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemInfoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemInfoService>(value),
    );
  }
}

String _$systemInfoServiceHash() => r'53bfae676949fb6c9fe35dc5d9147e5257b40d04';

/// Provider that retrieves system information.

@ProviderFor(systemInfo)
final systemInfoProvider = SystemInfoProvider._();

/// Provider that retrieves system information.

final class SystemInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<SystemInfo>,
          SystemInfo,
          FutureOr<SystemInfo>
        >
    with $FutureModifier<SystemInfo>, $FutureProvider<SystemInfo> {
  /// Provider that retrieves system information.
  SystemInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemInfoHash();

  @$internal
  @override
  $FutureProviderElement<SystemInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SystemInfo> create(Ref ref) {
    return systemInfo(ref);
  }
}

String _$systemInfoHash() => r'2b219668c795c7efbc015e1196702c833a834488';

/// Provider that retrieves the system information string for bug reports.

@ProviderFor(bugReportSystemInfo)
final bugReportSystemInfoProvider = BugReportSystemInfoProvider._();

/// Provider that retrieves the system information string for bug reports.

final class BugReportSystemInfoProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Provider that retrieves the system information string for bug reports.
  BugReportSystemInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bugReportSystemInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bugReportSystemInfoHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return bugReportSystemInfo(ref);
  }
}

String _$bugReportSystemInfoHash() =>
    r'a21a721f6b45404d880dc245fddac37a687b794a';

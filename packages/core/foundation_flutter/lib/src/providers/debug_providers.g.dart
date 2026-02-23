// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the state of debug mode.
///
/// Controls the debug features of the entire application.
/// Typically disabled in production, enabled only in development and test environments.

@ProviderFor(DebugMode)
final debugModeProvider = DebugModeProvider._();

/// Provider that manages the state of debug mode.
///
/// Controls the debug features of the entire application.
/// Typically disabled in production, enabled only in development and test environments.
final class DebugModeProvider extends $NotifierProvider<DebugMode, bool> {
  /// Provider that manages the state of debug mode.
  ///
  /// Controls the debug features of the entire application.
  /// Typically disabled in production, enabled only in development and test environments.
  DebugModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugModeHash();

  @$internal
  @override
  DebugMode create() => DebugMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$debugModeHash() => r'311557bc38897310cf9aae5cc8c4f92b68506968';

/// Provider that manages the state of debug mode.
///
/// Controls the debug features of the entire application.
/// Typically disabled in production, enabled only in development and test environments.

abstract class _$DebugMode extends $Notifier<bool> {
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

/// Provider that manages the state of debug logging.
///
/// Controls the output of debug logs.
/// If debug mode is disabled, logs will not be output regardless of this flag.

@ProviderFor(DebugLogging)
final debugLoggingProvider = DebugLoggingProvider._();

/// Provider that manages the state of debug logging.
///
/// Controls the output of debug logs.
/// If debug mode is disabled, logs will not be output regardless of this flag.
final class DebugLoggingProvider extends $NotifierProvider<DebugLogging, bool> {
  /// Provider that manages the state of debug logging.
  ///
  /// Controls the output of debug logs.
  /// If debug mode is disabled, logs will not be output regardless of this flag.
  DebugLoggingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugLoggingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugLoggingHash();

  @$internal
  @override
  DebugLogging create() => DebugLogging();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$debugLoggingHash() => r'62a5190266c043becf961da32a498fd7004f4bbb';

/// Provider that manages the state of debug logging.
///
/// Controls the output of debug logs.
/// If debug mode is disabled, logs will not be output regardless of this flag.

abstract class _$DebugLogging extends $Notifier<bool> {
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

/// Provider that determines if debug features are available.
///
/// Returns true if it's a debug build or debug mode is explicitly enabled.

@ProviderFor(debugAvailable)
final debugAvailableProvider = DebugAvailableProvider._();

/// Provider that determines if debug features are available.
///
/// Returns true if it's a debug build or debug mode is explicitly enabled.

final class DebugAvailableProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that determines if debug features are available.
  ///
  /// Returns true if it's a debug build or debug mode is explicitly enabled.
  DebugAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return debugAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$debugAvailableHash() => r'80e140ac6f6225120a82480b8f44339727ea2c60';

/// Provider that determines if debug logs are enabled.
///
/// Returns true if debug features are available and debug logging is enabled.

@ProviderFor(debugLogEnabled)
final debugLogEnabledProvider = DebugLogEnabledProvider._();

/// Provider that determines if debug logs are enabled.
///
/// Returns true if debug features are available and debug logging is enabled.

final class DebugLogEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that determines if debug logs are enabled.
  ///
  /// Returns true if debug features are available and debug logging is enabled.
  DebugLogEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugLogEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugLogEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return debugLogEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$debugLogEnabledHash() => r'bbc4d025875355749b9c127a2299979442825c20';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$debugAvailableHash() => r'80e140ac6f6225120a82480b8f44339727ea2c60';

/// Provider that determines if debug features are available.
///
/// Returns true if it's a debug build or debug mode is explicitly enabled.
///
/// Copied from [debugAvailable].
@ProviderFor(debugAvailable)
final debugAvailableProvider = AutoDisposeProvider<bool>.internal(
  debugAvailable,
  name: r'debugAvailableProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$debugAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DebugAvailableRef = AutoDisposeProviderRef<bool>;
String _$debugLogEnabledHash() => r'bbc4d025875355749b9c127a2299979442825c20';

/// Provider that determines if debug logs are enabled.
///
/// Returns true if debug features are available and debug logging is enabled.
///
/// Copied from [debugLogEnabled].
@ProviderFor(debugLogEnabled)
final debugLogEnabledProvider = AutoDisposeProvider<bool>.internal(
  debugLogEnabled,
  name: r'debugLogEnabledProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$debugLogEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DebugLogEnabledRef = AutoDisposeProviderRef<bool>;
String _$debugModeHash() => r'311557bc38897310cf9aae5cc8c4f92b68506968';

/// Provider that manages the state of debug mode.
///
/// Controls the debug features of the entire application.
/// Typically disabled in production, enabled only in development and test environments.
///
/// Copied from [DebugMode].
@ProviderFor(DebugMode)
final debugModeProvider = AutoDisposeNotifierProvider<DebugMode, bool>.internal(
  DebugMode.new,
  name: r'debugModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$debugModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DebugMode = AutoDisposeNotifier<bool>;
String _$debugLoggingHash() => r'62a5190266c043becf961da32a498fd7004f4bbb';

/// Provider that manages the state of debug logging.
///
/// Controls the output of debug logs.
/// If debug mode is disabled, logs will not be output regardless of this flag.
///
/// Copied from [DebugLogging].
@ProviderFor(DebugLogging)
final debugLoggingProvider =
    AutoDisposeNotifierProvider<DebugLogging, bool>.internal(
      DebugLogging.new,
      name: r'debugLoggingProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$debugLoggingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DebugLogging = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

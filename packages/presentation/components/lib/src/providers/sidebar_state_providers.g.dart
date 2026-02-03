// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contextualSecondarySidebarStateHash() =>
    r'96e8a7487c59b14e817408e588b71ec7ecc2faef';

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.
///
/// Copied from [contextualSecondarySidebarState].
@ProviderFor(contextualSecondarySidebarState)
final contextualSecondarySidebarStateProvider =
    AutoDisposeProvider<bool>.internal(
      contextualSecondarySidebarState,
      name: r'contextualSecondarySidebarStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$contextualSecondarySidebarStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContextualSecondarySidebarStateRef = AutoDisposeProviderRef<bool>;
String _$perScreenSecondarySidebarStateHash() =>
    r'bcc0a6654129f13732784d73b5e9696d0cd02fb2';

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.
///
/// Copied from [PerScreenSecondarySidebarState].
@ProviderFor(PerScreenSecondarySidebarState)
final perScreenSecondarySidebarStateProvider = AutoDisposeNotifierProvider<
  PerScreenSecondarySidebarState,
  Map<int, bool>
>.internal(
  PerScreenSecondarySidebarState.new,
  name: r'perScreenSecondarySidebarStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$perScreenSecondarySidebarStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PerScreenSecondarySidebarState = AutoDisposeNotifier<Map<int, bool>>;
String _$primarySidebarStateHash() =>
    r'949060907b3824817cda678f7b573d6c82221da9';

/// Provider that manages the visibility state of the primary sidebar (left side).
///
/// Copied from [PrimarySidebarState].
@ProviderFor(PrimarySidebarState)
final primarySidebarStateProvider =
    AutoDisposeNotifierProvider<PrimarySidebarState, bool>.internal(
      PrimarySidebarState.new,
      name: r'primarySidebarStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$primarySidebarStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PrimarySidebarState = AutoDisposeNotifier<bool>;
String _$secondarySidebarStateHash() =>
    r'6c522f5354c8d7fa1a0ff9282b9bd0c16ea53d51';

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.
///
/// Copied from [SecondarySidebarState].
@ProviderFor(SecondarySidebarState)
final secondarySidebarStateProvider =
    AutoDisposeNotifierProvider<SecondarySidebarState, bool>.internal(
      SecondarySidebarState.new,
      name: r'secondarySidebarStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$secondarySidebarStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SecondarySidebarState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

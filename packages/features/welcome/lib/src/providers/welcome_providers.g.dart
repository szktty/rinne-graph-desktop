// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$showWelcomeScreenHash() => r'631d53a34fa300eb8b1470645837475c72eced57';

/// Provider that manages the display settings for the welcome page.
///
/// Copied from [ShowWelcomeScreen].
@ProviderFor(ShowWelcomeScreen)
final showWelcomeScreenProvider =
    AutoDisposeNotifierProvider<ShowWelcomeScreen, bool>.internal(
      ShowWelcomeScreen.new,
      name: r'showWelcomeScreenProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$showWelcomeScreenHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ShowWelcomeScreen = AutoDisposeNotifier<bool>;
String _$selectedWelcomeStackHash() =>
    r'048ee1c2db18963a0487eada33378256b35801e6';

/// Provider that manages the stack selected on the welcome screen.
///
/// Copied from [SelectedWelcomeStack].
@ProviderFor(SelectedWelcomeStack)
final selectedWelcomeStackProvider = AutoDisposeNotifierProvider<
  SelectedWelcomeStack,
  core_stack.Stack?
>.internal(
  SelectedWelcomeStack.new,
  name: r'selectedWelcomeStackProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedWelcomeStackHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedWelcomeStack = AutoDisposeNotifier<core_stack.Stack?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

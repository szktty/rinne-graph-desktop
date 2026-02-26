// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the display settings for the welcome page.

@ProviderFor(ShowWelcomeScreen)
final showWelcomeScreenProvider = ShowWelcomeScreenProvider._();

/// Provider that manages the display settings for the welcome page.
final class ShowWelcomeScreenProvider
    extends $NotifierProvider<ShowWelcomeScreen, bool> {
  /// Provider that manages the display settings for the welcome page.
  ShowWelcomeScreenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showWelcomeScreenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showWelcomeScreenHash();

  @$internal
  @override
  ShowWelcomeScreen create() => ShowWelcomeScreen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showWelcomeScreenHash() => r'631d53a34fa300eb8b1470645837475c72eced57';

/// Provider that manages the display settings for the welcome page.

abstract class _$ShowWelcomeScreen extends $Notifier<bool> {
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

/// Provider that manages the stack selected on the welcome screen.

@ProviderFor(SelectedWelcomeStack)
final selectedWelcomeStackProvider = SelectedWelcomeStackProvider._();

/// Provider that manages the stack selected on the welcome screen.
final class SelectedWelcomeStackProvider
    extends $NotifierProvider<SelectedWelcomeStack, core_stack.Stack?> {
  /// Provider that manages the stack selected on the welcome screen.
  SelectedWelcomeStackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedWelcomeStackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedWelcomeStackHash();

  @$internal
  @override
  SelectedWelcomeStack create() => SelectedWelcomeStack();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_stack.Stack? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_stack.Stack?>(value),
    );
  }
}

String _$selectedWelcomeStackHash() =>
    r'048ee1c2db18963a0487eada33378256b35801e6';

/// Provider that manages the stack selected on the welcome screen.

abstract class _$SelectedWelcomeStack extends $Notifier<core_stack.Stack?> {
  core_stack.Stack? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<core_stack.Stack?, core_stack.Stack?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<core_stack.Stack?, core_stack.Stack?>,
              core_stack.Stack?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the language filter for the welcome screen.
///
/// - `null` = show all languages (no filter)
/// - `'__unspecified__'` = show only stacks with no language set
/// - any ISO 639-1 code (e.g. `'en'`, `'ja'`) = show only that language

@ProviderFor(WelcomeLanguageFilter)
final welcomeLanguageFilterProvider = WelcomeLanguageFilterProvider._();

/// Provider that manages the language filter for the welcome screen.
///
/// - `null` = show all languages (no filter)
/// - `'__unspecified__'` = show only stacks with no language set
/// - any ISO 639-1 code (e.g. `'en'`, `'ja'`) = show only that language
final class WelcomeLanguageFilterProvider
    extends $NotifierProvider<WelcomeLanguageFilter, String?> {
  /// Provider that manages the language filter for the welcome screen.
  ///
  /// - `null` = show all languages (no filter)
  /// - `'__unspecified__'` = show only stacks with no language set
  /// - any ISO 639-1 code (e.g. `'en'`, `'ja'`) = show only that language
  WelcomeLanguageFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeLanguageFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeLanguageFilterHash();

  @$internal
  @override
  WelcomeLanguageFilter create() => WelcomeLanguageFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$welcomeLanguageFilterHash() =>
    r'dc37f350778dd18930072819710216cde29cc2f3';

/// Provider that manages the language filter for the welcome screen.
///
/// - `null` = show all languages (no filter)
/// - `'__unspecified__'` = show only stacks with no language set
/// - any ISO 639-1 code (e.g. `'en'`, `'ja'`) = show only that language

abstract class _$WelcomeLanguageFilter extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

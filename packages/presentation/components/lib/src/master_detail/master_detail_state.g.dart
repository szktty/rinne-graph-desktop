// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_detail_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedItemHash() => r'6f48932ff07c0d40e789d339dc4d8f949cf939f1';

/// Management of selection state.
///
/// Copied from [SelectedItem].
@ProviderFor(SelectedItem)
final selectedItemProvider =
    AutoDisposeNotifierProvider<SelectedItem, String?>.internal(
      SelectedItem.new,
      name: r'selectedItemProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedItemHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedItem = AutoDisposeNotifier<String?>;
String _$masterWidthHash() => r'8b00286acec6207bf612e61f81b34c5ed2f63435';

/// Management of master width.
///
/// Copied from [MasterWidth].
@ProviderFor(MasterWidth)
final masterWidthProvider =
    AutoDisposeNotifierProvider<MasterWidth, double>.internal(
      MasterWidth.new,
      name: r'masterWidthProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$masterWidthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MasterWidth = AutoDisposeNotifier<double>;
String _$detailVisibilityHash() => r'11919f895308c35c7892ac952c07723ea9e4adab';

/// Management of detail display visibility.
///
/// Copied from [DetailVisibility].
@ProviderFor(DetailVisibility)
final detailVisibilityProvider =
    AutoDisposeNotifierProvider<DetailVisibility, bool>.internal(
      DetailVisibility.new,
      name: r'detailVisibilityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$detailVisibilityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DetailVisibility = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

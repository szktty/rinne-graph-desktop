// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_management_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredLabelsHash() => r'c5037194749a3f98f2eaad12179cf4a4cc6f066a';

/// Provider that provides a filtered list of labels.
///
/// Copied from [filteredLabels].
@ProviderFor(filteredLabels)
final filteredLabelsProvider =
    AutoDisposeProvider<List<LabelMetadata>>.internal(
      filteredLabels,
      name: r'filteredLabelsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredLabelsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredLabelsRef = AutoDisposeProviderRef<List<LabelMetadata>>;
String _$labelSearchQueryHash() => r'a0e3d41298fa4dce853e7fe526d381a7b3073f81';

/// Provider that manages the label search query.
///
/// Copied from [LabelSearchQuery].
@ProviderFor(LabelSearchQuery)
final labelSearchQueryProvider =
    AutoDisposeNotifierProvider<LabelSearchQuery, String>.internal(
      LabelSearchQuery.new,
      name: r'labelSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$labelSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LabelSearchQuery = AutoDisposeNotifier<String>;
String _$selectedLabelHash() => r'bdd238ef135653ac7b969d74bbdc938c35df8322';

/// Provider that manages the selected label.
///
/// Copied from [SelectedLabel].
@ProviderFor(SelectedLabel)
final selectedLabelProvider =
    AutoDisposeNotifierProvider<SelectedLabel, LabelMetadata?>.internal(
      SelectedLabel.new,
      name: r'selectedLabelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedLabelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedLabel = AutoDisposeNotifier<LabelMetadata?>;
String _$labelActionsHash() => r'9c2c783f5be527451b49d1d4c4885bd8ff9e6889';

/// Provider that offers label management actions.
///
/// Copied from [LabelActions].
@ProviderFor(LabelActions)
final labelActionsProvider =
    AutoDisposeNotifierProvider<LabelActions, void>.internal(
      LabelActions.new,
      name: r'labelActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$labelActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LabelActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

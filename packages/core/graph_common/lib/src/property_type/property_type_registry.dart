/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/property_type.dart';
import 'package:meta/meta.dart';

/// Everything the system knows about one property type name.
///
/// One descriptor per entry in [propertyTypeDescriptors]. Adding a property
/// type means adding an entry there and an editor for it — the type name does
/// not have to be repeated in a supported-types set, a picker list, a
/// constraint-validation switch and a build switch, which is how those four
/// drifted apart from each other before this table existed.
@immutable
class PropertyTypeDescriptor {
  const PropertyTypeDescriptor({
    required this.typeName,
    required this.label,
    required this.isSelectable,
    required this.build,
    this.validateConstraints = _acceptAnyConstraints,
    this.initialLinkKind,
  });

  /// The persisted type name.
  ///
  /// On disk in `meta/property_types.json`, so it can never be changed once
  /// released — only added to.
  ///
  /// Not unique across descriptors: several picker entries may share one type
  /// name when they differ only in how the value is entered. See [pickerId].
  final String typeName;

  /// Identifies this entry in a picker, where [typeName] may be ambiguous.
  ///
  /// A URL, an external file and a file inside the stack are one stored type —
  /// they all hold a URI, and the difference is derivable from the value. But
  /// nobody adding a property thinks "I want a link, of the URL variety": they
  /// think "I want to attach a URL". So the picker offers three entries that
  /// happen to persist as one type.
  String get pickerId =>
      initialLinkKind == null ? typeName : '$typeName:${initialLinkKind!.name}';

  /// English display name for pickers and command output.
  ///
  /// UI text in a pure-Dart package is deliberate: the alternative is a
  /// parallel label map in the widget layer, which is the duplication this
  /// table exists to remove. The package already carries user-facing prose in
  /// its [ValidationResult] messages. If the app is ever localized, this
  /// becomes the English fallback and the lookup key, and this is the single
  /// place to change.
  final String label;

  /// Whether a user may pick this type when adding a property.
  ///
  /// Separate from being supported: `any` is internal, and `decimal` and
  /// `email` are readable in stacks that already use them but are not offered,
  /// because neither has an editor that would produce a valid value.
  final bool isSelectable;

  /// For a link type, which kind of link this picker entry starts on.
  ///
  /// Null for every type that is not a link. Non-null entries are what let one
  /// stored type appear as several picker choices: the value is a URI either
  /// way, and this only decides which input the editor opens on.
  final LinkKind? initialLinkKind;

  /// Builds the configured [PropertyType] from a definition's constraints.
  ///
  /// A function rather than a constant instance because a type plus its
  /// constraints is what makes a usable [PropertyType] — `text` with a
  /// `max_length` is a different value than bare `text`.
  final PropertyType Function(Map<String, dynamic> constraints) build;

  /// Whether a constraints map is well-formed for this type.
  ///
  /// Defaults to accepting anything, which is right for the types that take no
  /// constraints at all.
  final bool Function(Map<String, dynamic> constraints) validateConstraints;
}

/// Every property type this build understands, in type-picker order.
///
/// Declaration order is menu order — text first because it is the default and
/// the common case. The non-selectable types trail the selectable ones so the
/// list reads the way the picker does.
const List<PropertyTypeDescriptor> propertyTypeDescriptors = [
  PropertyTypeDescriptor(
    typeName: 'text',
    label: 'Text',
    isSelectable: true,
    build: _buildText,
    validateConstraints: validateTextConstraints,
  ),
  PropertyTypeDescriptor(
    typeName: 'integer',
    label: 'Number',
    isSelectable: true,
    build: _buildInteger,
    validateConstraints: validateIntegerConstraints,
  ),
  PropertyTypeDescriptor(
    typeName: 'date',
    label: 'Date',
    isSelectable: true,
    build: _buildDate,
    validateConstraints: validateDateConstraints,
  ),
  PropertyTypeDescriptor(
    typeName: 'boolean',
    label: 'Boolean',
    isSelectable: true,
    build: _buildBoolean,
  ),
  PropertyTypeDescriptor(
    typeName: 'memo',
    label: 'Memo',
    isSelectable: true,
    build: _buildMemo,
    // A memo's length cap is fixed by MemoPropertyType, so a definition
    // carries no constraints of its own. Validated as text so that a
    // hand-edited max_length is at least type-checked rather than ignored.
    validateConstraints: validateTextConstraints,
  ),
  // One stored type, three picker entries. Someone adding a property is
  // attaching a URL or a file, not choosing between a "link" and its subtypes,
  // so the thing they already have in mind is what the menu offers.
  PropertyTypeDescriptor(
    typeName: 'link',
    label: 'URL',
    isSelectable: true,
    build: _buildLink,
    validateConstraints: validateLinkConstraints,
    initialLinkKind: LinkKind.url,
  ),
  PropertyTypeDescriptor(
    typeName: 'link',
    label: 'External file',
    isSelectable: true,
    build: _buildLink,
    validateConstraints: validateLinkConstraints,
    initialLinkKind: LinkKind.externalFile,
  ),
  PropertyTypeDescriptor(
    typeName: 'link',
    label: 'File in this stack',
    isSelectable: true,
    build: _buildLink,
    validateConstraints: validateLinkConstraints,
    initialLinkKind: LinkKind.stackRelative,
  ),
  PropertyTypeDescriptor(
    typeName: 'decimal',
    label: 'Decimal',
    isSelectable: false,
    build: _buildDecimal,
    validateConstraints: validateDecimalConstraints,
  ),
  PropertyTypeDescriptor(
    typeName: 'email',
    label: 'Email',
    isSelectable: false,
    build: _buildEmail,
  ),
  PropertyTypeDescriptor(
    typeName: 'any',
    label: 'Any',
    isSelectable: false,
    build: _buildAny,
  ),
];

/// Lookup over [propertyTypeDescriptors].
///
/// The list is the source of truth and this index is derived from it, so the
/// two cannot disagree about which types exist.
abstract final class PropertyTypeRegistry {
  /// All descriptors, in menu order.
  static const List<PropertyTypeDescriptor> all = propertyTypeDescriptors;

  /// The descriptor for [typeName], or null if this build does not know it.
  static PropertyTypeDescriptor? lookup(String typeName) => _byName[typeName];

  /// Whether [typeName] is a type this build understands.
  static bool isSupported(String typeName) => _byName.containsKey(typeName);

  /// Every type name this build understands.
  static Set<String> get supportedTypeNames => _byName.keys.toSet();

  /// The descriptors offered in a type picker, in menu order.
  static List<PropertyTypeDescriptor> get selectable => all
      .where((descriptor) => descriptor.isSelectable)
      .toList(growable: false);

  /// The type names offered in a type picker, without duplicates.
  ///
  /// Deduplicated because several picker entries can share one type name —
  /// a caller checking "is this an assignable type" must not see `link` three
  /// times.
  static List<String> get selectableTypeNames {
    final seen = <String>{};
    return [
      for (final descriptor in selectable)
        if (seen.add(descriptor.typeName)) descriptor.typeName,
    ];
  }

  /// The picker entry with this [pickerId], or null if there is none.
  ///
  /// Use this where a picker selection has to be turned back into an entry;
  /// [lookup] takes a bare type name and cannot tell the link entries apart.
  static PropertyTypeDescriptor? lookupByPickerId(String pickerId) =>
      _byPickerId[pickerId];

  /// The first descriptor for each type name, in declaration order.
  ///
  /// Keyed by type name, so a type with several picker entries resolves to the
  /// first one — which is all a caller building a [PropertyType] needs, since
  /// those entries differ only in how the editor opens.
  static final Map<String, PropertyTypeDescriptor> _byName = {
    for (final descriptor in all.reversed) descriptor.typeName: descriptor,
  };

  static final Map<String, PropertyTypeDescriptor> _byPickerId = {
    for (final descriptor in all) descriptor.pickerId: descriptor,
  };
}

// --- Builders -------------------------------------------------------------

PropertyType _buildText(Map<String, dynamic> constraints) => TextPropertyType(
  minLength: constraints['min_length'] as int?,
  maxLength: constraints['max_length'] as int?,
  pattern: constraints['pattern'] as String?,
);

PropertyType _buildInteger(Map<String, dynamic> constraints) =>
    IntegerPropertyType(
      min: constraints['min'] as int?,
      max: constraints['max'] as int?,
    );

PropertyType _buildDate(Map<String, dynamic> constraints) =>
    const DatePropertyType();

PropertyType _buildBoolean(Map<String, dynamic> constraints) =>
    const BooleanPropertyType();

PropertyType _buildMemo(Map<String, dynamic> constraints) =>
    const MemoPropertyType();

PropertyType _buildLink(Map<String, dynamic> constraints) => LinkPropertyType(
  defaultKind: LinkPropertyType.kindFromName(
    constraints[LinkPropertyType.defaultKindConstraint],
  ),
);

PropertyType _buildDecimal(Map<String, dynamic> constraints) =>
    const DecimalPropertyType();

PropertyType _buildEmail(Map<String, dynamic> constraints) =>
    const EmailPropertyType();

PropertyType _buildAny(Map<String, dynamic> constraints) =>
    const AnyPropertyType();

// --- Constraint validators ------------------------------------------------

/// Accepts any constraints, for the types that take none.
bool _acceptAnyConstraints(Map<String, dynamic> constraints) => true;

/// Validates link type constraints.
///
/// The only constraint a link takes is which kind a still-empty property opens
/// on, and an unrecognized name is tolerated rather than rejected — it means
/// the definition was written by a newer build, which should degrade to "no
/// preference" rather than invalidate the whole definition.
bool validateLinkConstraints(Map<String, dynamic> constraints) {
  final kind = constraints[LinkPropertyType.defaultKindConstraint];
  return kind == null || kind is String;
}

/// Validates text type constraints.
bool validateTextConstraints(Map<String, dynamic> constraints) {
  final minLength = constraints['min_length'];
  final maxLength = constraints['max_length'];

  if (minLength != null && minLength is! int) return false;
  if (maxLength != null && maxLength is! int) return false;
  if (minLength != null &&
      maxLength != null &&
      (minLength as int) > (maxLength as int)) {
    return false;
  }

  final pattern = constraints['pattern'];
  if (pattern != null && pattern is! String) return false;

  return true;
}

/// Validates integer type constraints.
bool validateIntegerConstraints(Map<String, dynamic> constraints) {
  final min = constraints['min'];
  final max = constraints['max'];

  if (min != null && min is! int) return false;
  if (max != null && max is! int) return false;
  if (min != null && max != null && (min as int) > (max as int)) return false;

  return true;
}

/// Validates decimal type constraints.
bool validateDecimalConstraints(Map<String, dynamic> constraints) {
  final min = constraints['min'];
  final max = constraints['max'];

  if (min != null && min is! double && min is! int) return false;
  if (max != null && max is! double && max is! int) return false;
  if (min != null && max != null) {
    final minValue = (min is int) ? min.toDouble() : min as double;
    final maxValue = (max is int) ? max.toDouble() : max as double;
    if (minValue > maxValue) return false;
  }

  return true;
}

/// Validates date type constraints.
bool validateDateConstraints(Map<String, dynamic> constraints) {
  final minDate = constraints['min_date'];
  final maxDate = constraints['max_date'];

  if (minDate != null) {
    if (minDate is! String) return false;
    try {
      DateTime.parse(minDate);
    } on FormatException {
      return false;
    }
  }

  if (maxDate != null) {
    if (maxDate is! String) return false;
    try {
      DateTime.parse(maxDate);
    } on FormatException {
      return false;
    }
  }

  return true;
}

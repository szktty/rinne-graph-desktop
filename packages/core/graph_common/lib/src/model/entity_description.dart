import 'package:collection/collection.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/model/property_value_transformer.dart';
import 'package:core_graph_common/src/model/property_value_validator.dart';
import 'package:meta/meta.dart';

/// A class that describes the property structure of an entity.
///
/// This class manages dynamically updatable property definitions,
/// reflecting the current state of the entity.
@immutable
class EntityDescription {
  /// Constructor.
  const EntityDescription({
    required this.type,
    required this.propertyTypes,
    this.propertyValidators = const {},
    this.propertyTransformers = const {},
  });

  /// The type of the entity.
  final String type;

  /// Property type definitions.
  final Map<String, PropertyType> propertyTypes;

  /// Property validators.
  final Map<String, List<PropertyValueValidator>> propertyValidators;

  /// Property transformers.
  final Map<String, List<PropertyValueTransformer>> propertyTransformers;

  /// Validates property values.
  bool validate(Map<String, dynamic> properties) {
    // Check if all required properties exist.
    for (final entry in propertyTypes.entries) {
      final key = entry.key;
      final type = entry.value;
      final value = properties[key];

      // Return false if a required property is missing.
      if (type.isRequired && !properties.containsKey(key)) {
        return false;
      }

      // If a value exists, check its type and validators.
      if (value != null) {
        // Type check.
        if (!type.isValid(value)) {
          return false;
        }

        // Validator check.
        final validators = propertyValidators[key] ?? [];
        for (final validator in validators) {
          final result = validator.validate(value);
          if (!result.isValid) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Transforms property values.
  Map<String, dynamic> transform(Map<String, dynamic> properties) {
    final result = Map<String, dynamic>.from(properties);

    for (final entry in propertyTypes.entries) {
      final key = entry.key;
      final value = properties[key];

      if (value != null) {
        // Conversion by type.
        final type = entry.value;
        final convertedValue = type.convertValue(value);
        if (convertedValue != null) {
          result[key] = convertedValue;
        }

        // Transformation by transformers.
        final transformers = propertyTransformers[key] ?? [];
        for (final transformer in transformers) {
          result[key] = transformer.transform(result[key]);
        }
      }
    }

    return result;
  }

  /// Converts the entity description to a map.
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'propertyTypes': propertyTypes.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'propertyValidators': propertyValidators.map(
        (key, value) => MapEntry(key, value.map((v) => v.toMap()).toList()),
      ),
      'propertyTransformers': propertyTransformers.map(
        (key, value) => MapEntry(key, value.map((t) => t.toMap()).toList()),
      ),
    };
  }

  /// Creates an entity description with a new property type added.
  EntityDescription addPropertyType(String key, PropertyType type) {
    final newPropertyTypes = Map<String, PropertyType>.from(propertyTypes);
    newPropertyTypes[key] = type;
    return EntityDescription(
      type: type.name,
      propertyTypes: newPropertyTypes,
      propertyValidators: propertyValidators,
      propertyTransformers: propertyTransformers,
    );
  }

  /// Creates an entity description with a property type removed.
  EntityDescription removePropertyType(String key) {
    final newPropertyTypes = Map<String, PropertyType>.from(propertyTypes);
    newPropertyTypes.remove(key);
    return EntityDescription(
      type: type,
      propertyTypes: newPropertyTypes,
      propertyValidators: propertyValidators,
      propertyTransformers: propertyTransformers,
    );
  }

  /// Creates an entity description with a validator added.
  EntityDescription addPropertyValidator(
    String key,
    PropertyValueValidator validator,
  ) {
    final newPropertyValidators =
        Map<String, List<PropertyValueValidator>>.from(propertyValidators);
    final validators = List<PropertyValueValidator>.from(
      propertyValidators[key] ?? [],
    );
    validators.add(validator);
    newPropertyValidators[key] = validators;
    return EntityDescription(
      type: type,
      propertyTypes: propertyTypes,
      propertyValidators: newPropertyValidators,
      propertyTransformers: propertyTransformers,
    );
  }

  /// Creates an entity description with a transformer added.
  EntityDescription addPropertyTransformer(
    String key,
    PropertyValueTransformer transformer,
  ) {
    final newPropertyTransformers =
        Map<String, List<PropertyValueTransformer>>.from(propertyTransformers);
    final transformers = List<PropertyValueTransformer>.from(
      propertyTransformers[key] ?? [],
    );
    transformers.add(transformer);
    newPropertyTransformers[key] = transformers;
    return EntityDescription(
      type: type,
      propertyTypes: propertyTypes,
      propertyValidators: propertyValidators,
      propertyTransformers: newPropertyTransformers,
    );
  }

  /// Creates an empty entity description.
  static EntityDescription empty() {
    return const EntityDescription(type: 'empty', propertyTypes: {});
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EntityDescription &&
        type == other.type &&
        const MapEquality<String, dynamic>().equals(
          propertyTypes,
          other.propertyTypes,
        ) &&
        const MapEquality<String, List<PropertyValueValidator>>().equals(
          propertyValidators,
          other.propertyValidators,
        ) &&
        const MapEquality<String, List<PropertyValueTransformer>>().equals(
          propertyTransformers,
          other.propertyTransformers,
        );
  }

  @override
  int get hashCode {
    const mapEquality = MapEquality<String, dynamic>();
    return Object.hash(
      type,
      mapEquality.hash(propertyTypes),
      mapEquality.hash(propertyValidators),
      mapEquality.hash(propertyTransformers),
    );
  }
}

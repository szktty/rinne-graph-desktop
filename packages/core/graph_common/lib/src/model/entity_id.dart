import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:meta/meta.dart';

/// An ID for uniquely identifying entities in the graph database.
///
/// Based on [UniqueId], it adds constraints and behaviors specific to the graph database.
@immutable
class EntityId implements Comparable<EntityId> {
  /// Generates a new entity ID.
  factory EntityId() => EntityId._(UniqueId());

  /// Private constructor.
  const EntityId._(this._id);

  /// Generates an entity ID from a string.
  ///
  /// [id] UUIDv7形式の文字列
  ///
  /// 無効なフォーマットの場合は[FormatException]をスローします
  factory EntityId.fromString(String id) => EntityId._(UniqueId.fromString(id));

  /// Generates an entity ID from a validated string (internal use).
  ///
  /// このファクトリメソッドは、既に検証済みのIDを扱う内部処理で使用します。
  /// Do not use as a public API.
  @protected
  factory EntityId.trusted(String id) => EntityId._(UniqueId.trusted(id));

  /// Generates an entity ID from any string.
  ///
  /// 外部システムとの連携やデータ移行時に使用します。
  /// [id] Any string (cannot be an empty string).
  ///
  /// 空文字列の場合は[AssertionError]をスローします
  factory EntityId.fromAnyString(String id) =>
      EntityId._(UniqueId.fromAnyString(id));

  /// The ID used internally.
  final UniqueId _id;

  /// The ID value (a string in UUIDv7 format).
  String get value => _id.value;

  /// Extracts the timestamp part.
  DateTime get timestamp => _id.timestamp;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EntityId && other._id == _id;
  }

  @override
  int get hashCode => _id.hashCode;

  @override
  int compareTo(EntityId other) => _id.compareTo(other._id);
}

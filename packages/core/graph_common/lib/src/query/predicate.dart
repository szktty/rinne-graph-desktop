/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// 述語の種類
enum PredicateType { property, compound, label, link }

/// プロパティ比較演算子
enum PredicateOperator {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  greaterThanOrEquals,
  lessThanOrEquals,
  contains,
  beginsWith,
  endsWith,
  inList,
  notInList,
  isNull,
  isNotNull,
}

/// リンク方向
enum PredicateDirection { outgoing, incoming, both }

/// 複合演算子
enum CompoundOperator { and, or, not }

/// クエリの述語を表現する抽象クラス
abstract class Predicate {
  PredicateType get type;
}

/// プロパティに対する述語
class PropertyPredicate extends Predicate {
  PropertyPredicate(this.propertyKey, this.operator, this.value);
  @override
  final PredicateType type = PredicateType.property;

  final String propertyKey;
  final PredicateOperator operator;
  final dynamic value;
}

/// 複合述語
class CompoundPredicate extends Predicate {
  CompoundPredicate(this.operator, this.predicates);
  @override
  final PredicateType type = PredicateType.compound;

  final CompoundOperator operator;
  final List<Predicate> predicates;
}

/// ラベル述語
class LabelPredicate extends Predicate {
  LabelPredicate(this.label, {this.hasLabel = true});
  @override
  final PredicateType type = PredicateType.label;

  final String label;
  final bool hasLabel;
}

/// 全プロパティ値に対する含有述語
class AnyKeyContainsPredicate extends Predicate {
  AnyKeyContainsPredicate(this.value);
  @override
  final PredicateType type = PredicateType.property;

  final String value;
}

/// リンク述語
class LinkPredicate extends Predicate {
  LinkPredicate(
    this.linkType, {
    this.direction = PredicateDirection.both,
    this.targetPredicate,
  });
  @override
  final PredicateType type = PredicateType.link;

  final String linkType;
  final PredicateDirection direction;
  final Predicate? targetPredicate;
}

/// 便利なヘルパー関数
Predicate eq(String property, dynamic value) =>
    PropertyPredicate(property, PredicateOperator.equals, value);

Predicate neq(String property, dynamic value) =>
    PropertyPredicate(property, PredicateOperator.notEquals, value);

Predicate gt(String property, dynamic value) =>
    PropertyPredicate(property, PredicateOperator.greaterThan, value);

Predicate lt(String property, dynamic value) =>
    PropertyPredicate(property, PredicateOperator.lessThan, value);

Predicate gte(String property, dynamic value) =>
    PropertyPredicate(property, PredicateOperator.greaterThanOrEquals, value);

Predicate lte(String property, dynamic value) =>
    PropertyPredicate(property, PredicateOperator.lessThanOrEquals, value);

Predicate contains(String property, String value) =>
    PropertyPredicate(property, PredicateOperator.contains, value);

Predicate beginsWith(String property, String value) =>
    PropertyPredicate(property, PredicateOperator.beginsWith, value);

Predicate endsWith(String property, String value) =>
    PropertyPredicate(property, PredicateOperator.endsWith, value);

Predicate isIn(String property, List<dynamic> values) =>
    PropertyPredicate(property, PredicateOperator.inList, values);

Predicate isNotIn(String property, List<dynamic> values) =>
    PropertyPredicate(property, PredicateOperator.notInList, values);

Predicate isNull(String property) =>
    PropertyPredicate(property, PredicateOperator.isNull, null);

Predicate isNotNull(String property) =>
    PropertyPredicate(property, PredicateOperator.isNotNull, null);

Predicate hasLabel(String label) => LabelPredicate(label);

Predicate and(List<Predicate> predicates) =>
    CompoundPredicate(CompoundOperator.and, predicates);

Predicate or(List<Predicate> predicates) =>
    CompoundPredicate(CompoundOperator.or, predicates);

Predicate not(Predicate predicate) =>
    CompoundPredicate(CompoundOperator.not, [predicate]);

Predicate anyKeyContains(String value) => AnyKeyContainsPredicate(value);

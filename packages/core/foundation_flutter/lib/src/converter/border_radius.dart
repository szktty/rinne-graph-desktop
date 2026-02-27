/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonSerializable()
class BorderRadiusJsonConverter
    implements JsonConverter<BorderRadius, Map<String, dynamic>> {
  const BorderRadiusJsonConverter();

  @override
  BorderRadius fromJson(Map<String, dynamic> json) {
    return BorderRadius.only(
      topLeft: Radius.circular(json['topLeft'] as double),
      topRight: Radius.circular(json['topRight'] as double),
      bottomLeft: Radius.circular(json['bottomLeft'] as double),
      bottomRight: Radius.circular(json['bottomRight'] as double),
    );
  }

  @override
  Map<String, dynamic> toJson(BorderRadius radius) {
    return {
      'topLeft': radius.topLeft.x,
      'topRight': radius.topRight.x,
      'bottomLeft': radius.bottomLeft.x,
      'bottomRight': radius.bottomRight.x,
    };
  }
}

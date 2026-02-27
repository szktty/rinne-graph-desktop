/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

// Converter for JSON serialization.
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonSerializable()
class ColorJsonConverter implements JsonConverter<Color, String> {
  const ColorJsonConverter();

  @override
  Color fromJson(String hexString) {
    return Color(int.parse(hexString, radix: 16));
  }

  @override
  String toJson(Color color) {
    return color.toARGB32().toRadixString(16).padLeft(8, '0');
  }
}

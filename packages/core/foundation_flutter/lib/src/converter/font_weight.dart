import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// JSON converter for FontWeight.
///
/// A converter for saving and restoring FontWeight in JSON format.
/// Saves FontWeight's numerical representation (100-900) as an integer in JSON,
/// and restores it as a FontWeight object.
@JsonSerializable()
class FontWeightJsonConverter implements JsonConverter<FontWeight, int> {
  const FontWeightJsonConverter();

  @override
  FontWeight fromJson(int weightValue) {
    switch (weightValue) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        // Default is normal weight (w400)
        return FontWeight.w400;
    }
  }

  @override
  int toJson(FontWeight fontWeight) {
    return fontWeight.index * 100 + 100;
  }
}

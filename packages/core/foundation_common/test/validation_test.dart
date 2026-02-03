import 'package:test/test.dart';
import 'package:core_foundation_common/core_foundation_common.dart';

void main() {
  group('ValidationResult', () {
    test('should create success result', () {
      const result = ValidationResult.success;
      expect(result.isValid, isTrue);
      expect(result.error, isNull);
      expect(result.kind, isNull);
    });

    test('should create error result', () {
      const result = ValidationResult.error('Test error');
      expect(result.isValid, isFalse);
      expect(result.error, equals('Test error'));
    });

    test('should create error result with kind', () {
      const result = ValidationResult.error(
        'Type error',
        kind: ValidationResultKind.typeError,
      );
      expect(result.isValid, isFalse);
      expect(result.error, equals('Type error'));
      expect(result.kind, equals(ValidationResultKind.typeError));
    });

    test('should be equal when same values', () {
      const result1 = ValidationResult.success;
      const result2 = ValidationResult.success;
      expect(result1, equals(result2));
    });

    test('should have proper toString', () {
      const success = ValidationResult.success;
      const error = ValidationResult.error('Test error');

      expect(success.toString(), equals('ValidationResult.success()'));
      expect(error.toString(), contains('ValidationResult.error'));
      expect(error.toString(), contains('Test error'));
    });
  });
}

import 'package:test/test.dart';
import 'package:core_foundation_common/core_foundation_common.dart';

void main() {
  group('UniqueId', () {
    test('should generate valid UUID v7', () {
      final id = UniqueId();
      expect(id.value, isNotEmpty);
      expect(UniqueId.isValidUuid(id.value), isTrue);
    });

    test('should create from valid UUID string', () {
      const validUuid = '01234567-89ab-7def-8123-456789abcdef';
      final id = UniqueId.fromString(validUuid);
      expect(id.value, equals(validUuid));
    });

    test('should throw on invalid UUID format', () {
      expect(
        () => UniqueId.fromString('invalid-uuid'),
        throwsA(isA<FormatException>()),
      );
    });

    test('should create from any string', () {
      const anyString = 'custom-id-123';
      final id = UniqueId.fromAnyString(anyString);
      expect(id.value, equals(anyString));
    });

    test('should be comparable', () {
      final id1 = UniqueId.fromAnyString('a');
      final id2 = UniqueId.fromAnyString('b');
      expect(id1.compareTo(id2), lessThan(0));
    });
  });
}

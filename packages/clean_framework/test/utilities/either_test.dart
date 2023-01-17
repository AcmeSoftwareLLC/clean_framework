import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Either tests | ', () {
    test('left side', () {
      const direction = Either<String, String>.left('left');

      expect(direction.isLeft, isTrue);
      expect(direction.isRight, isFalse);
      expect(direction, equals(const Either<String, String>.left('left')));
    });

    test('right side', () {
      const direction = Either<String, String>.right('right');

      expect(direction.isLeft, isFalse);
      expect(direction.isRight, isTrue);
      expect(direction, equals(const Either<String, String>.right('right')));
    });

    test('throws if no left side is resolved', () {
      const direction = Either<String, String>.right('right');

      expect(direction.isLeft, isFalse);
      expect(direction.isRight, isTrue);

      expect(() => direction.left, throwsA(isA<NoSuchElementException>()));
    });

    test('throws if no right side is resolved', () {
      const direction = Either<String, String>.left('left');

      expect(direction.isLeft, isTrue);
      expect(direction.isRight, isFalse);

      expect(() => direction.right, throwsA(isA<NoSuchElementException>()));
    });

    test('equality check', () {
      expect(
        const Either<bool, bool>.left(false),
        const Either<bool, bool>.left(false),
      );

      expect(
        const Either<bool, bool>.right(true),
        const Either<bool, bool>.right(true),
      );

      expect(
        const Either<bool, bool>.left(false),
        isNot(const Either<bool, bool>.right(true)),
      );

      expect(
        const Either<bool, bool>.right(true),
        isNot(const Either<bool, bool>.left(false)),
      );

      expect(
        const Either<bool, bool>.left(false).hashCode,
        const Either<bool, bool>.left(false).hashCode,
      );

      expect(
        const Either<bool, bool>.right(true).hashCode,
        const Either<bool, bool>.right(true).hashCode,
      );
    });
  });
}

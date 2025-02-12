import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_explorer/core/errors/failures.dart';

void main() {
  group('ServerException', () {
    test('should return correct message', () {
      // arrange
      final exception = ServerFailure('Test error message');

      // assert
      expect(exception.message, equals('Test error message'));
    });

    test('should be equal when messages are equal', () {
      // arrange
      final exception1 = ServerFailure('Test error message');
      final exception2 = ServerFailure('Test error message');

      // assert
      expect(exception1.message, equals(exception2.message));
    });
  });

  group('CacheException', () {
    test('should return correct message', () {
      // arrange
      final exception = CacheFailure('Test cache error');

      // assert
      expect(exception.message, equals('Test cache error'));
    });

    test('should be equal when messages are equal', () {
      // arrange
      final exception1 = CacheFailure('Test cache error');
      final exception2 = CacheFailure('Test cache error');

      // assert
      expect(exception1.message, equals(exception2.message));
    });
  });
} 
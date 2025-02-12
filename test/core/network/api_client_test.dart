import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_explorer/core/network/api_client.dart';

void main() {
  late ApiClient apiClient;

  setUp(() {
    apiClient = ApiClient();
  });

  group('get', () {
    final tPath = 'https://rickandmortyapi.com/api/episode/1';

    test('should return response when the call is successful', () async {
      // act
      final result = await apiClient.get(tPath);

      // assert
      expect(result.statusCode, equals(200));
      expect(result.data, isA<Map<String, dynamic>>());
      expect(result.data['id'], equals(1));
      expect(result.data['name'], isA<String>());
    });

    test('should throw Exception when the path is invalid', () async {
      // arrange
      final invalidPath = 'https://rickandmortyapi.com/api/invalid/path';

      // act & assert
      expect(
        () => apiClient.get(invalidPath),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Falha na requisição'),
        )),
      );
    });
  });
} 
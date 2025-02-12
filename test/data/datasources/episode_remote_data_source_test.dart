import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/core/network/api_client.dart';
import 'package:rick_and_morty_explorer/data/datasources/episode_remote_data_source.dart';
import 'package:rick_and_morty_explorer/data/models/episode_model.dart';
import 'package:rick_and_morty_explorer/data/models/pagination_info_model.dart';

class MockApiClient extends Mock implements ApiClient {}

// Classe simulada para resposta da API
class MockResponse {
  final Map<String, dynamic> data;
  MockResponse({required this.data});
}

void main() {
  late EpisodeRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = EpisodeRemoteDataSourceImpl(mockApiClient);
  });

  final tPaginationInfo = {
    'info': {
      'count': 2,
      'pages': 1,
      'next': null,
      'prev': null,
    },
    'results': [
      {
        'id': 1,
        'name': 'Pilot',
        'air_date': 'December 2, 2013',
        'episode': 'S01E01',
        'characters': ['https://rickandmortyapi.com/api/character/1'],
        'url': 'https://rickandmortyapi.com/api/episode/1',
        'created': '2017-11-10T12:56:33.798Z'
      },
      {
        'id': 2,
        'name': 'Lawnmower Dog',
        'air_date': 'December 9, 2013',
        'episode': 'S01E02',
        'characters': ['https://rickandmortyapi.com/api/character/1'],
        'url': 'https://rickandmortyapi.com/api/episode/2',
        'created': '2017-11-10T12:56:33.916Z'
      }
    ]
  };

  group('getAllEpisodes', () {
    test('should return list of episodes when the call is successful', () async {
      // arrange
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          data: tPaginationInfo,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await dataSource.getAllEpisodes();

      // assert
      expect(result, isA<List<EpisodeModel>>());
      expect(result.length, 2);
      expect(result.first.id, 1);
      expect(result.first.name, 'Pilot');
      verify(() => mockApiClient.get(any())).called(1);
    });

    test('should throw Exception when the call fails', () async {
      // arrange
      when(() => mockApiClient.get(any()))
          .thenThrow(Exception('Failed to get episodes'));

      // act & assert
      expect(
        () => dataSource.getAllEpisodes(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Falha ao carregar episódios'),
        )),
      );
    });
  });

  group('getEpisodeById', () {
    final tEpisodeResponse = {
      'id': 1,
      'name': 'Pilot',
      'air_date': 'December 2, 2013',
      'episode': 'S01E01',
      'characters': ['https://rickandmortyapi.com/api/character/1'],
      'url': 'https://rickandmortyapi.com/api/episode/1',
      'created': '2017-11-10T12:56:33.798Z'
    };

    test('should return an episode when the call is successful', () async {
      // arrange
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          data: tEpisodeResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await dataSource.getEpisodeById(1);

      // assert
      expect(result, isA<EpisodeModel>());
      expect(result.id, 1);
      expect(result.name, 'Pilot');
      verify(() => mockApiClient.get(any())).called(1);
    });

    test('should throw Exception when the call fails', () async {
      // arrange
      when(() => mockApiClient.get(any()))
          .thenThrow(Exception('Failed to get episode'));

      // act & assert
      expect(
        () => dataSource.getEpisodeById(1),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Falha ao carregar episódio'),
        )),
      );
    });
  });
} 
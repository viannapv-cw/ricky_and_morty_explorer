import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rick_and_morty_explorer/data/datasources/episode_local_data_source.dart';
import 'package:rick_and_morty_explorer/data/models/episode_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late EpisodeLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = EpisodeLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getFavoriteEpisodes', () {
    final tEpisodesList = [
      {
        'id': 1,
        'name': 'Pilot',
        'episode': 'S01E01',
        'air_date': 'December 2, 2013',
        'characters': ['https://rickandmortyapi.com/api/character/1'],
      },
      {
        'id': 2,
        'name': 'Lawnmower Dog',
        'episode': 'S01E02',
        'air_date': 'December 9, 2013',
        'characters': ['https://rickandmortyapi.com/api/character/1'],
      }
    ];

    test('should return list of favorite episodes from SharedPreferences', () async {
      // arrange
      final jsonString = jsonEncode(tEpisodesList);
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // act
      final result = await dataSource.getFavoriteEpisodes();

      // assert
      expect(result, isA<List<EpisodeModel>>());
      expect(result.length, equals(2));
      expect(result.first.id, equals(1));
      expect(result.first.name, equals('Pilot'));
      verify(() => mockSharedPreferences.getString(any())).called(1);
    });

    test('should return empty list when SharedPreferences returns null', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      // act
      final result = await dataSource.getFavoriteEpisodes();

      // assert
      expect(result, isEmpty);
      verify(() => mockSharedPreferences.getString(any())).called(1);
    });

    test('should throw Exception when SharedPreferences throws', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenThrow(Exception('Error reading from SharedPreferences'));

      // act & assert
      expect(
        () => dataSource.getFavoriteEpisodes(),
        throwsA(isA<Exception>()),
      );
    });
  });
} 
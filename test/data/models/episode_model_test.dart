import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_explorer/data/models/episode_model.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';

void main() {
  final tEpisodeModel = EpisodeModel(
    id: 1,
    name: 'Pilot',
    episode: 'S01E01',
    airDate: 'December 2, 2013',
    characters: ['https://rickandmortyapi.com/api/character/1'],
    isFavorite: false,
  );

  final tEpisodeJson = {
    'id': 1,
    'name': 'Pilot',
    'episode': 'S01E01',
    'air_date': 'December 2, 2013',
    'characters': ['https://rickandmortyapi.com/api/character/1'],
  };

  test('should be a subclass of Episode entity', () {
    expect(tEpisodeModel, isA<Episode>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      // arrange
      final Map<String, dynamic> jsonMap = tEpisodeJson;
      // act
      final result = EpisodeModel.fromJson(jsonMap);
      // assert
      expect(result.id, tEpisodeModel.id);
      expect(result.name, tEpisodeModel.name);
      expect(result.episode, tEpisodeModel.episode);
      expect(result.airDate, tEpisodeModel.airDate);
      expect(result.characters, tEpisodeModel.characters);
      expect(result.isFavorite, false); // default value
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // act
      final result = tEpisodeModel.toJson();
      // assert
      expect(result, tEpisodeJson); // isFavorite não é incluído no JSON
    });
  });

  group('copyWith', () {
    test('should return a new EpisodeModel with updated values', () {
      // act
      final result = tEpisodeModel.copyWith(
        name: 'New Name',
        isFavorite: true,
      );
      // assert
      expect(result.name, 'New Name');
      expect(result.isFavorite, true);
      expect(result.id, tEpisodeModel.id);
      expect(result.episode, tEpisodeModel.episode);
      expect(result.airDate, tEpisodeModel.airDate);
      expect(result.characters, tEpisodeModel.characters);
    });

    test('should keep original values when no parameters are passed', () {
      // act
      final result = tEpisodeModel.copyWith();
      // assert
      expect(result.id, tEpisodeModel.id);
      expect(result.name, tEpisodeModel.name);
      expect(result.episode, tEpisodeModel.episode);
      expect(result.airDate, tEpisodeModel.airDate);
      expect(result.characters, tEpisodeModel.characters);
      expect(result.isFavorite, tEpisodeModel.isFavorite);
    });
  });
} 
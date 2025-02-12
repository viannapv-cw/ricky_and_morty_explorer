import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_explorer/data/models/character_model.dart';
import 'package:rick_and_morty_explorer/domain/entities/character.dart';

void main() {
  final tLocationModel = LocationModel(
    name: 'Earth',
    url: 'https://rickandmortyapi.com/api/location/1',
  );

  final tCharacterModel = CharacterModel(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    location: tLocationModel,
  );

  final tCharacterJson = {
    'id': 1,
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    'location': {
      'name': 'Earth',
      'url': 'https://rickandmortyapi.com/api/location/1',
    },
  };

  test('should be a subclass of Character entity', () {
    // assert
    expect(tCharacterModel, isA<Character>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      // arrange
      final Map<String, dynamic> jsonMap = tCharacterJson;
      
      // act
      final result = CharacterModel.fromJson(jsonMap);
      
      // assert
      expect(result.id, tCharacterModel.id);
      expect(result.name, tCharacterModel.name);
      expect(result.status, tCharacterModel.status);
      expect(result.species, tCharacterModel.species);

      expect(result.image, tCharacterModel.image);

      expect(result.location.name, tLocationModel.name);
      expect(result.location.url, tLocationModel.url);
    });

    test('should handle empty type field', () {
      // arrange
      final jsonWithoutType = Map<String, dynamic>.from(tCharacterJson)
        ..remove('type');
      
      // act
      final result = CharacterModel.fromJson(jsonWithoutType);
      
      // assert
      expect(result.id, tCharacterModel.id);
      expect(result.name, tCharacterModel.name);
      expect(result.status, tCharacterModel.status);
      expect(result.species, tCharacterModel.species);
      expect(result.image, tCharacterModel.image);
      expect(result.location.name, tLocationModel.name);
      expect(result.location.url, tLocationModel.url);
    });
  });
} 
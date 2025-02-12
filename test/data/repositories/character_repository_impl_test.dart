import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/data/datasources/character_remote_data_source.dart';
import 'package:rick_and_morty_explorer/data/models/character_model.dart';
import 'package:rick_and_morty_explorer/data/repositories/character_repository_impl.dart';

class MockCharacterRemoteDataSource extends Mock implements CharacterRemoteDataSource {}

void main() {
  late CharacterRepositoryImpl repository;
  late MockCharacterRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSource();
    repository = CharacterRepositoryImpl(mockRemoteDataSource);
  });

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

  final characterUrls = [
    'https://rickandmortyapi.com/api/character/1',
  ];

  group('getCharactersByUrls', () {
    test('should return list of characters when the call is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getCharactersByUrls(any()))
          .thenAnswer((_) async => [tCharacterModel]);

      // act
      final result = await repository.getCharactersByUrls(characterUrls);

      // assert
      expect(result.first.id, equals(tCharacterModel.id));
      expect(result.first.name, equals(tCharacterModel.name));
      expect(result.first.status, equals(tCharacterModel.status));
      expect(result.first.species, equals(tCharacterModel.species));
      expect(result.first.image, equals(tCharacterModel.image));
      expect(result.first.location.name, equals(tCharacterModel.location.name));
      expect(result.first.location.url, equals(tCharacterModel.location.url));
      
      verify(() => mockRemoteDataSource.getCharactersByUrls(characterUrls)).called(1);
    });

    test('should throw Exception when remote data source fails', () async {
      // arrange
      when(() => mockRemoteDataSource.getCharactersByUrls(any()))
          .thenThrow(Exception('Falha ao obter personagens'));

      // act & assert
      expect(
        () => repository.getCharactersByUrls(characterUrls),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Falha ao obter personagens'),
        )),
      );
    });
  });
} 
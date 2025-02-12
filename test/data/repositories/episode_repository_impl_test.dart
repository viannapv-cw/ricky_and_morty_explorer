import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/data/datasources/episode_local_data_source.dart';
import 'package:rick_and_morty_explorer/data/datasources/episode_remote_data_source.dart';
import 'package:rick_and_morty_explorer/data/models/episode_model.dart';
import 'package:rick_and_morty_explorer/data/repositories/episode_repository_impl.dart';

class MockRemoteDataSource extends Mock implements EpisodeRemoteDataSource {}
class MockLocalDataSource extends Mock implements EpisodeLocalDataSource {}

void main() {
  late EpisodeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = EpisodeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tEpisodeModel = EpisodeModel(
    id: 1,
    name: 'Pilot',
    episode: 'S01E01',
    airDate: 'December 2, 2013',
    characters: ['https://rickandmortyapi.com/api/character/1'],
    isFavorite: true,
  );

  final tEpisodeModels = [tEpisodeModel];

  group('getEpisodes', () {
    test('should return remote data when successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getAllEpisodes())
          .thenAnswer((_) async => tEpisodeModels);

      // act & assert
      expect(
        () => repository.getEpisodes(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Falha ao obter episódios'),
        )),
      );
      verify(() => mockRemoteDataSource.getAllEpisodes()).called(1);
    });

    test('should throw Exception when remote fails', () async {
      // arrange
      when(() => mockRemoteDataSource.getAllEpisodes())
          .thenThrow(Exception('Falha ao carregar episódios'));

      // act & assert
      expect(
        () => repository.getEpisodes(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Falha ao obter episódios'),
        )),
      );
    });
  });

  group('getFavoriteEpisodes', () {
    test('should return favorite episodes', () async {
      // arrange
      when(() => mockLocalDataSource.getFavoriteEpisodes())
          .thenAnswer((_) async => tEpisodeModels);

      // act
      final result = await repository.getFavoriteEpisodes();

      // assert
      expect(result, equals(tEpisodeModels));
      verify(() => mockLocalDataSource.getFavoriteEpisodes()).called(1);
    });
  });
}
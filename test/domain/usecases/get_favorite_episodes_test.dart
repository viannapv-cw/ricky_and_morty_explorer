import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';
import 'package:rick_and_morty_explorer/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_favorite_episodes_usecase.dart';

class MockEpisodeRepository extends Mock implements EpisodeRepository {}

void main() {
  late GetFavoriteEpisodesUseCase usecase;
  late MockEpisodeRepository mockRepository;

  setUp(() {
    mockRepository = MockEpisodeRepository();
    usecase = GetFavoriteEpisodesUseCase(mockRepository);
  });

  final tFavoriteEpisodes = [
    Episode(
      id: 1,
      name: 'Pilot',
      episode: 'S01E01',
      airDate: 'December 2, 2013',
      characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/2'],
      isFavorite: true,
    ),
    Episode(
      id: 2,
      name: 'Lawnmower Dog',
      episode: 'S01E02',
      airDate: 'December 9, 2013',
      characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/3'],
      isFavorite: true,
    ),
  ];

  test('should get favorite episodes from the repository', () async {
    // arrange
    when(() => mockRepository.getFavoriteEpisodes())
        .thenAnswer((_) async => tFavoriteEpisodes);

    // act
    final result = await usecase();

    // assert
    expect(result, tFavoriteEpisodes);
    verify(() => mockRepository.getFavoriteEpisodes()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository fails', () async {
    // arrange
    when(() => mockRepository.getFavoriteEpisodes())
        .thenThrow(Exception('Failed to get favorite episodes'));

    // act & assert
    expect(() => usecase(), throwsA(isA<Exception>()));
    verify(() => mockRepository.getFavoriteEpisodes()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
} 
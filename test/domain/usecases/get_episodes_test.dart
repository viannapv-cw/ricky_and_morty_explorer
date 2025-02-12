import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';
import 'package:rick_and_morty_explorer/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_episodes_usecase.dart';

class MockEpisodeRepository extends Mock implements EpisodeRepository {}

void main() {
  late GetEpisodesUseCase usecase;
  late MockEpisodeRepository mockRepository;

  setUp(() {
    mockRepository = MockEpisodeRepository();
    usecase = GetEpisodesUseCase(mockRepository);
  });

  final tEpisodes = [
    Episode(
      id: 1,
      name: 'Pilot',
      episode: 'S01E01',
      airDate: 'December 2, 2013',
      characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/2'],
      isFavorite: false,
    ),
    Episode(
      id: 2,
      name: 'Lawnmower Dog',
      episode: 'S01E02',
      airDate: 'December 9, 2013',
      characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/3'],
      isFavorite: false,
    ),
  ];

  test('should get episodes from the repository', () async {
    // arrange
    when(() => mockRepository.getEpisodes())
        .thenAnswer((_) async => tEpisodes);

    // act
    final result = await usecase();

    // assert
    expect(result, tEpisodes);
    verify(() => mockRepository.getEpisodes()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository fails', () async {
    // arrange
    when(() => mockRepository.getEpisodes())
        .thenThrow(Exception('Failed to get episodes'));

    // act & assert
    expect(() => usecase(), throwsA(isA<Exception>()));
    verify(() => mockRepository.getEpisodes()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
} 
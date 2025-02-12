import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';
import 'package:rick_and_morty_explorer/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty_explorer/domain/usecases/toggle_favorite_usecase.dart';

class MockEpisodeRepository extends Mock implements EpisodeRepository {}

void main() {
  late ToggleFavoriteUseCase usecase;
  late MockEpisodeRepository mockRepository;

  setUp(() {
    mockRepository = MockEpisodeRepository();
    usecase = ToggleFavoriteUseCase(mockRepository);
  });

  final tEpisode = Episode(
    id: 1,
    name: 'Pilot',
    episode: 'S01E01',
    airDate: 'December 2, 2013',
    characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/2'],
    isFavorite: false,
  );

  test('should toggle episode favorite status in the repository', () async {
    // arrange
    when(() => mockRepository.toggleFavorite(tEpisode))
        .thenAnswer((_) async => {});

    // act
    await usecase(tEpisode);

    // assert
    verify(() => mockRepository.toggleFavorite(tEpisode)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository fails', () async {
    // arrange
    when(() => mockRepository.toggleFavorite(tEpisode))
        .thenThrow(Exception('Failed to toggle favorite'));

    // act & assert
    expect(() => usecase(tEpisode), throwsA(isA<Exception>()));
    verify(() => mockRepository.toggleFavorite(tEpisode)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
} 
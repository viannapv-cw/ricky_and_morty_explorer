import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_favorite_episodes_usecase.dart';
import 'package:rick_and_morty_explorer/domain/usecases/toggle_favorite_usecase.dart';
import 'package:rick_and_morty_explorer/presentation/blocs/favorites/favorites_bloc.dart';

class MockGetFavoriteEpisodesUseCase extends Mock implements GetFavoriteEpisodesUseCase {}
class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late FavoritesBloc bloc;
  late MockGetFavoriteEpisodesUseCase mockGetFavorites;
  late MockToggleFavoriteUseCase mockToggleFavorite;

  setUp(() {
    mockGetFavorites = MockGetFavoriteEpisodesUseCase();
    mockToggleFavorite = MockToggleFavoriteUseCase();
    bloc = FavoritesBloc(
      getFavorites: mockGetFavorites,
      toggleFavorite: mockToggleFavorite,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be empty', () {
    expect(bloc.state, const FavoritesState());
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

  blocTest<FavoritesBloc, FavoritesState>(
    'should emit [loading, loaded] when loading favorites successfully',
    build: () {
      when(() => mockGetFavorites())
          .thenAnswer((_) async => tFavoriteEpisodes);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadFavorites()),
    expect: () => [
      const FavoritesState(isLoading: true),
      FavoritesState(
        favorites: tFavoriteEpisodes,
        isLoading: false,
      ),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'should emit [loading, error] when loading favorites fails',
    build: () {
      when(() => mockGetFavorites())
          .thenThrow('Error loading favorites');
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadFavorites()),
    expect: () => [
      const FavoritesState(isLoading: true),
      const FavoritesState(
        isLoading: false,
        error: 'Error loading favorites',
      ),
    ],
  );

  group('ToggleFavoriteInList', () {
    final tEpisode = Episode(
      id: 1,
      name: 'Pilot',
      episode: 'S01E01',
      airDate: 'December 2, 2013',
      characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/2'],
      isFavorite: true,
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'should remove episode from favorites when ToggleFavoriteInList is added',
      build: () {
        when(() => mockToggleFavorite(tEpisode))
            .thenAnswer((_) async => {});
        when(() => mockGetFavorites())
            .thenAnswer((_) async => []);
        return bloc;
      },
      seed: () => FavoritesState(favorites: [tEpisode]),
      act: (bloc) => bloc.add(ToggleFavoriteInList(tEpisode)),
      expect: () => [
        const FavoritesState(favorites: []),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'should emit error when toggling favorite fails',
      build: () {
        when(() => mockToggleFavorite(tEpisode))
            .thenThrow('Error toggling favorite');
        return bloc;
      },
      seed: () => FavoritesState(favorites: [tEpisode]),
      act: (bloc) => bloc.add(ToggleFavoriteInList(tEpisode)),
      expect: () => [
        FavoritesState(
          favorites: [tEpisode],
          error: 'Error toggling favorite',
        ),
      ],
    );
  });
} 
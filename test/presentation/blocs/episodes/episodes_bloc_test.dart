import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_episodes_usecase.dart';
import 'package:rick_and_morty_explorer/domain/usecases/toggle_favorite_usecase.dart';
import 'package:rick_and_morty_explorer/presentation/blocs/episodes/episodes_bloc.dart';

class MockGetEpisodesUseCase extends Mock implements GetEpisodesUseCase {}
class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late EpisodesBloc bloc;
  late MockGetEpisodesUseCase mockGetEpisodes;
  late MockToggleFavoriteUseCase mockToggleFavorite;

  setUp(() {
    mockGetEpisodes = MockGetEpisodesUseCase();
    mockToggleFavorite = MockToggleFavoriteUseCase();
    bloc = EpisodesBloc(
      getEpisodes: mockGetEpisodes,
      toggleFavorite: mockToggleFavorite,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be empty', () {
    expect(bloc.state, const EpisodesState());
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

  blocTest<EpisodesBloc, EpisodesState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(() => mockGetEpisodes())
          .thenAnswer((_) async => tEpisodes);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadEpisodes()),
    expect: () => [
      const EpisodesState(isLoading: true),
      EpisodesState(
        episodes: tEpisodes,
        isLoading: false,
      ),
    ],
  );

  blocTest<EpisodesBloc, EpisodesState>(
    'should emit [loading, error] when getting data fails',
    build: () {
      when(() => mockGetEpisodes())
          .thenThrow('Error fetching episodes');
      return bloc;
    },
    act: (bloc) => bloc.add(LoadEpisodes()),
    expect: () => [
      const EpisodesState(isLoading: true),
      const EpisodesState(
        isLoading: false,
        error: 'Error fetching episodes',
      ),
    ],
  );

  blocTest<EpisodesBloc, EpisodesState>(
    'should filter episodes when SearchEpisodes event is added',
    build: () {
      when(() => mockGetEpisodes())
          .thenAnswer((_) async => tEpisodes);
      return bloc;
    },
    seed: () => EpisodesState(episodes: tEpisodes),
    act: (bloc) => bloc.add(const SearchEpisodes('Pilot')),
    expect: () => [
      EpisodesState(
        episodes: tEpisodes,
        searchQuery: 'Pilot',
      ),
    ],
  );

  blocTest<EpisodesBloc, EpisodesState>(
    'should filter episodes by season when FilterBySeason event is added',
    build: () {
      when(() => mockGetEpisodes())
          .thenAnswer((_) async => tEpisodes);
      return bloc;
    },
    seed: () => EpisodesState(episodes: tEpisodes),
    act: (bloc) => bloc.add(const FilterBySeason('S01')),
    expect: () => [
      EpisodesState(
        episodes: tEpisodes,
        selectedSeason: 'S01',
      ),
    ],
  );

  group('ToggleFavorite', () {
    final tEpisode = Episode(
      id: 1,
      name: 'Pilot',
      episode: 'S01E01',
      airDate: 'December 2, 2013',
      characters: ['https://rickandmortyapi.com/api/character/1', 'https://rickandmortyapi.com/api/character/2'],
      isFavorite: false,
    );

    blocTest<EpisodesBloc, EpisodesState>(
      'should update episode favorite status when ToggleFavorite is added',
      build: () {
        when(() => mockToggleFavorite(tEpisode))
            .thenAnswer((_) async => {});
        return bloc;
      },
      seed: () => EpisodesState(episodes: [tEpisode]),
      act: (bloc) => bloc.add(ToggleFavorite(tEpisode)),
      expect: () => [
        EpisodesState(
          episodes: [tEpisode.copyWith(isFavorite: true)],
        ),
      ],
    );
  });
} 
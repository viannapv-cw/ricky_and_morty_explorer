import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:rick_and_morty_explorer/domain/entities/episode.dart';
import 'package:rick_and_morty_explorer/domain/entities/character.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_episode_details_usecase.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_characters_by_urls_usecase.dart';
import 'package:rick_and_morty_explorer/domain/usecases/toggle_favorite_usecase.dart';
import 'package:rick_and_morty_explorer/presentation/blocs/episode_details/episode_details_bloc.dart';

class MockGetEpisodeDetailsUseCase extends Mock implements GetEpisodeDetailsUseCase {}
class MockGetCharactersByUrlsUseCase extends Mock implements GetCharactersByUrlsUseCase {}
class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late EpisodeDetailsBloc bloc;
  late MockGetEpisodeDetailsUseCase mockGetEpisodeDetails;
  late MockGetCharactersByUrlsUseCase mockGetCharactersByUrls;
  late MockToggleFavoriteUseCase mockToggleFavorite;

  setUpAll(() {
    registerFallbackValue(
      Episode(
        id: 1,
        name: 'Test',
        episode: 'S01E01',
        airDate: 'Test Date',
        characters: [],
        isFavorite: false,
      ),
    );
  });

  setUp(() {
    mockGetEpisodeDetails = MockGetEpisodeDetailsUseCase();
    mockGetCharactersByUrls = MockGetCharactersByUrlsUseCase();
    mockToggleFavorite = MockToggleFavoriteUseCase();
    bloc = EpisodeDetailsBloc(
      getEpisodeDetails: mockGetEpisodeDetails,
      getCharactersByUrls: mockGetCharactersByUrls,
      toggleFavorite: mockToggleFavorite,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tEpisode = Episode(
    id: 1,
    name: 'Pilot',
    episode: 'S01E01',
    airDate: 'December 2, 2013',
    characters: ['https://rickandmortyapi.com/api/character/1'],
    isFavorite: false,
  );

  final tCharacter = Character(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg', 
    location: Location(name: 'Earth', url: 'https://rickandmortyapi.com/api/location/1'),
  );

  group('LoadEpisodeDetails', () {
    blocTest<EpisodeDetailsBloc, EpisodeDetailsState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(() => mockGetEpisodeDetails(any()))
            .thenAnswer((_) async => tEpisode);
        when(() => mockGetCharactersByUrls(any()))
            .thenAnswer((_) async => [tCharacter]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadEpisodeDetails(1)),
      expect: () => [
        EpisodeDetailsLoading(),
        EpisodeDetailsLoaded(tEpisode, characters: null, isCharactersLoaded: false),
        EpisodeDetailsLoaded(tEpisode, characters: [tCharacter], isCharactersLoaded: true),
      ],
      verify: (_) {
        verify(() => mockGetEpisodeDetails(1)).called(1);
        verify(() => mockGetCharactersByUrls(tEpisode.characters)).called(1);
      },
    );

    blocTest<EpisodeDetailsBloc, EpisodeDetailsState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(() => mockGetEpisodeDetails(any()))
            .thenThrow('Failed to load episode details');
        return bloc;
      },
      act: (bloc) => bloc.add(LoadEpisodeDetails(1)),
      expect: () => [
        EpisodeDetailsLoading(),
        EpisodeDetailsError('Failed to load episode details'),
      ],
    );
  });

  group('ToggleFavoriteInDetails', () {
    blocTest<EpisodeDetailsBloc, EpisodeDetailsState>(
      'should emit updated episode when toggle is successful',
      build: () {
        when(() => mockToggleFavorite(any()))
            .thenAnswer((_) async => true);
        when(() => mockGetEpisodeDetails(any()))
            .thenAnswer((_) async => tEpisode.copyWith(isFavorite: true));
        return bloc;
      },
      seed: () => EpisodeDetailsLoaded(tEpisode, characters: [tCharacter], isCharactersLoaded: true),
      act: (bloc) => bloc.add(ToggleFavoriteInDetails(tEpisode)),
      expect: () => [
        EpisodeDetailsLoaded(
          tEpisode.copyWith(isFavorite: true),
          characters: [tCharacter],
          isCharactersLoaded: true,
        ),
      ],
      verify: (_) {
        verify(() => mockToggleFavorite(tEpisode)).called(1);
        verify(() => mockGetEpisodeDetails(tEpisode.id)).called(1);
      },
    );

    blocTest<EpisodeDetailsBloc, EpisodeDetailsState>(
      'should emit error when toggle fails',
      build: () {
        when(() => mockToggleFavorite(any()))
            .thenThrow('Failed to toggle favorite');
        return bloc;
      },
      seed: () => EpisodeDetailsLoaded(tEpisode, characters: [tCharacter], isCharactersLoaded: true),
      act: (bloc) => bloc.add(ToggleFavoriteInDetails(tEpisode)),
      expect: () => [
        EpisodeDetailsError('Failed to toggle favorite'),
      ],
    );
  });
}
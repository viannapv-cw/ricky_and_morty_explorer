import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/entities/character.dart';
import '../../../domain/usecases/get_episode_details_usecase.dart';
import '../../../domain/usecases/get_characters_by_urls_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';

part 'episode_details_event.dart';
part 'episode_details_state.dart';

class EpisodeDetailsBloc extends Bloc<EpisodeDetailsEvent, EpisodeDetailsState> {
  final GetEpisodeDetailsUseCase getEpisodeDetails;
  final GetCharactersByUrlsUseCase getCharactersByUrls;
  final ToggleFavoriteUseCase toggleFavorite;

  EpisodeDetailsBloc({
    required this.getEpisodeDetails,
    required this.getCharactersByUrls,
    required this.toggleFavorite,
  }) : super(EpisodeDetailsInitial()) {
    on<LoadEpisodeDetails>(_onLoadEpisodeDetails);
    on<LoadEpisodeCharacters>(_onLoadEpisodeCharacters);
    on<ToggleFavoriteInDetails>(_onToggleFavorite);
  }

  Future<void> _onLoadEpisodeDetails(
    LoadEpisodeDetails event,
    Emitter<EpisodeDetailsState> emit,
  ) async {
    try {
      emit(EpisodeDetailsLoading());
      final episode = await getEpisodeDetails(event.episodeId);
      emit(EpisodeDetailsLoaded(episode));
      add(LoadEpisodeCharacters(episode.characters));
    } catch (e) {
      emit(EpisodeDetailsError(e.toString()));
    }
  }

  Future<void> _onLoadEpisodeCharacters(
    LoadEpisodeCharacters event,
    Emitter<EpisodeDetailsState> emit,
  ) async {
    try {
      if (state is EpisodeDetailsLoaded) {
        final currentState = state as EpisodeDetailsLoaded;
        final characters = await getCharactersByUrls(event.characterUrls);
        emit(EpisodeDetailsLoaded(currentState.episode, characters: characters));
      }
    } catch (e) {
      emit(EpisodeDetailsError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteInDetails event,
    Emitter<EpisodeDetailsState> emit,
  ) async {
    try {
      if (state is EpisodeDetailsLoaded) {
        final currentState = state as EpisodeDetailsLoaded;
        
        // Atualiza o favorito
        await toggleFavorite(event.episode);
        
        // Obtém o episódio atualizado
        final updatedEpisode = await getEpisodeDetails(event.episode.id);
        
        // Emite o novo estado mantendo a lista de personagens existente
        emit(EpisodeDetailsLoaded(
          updatedEpisode,
          characters: currentState.characters,
        ));
      }
    } catch (e) {
      emit(EpisodeDetailsError(e.toString()));
    }
  }
} 
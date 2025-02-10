import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/usecases/get_episodes_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final GetEpisodesUseCase getEpisodes;
  final ToggleFavoriteUseCase toggleFavorite;
  
  EpisodesBloc({
    required this.getEpisodes,
    required this.toggleFavorite,
  }) : super(EpisodesInitial()) {
    on<LoadEpisodes>(_onLoadEpisodes);
    on<RefreshEpisodes>(_onRefreshEpisodes);
    on<ToggleFavoriteInEpisodes>(_onToggleFavorite);
  }

  Future<void> _onLoadEpisodes(
    LoadEpisodes event,
    Emitter<EpisodesState> emit,
  ) async {
    try {
      if (state is EpisodesInitial) {
        emit(EpisodesLoading());
      }
      
      final episodes = await getEpisodes(page: event.page);
      emit(EpisodesLoaded(episodes));
    } catch (e) {
      emit(EpisodesError(e.toString()));
    }
  }

  Future<void> _onRefreshEpisodes(
    RefreshEpisodes event,
    Emitter<EpisodesState> emit,
  ) async {
    try {
      emit(EpisodesLoading());
      final episodes = await getEpisodes(page: 1);
      emit(EpisodesLoaded(episodes));
    } catch (e) {
      emit(EpisodesError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteInEpisodes event,
    Emitter<EpisodesState> emit,
  ) async {
    try {
      await toggleFavorite(event.episode);
      if (state is EpisodesLoaded) {
        final currentState = state as EpisodesLoaded;
        final updatedEpisodes = currentState.episodes.map((episode) {
          if (episode.id == event.episode.id) {
            return Episode(
              id: episode.id,
              name: episode.name,
              airDate: episode.airDate,
              episode: episode.episode,
              characters: episode.characters,
              isFavorite: !episode.isFavorite,
            );
          }
          return episode;
        }).toList();
        emit(EpisodesLoaded(updatedEpisodes));
      }
    } catch (e) {
      emit(EpisodesError(e.toString()));
    }
  }
} 
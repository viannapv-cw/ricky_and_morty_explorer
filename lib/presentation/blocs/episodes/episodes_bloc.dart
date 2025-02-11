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
  }) : super(const EpisodesState()) {
    on<LoadEpisodes>(_onLoadEpisodes);
    on<SearchEpisodes>(_onSearchEpisodes);
    on<FilterBySeason>(_onFilterBySeason);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadEpisodes(LoadEpisodes event, Emitter<EpisodesState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final episodes = await getEpisodes();
      emit(state.copyWith(
        episodes: episodes,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onSearchEpisodes(SearchEpisodes event, Emitter<EpisodesState> emit) {
    emit(state.copyWith(
      searchQuery: event.query,
      selectedSeason: state.selectedSeason,
    ));
  }

  void _onFilterBySeason(FilterBySeason event, Emitter<EpisodesState> emit) {
    emit(state.copyWith(
      selectedSeason: event.season,
      searchQuery: state.searchQuery,
    ));
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<EpisodesState> emit) async {
    try {
      await toggleFavorite(event.episode);
      
      final updatedEpisodes = state.episodes.map((episode) {
        if (episode.id == event.episode.id) {
          return episode.copyWith(isFavorite: !episode.isFavorite);
        }
        return episode;
      }).toList();
      
      emit(state.copyWith(
        episodes: updatedEpisodes,
        searchQuery: state.searchQuery,
        selectedSeason: state.selectedSeason,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
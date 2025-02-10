import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/usecases/get_favorite_episodes_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteEpisodesUseCase getFavoriteEpisodes;
  final ToggleFavoriteUseCase toggleFavorite;

  FavoritesBloc({
    required this.getFavoriteEpisodes,
    required this.toggleFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteInList>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());
      final episodes = await getFavoriteEpisodes();
      if (episodes.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        emit(FavoritesLoaded(episodes));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteInList event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await toggleFavorite(event.episode);
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
} 
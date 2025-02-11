import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/usecases/get_favorite_episodes_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteEpisodesUseCase getFavorites;
  final ToggleFavoriteUseCase toggleFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteInList>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final favorites = await getFavorites();
      print('Loaded favorites: ${favorites.length}'); // Debug log
      emit(state.copyWith(
        favorites: favorites,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      print('Error loading favorites: $e'); // Debug log
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteInList event, Emitter<FavoritesState> emit) async {
    try {
      await toggleFavorite(event.episode);
      
      // Remove o episódio da lista de favoritos imediatamente
      final updatedFavorites = state.favorites.where((episode) => 
        episode.id != event.episode.id
      ).toList();
      
      emit(state.copyWith(
        favorites: updatedFavorites,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
} 
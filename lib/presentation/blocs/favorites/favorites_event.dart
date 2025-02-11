part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class ToggleFavoriteInList extends FavoritesEvent {
  final Episode episode;

  const ToggleFavoriteInList(this.episode);

  @override
  List<Object> get props => [episode];
} 
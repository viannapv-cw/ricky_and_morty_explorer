part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesEmpty extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Episode> episodes;

  const FavoritesLoaded(this.episodes);

  @override
  List<Object> get props => [episodes];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
} 
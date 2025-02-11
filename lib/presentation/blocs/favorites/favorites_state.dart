part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final List<Episode> favorites;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<Episode>? favorites,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [favorites, isLoading, error];
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
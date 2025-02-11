part of 'episodes_bloc.dart';

class EpisodesState extends Equatable {
  final List<Episode> episodes;
  final String searchQuery;
  final String? selectedSeason;
  final bool isLoading;
  final String? error;

  const EpisodesState({
    this.episodes = const [],
    this.searchQuery = '',
    this.selectedSeason,
    this.isLoading = false,
    this.error,
  });

  List<Episode> get filteredEpisodes {
    return episodes.where((episode) {
      final matchesSearch = searchQuery.isEmpty || 
        episode.name.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesSeason = selectedSeason == null || 
        episode.episode.startsWith(selectedSeason!);
      
      return matchesSearch && matchesSeason;
    }).toList();
  }

  EpisodesState copyWith({
    List<Episode>? episodes,
    String? searchQuery,
    String? selectedSeason,
    bool? isLoading,
    String? error,
  }) {
    return EpisodesState(
      episodes: episodes ?? this.episodes,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSeason: selectedSeason,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [episodes, searchQuery, selectedSeason, isLoading, error];
}

class EpisodesInitial extends EpisodesState {}

class EpisodesLoading extends EpisodesState {}

class EpisodesLoaded extends EpisodesState {
  final List<Episode> episodes;
  final bool hasReachedMax;

  const EpisodesLoaded(this.episodes, {this.hasReachedMax = false});

  @override
  List<Object> get props => [episodes, hasReachedMax];
}

class EpisodesError extends EpisodesState {
  final String message;

  const EpisodesError(this.message);

  @override
  List<Object> get props => [message];
} 
part of 'episodes_bloc.dart';

abstract class EpisodesEvent extends Equatable {
  const EpisodesEvent();

  @override
  List<Object?> get props => [];
}

class LoadEpisodes extends EpisodesEvent {
  const LoadEpisodes();
}

class SearchEpisodes extends EpisodesEvent {
  final String query;

  const SearchEpisodes(this.query);

  @override
  List<Object> get props => [query];
}

class FilterBySeason extends EpisodesEvent {
  final String? season;

  const FilterBySeason(this.season);

  @override
  List<Object?> get props => [season];
}

class RefreshEpisodes extends EpisodesEvent {}

class ToggleFavoriteInEpisodes extends EpisodesEvent {
  final Episode episode;

  const ToggleFavoriteInEpisodes(this.episode);

  @override
  List<Object> get props => [episode];
}

class ToggleFavorite extends EpisodesEvent {
  final Episode episode;

  const ToggleFavorite(this.episode);

  @override
  List<Object> get props => [episode];
} 
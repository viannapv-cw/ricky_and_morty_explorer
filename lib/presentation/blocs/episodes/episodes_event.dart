part of 'episodes_bloc.dart';

abstract class EpisodesEvent extends Equatable {
  const EpisodesEvent();

  @override
  List<Object> get props => [];
}

class LoadEpisodes extends EpisodesEvent {
  final int page;

  const LoadEpisodes({this.page = 1});

  @override
  List<Object> get props => [page];
}

class RefreshEpisodes extends EpisodesEvent {}

class ToggleFavoriteInEpisodes extends EpisodesEvent {
  final Episode episode;

  const ToggleFavoriteInEpisodes(this.episode);

  @override
  List<Object> get props => [episode];
} 
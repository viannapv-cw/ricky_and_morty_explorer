part of 'episode_details_bloc.dart';

abstract class EpisodeDetailsEvent extends Equatable {
  const EpisodeDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadEpisodeDetails extends EpisodeDetailsEvent {
  final int episodeId;

  const LoadEpisodeDetails(this.episodeId);

  @override
  List<Object> get props => [episodeId];
}

class LoadEpisodeCharacters extends EpisodeDetailsEvent {
  final List<String> characterUrls;

  const LoadEpisodeCharacters(this.characterUrls);

  @override
  List<Object> get props => [characterUrls];
}

class ToggleFavoriteInDetails extends EpisodeDetailsEvent {
  final Episode episode;

  const ToggleFavoriteInDetails(this.episode);

  @override
  List<Object> get props => [episode];
} 
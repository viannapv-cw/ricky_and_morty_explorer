part of 'episode_details_bloc.dart';

abstract class EpisodeDetailsState extends Equatable {
  const EpisodeDetailsState();
  
  @override
  List<Object> get props => [];
}

class EpisodeDetailsInitial extends EpisodeDetailsState {}

class EpisodeDetailsLoading extends EpisodeDetailsState {}

class EpisodeDetailsError extends EpisodeDetailsState {
  final String message;

  const EpisodeDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class EpisodeDetailsLoaded extends EpisodeDetailsState {
  final Episode episode;
  final List<Character>? characters;

  const EpisodeDetailsLoaded(this.episode, {this.characters});

  @override
  List<Object> get props => [episode, characters ?? []];
} 
part of 'episodes_bloc.dart';

abstract class EpisodesState extends Equatable {
  const EpisodesState();
  
  @override
  List<Object> get props => [];
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
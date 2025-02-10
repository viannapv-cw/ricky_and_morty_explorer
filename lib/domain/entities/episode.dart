import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;
  final bool isFavorite;

  const Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [id, name, airDate, episode, characters, isFavorite];
} 
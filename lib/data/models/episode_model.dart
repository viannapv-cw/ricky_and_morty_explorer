import '../../domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required int id,
    required String name,
    required String airDate,
    required String episode,
    required List<String> characters,
    bool isFavorite = false,
  }) : super(
          id: id,
          name: name,
          airDate: airDate,
          episode: episode,
          characters: characters,
          isFavorite: isFavorite,
        );

  // Construtor nomeado normal
  EpisodeModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          name: json['name'],
          airDate: json['air_date'],
          episode: json['episode'],
          characters: List<String>.from(json['characters']),
          isFavorite: false,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
      'characters': characters,
    };
  }
}
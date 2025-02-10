import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.image,
    required super.location,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      location: LocationModel.fromJson(json['location']),
    );
  }
}

class LocationModel extends Location {
  LocationModel({
    required super.name,
    required super.url,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      url: json['url'],
    );
  }
} 
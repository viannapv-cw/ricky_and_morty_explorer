class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final Location location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.location,
  });
}

class Location {
  final String name;
  final String url;

  Location({
    required this.name,
    required this.url,
  });
} 
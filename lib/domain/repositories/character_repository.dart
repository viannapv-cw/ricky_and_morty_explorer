import '../entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharactersByUrls(List<String> urls);
} 
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharactersByUrlsUseCase {
  final CharacterRepository repository;

  GetCharactersByUrlsUseCase(this.repository);

  Future<List<Character>> call(List<String> urls) async {
    return await repository.getCharactersByUrls(urls);
  }
} 
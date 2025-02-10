import '../models/character_model.dart';
import '../../core/network/api_client.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharactersByUrls(List<String> urls);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final ApiClient client;

  CharacterRemoteDataSourceImpl(this.client);

  @override
  Future<List<CharacterModel>> getCharactersByUrls(List<String> urls) async {
    try {
      final List<CharacterModel> characters = [];
      
      for (final url in urls) {
        final response = await client.get(url);
        characters.add(CharacterModel.fromJson(response.data));
      }

      return characters;
    } catch (e) {
      throw Exception('Falha ao carregar personagens: $e');
    }
  }
} 
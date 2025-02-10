import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_data_source.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Character>> getCharactersByUrls(List<String> urls) async {
    try {
      return await remoteDataSource.getCharactersByUrls(urls);
    } catch (e) {
      throw Exception('Falha ao obter personagens');
    }
  }
} 
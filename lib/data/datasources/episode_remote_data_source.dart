import '../models/episode_model.dart';
import '../models/pagination_info_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

abstract class EpisodeRemoteDataSource {
  Future<List<EpisodeModel>> getAllEpisodes();
  Future<EpisodeModel> getEpisodeById(int id);
}

class EpisodeRemoteDataSourceImpl implements EpisodeRemoteDataSource {
  final ApiClient client;

  EpisodeRemoteDataSourceImpl(this.client);

  @override
  Future<List<EpisodeModel>> getAllEpisodes() async {
    try {
      // Primeira requisição para obter informações de paginação
      final initialResponse = await client.get(
        ApiConstants.episodesEndpoint,
      );
      
      final info = PaginationInfoModel.fromJson(initialResponse.data['info']);
      final List<EpisodeModel> allEpisodes = [];
      
      // Adiciona os episódios da primeira página
      final firstPageResults = initialResponse.data['results'] as List;
      allEpisodes.addAll(
        firstPageResults.map((json) => EpisodeModel.fromJson(json))
      );

      // Carrega as páginas restantes
      for (int page = 2; page <= info.pages; page++) {
        final response = await client.get(
          ApiConstants.episodesEndpoint,
          queryParameters: {'page': page},
        );
        
        final results = response.data['results'] as List;
        allEpisodes.addAll(
          results.map((json) => EpisodeModel.fromJson(json))
        );
      }

      return allEpisodes;
    } catch (e) {
      throw Exception('Falha ao carregar episódios: $e');
    }
  }

  @override
  Future<EpisodeModel> getEpisodeById(int id) async {
    try {
      final response = await client.get(
        '${ApiConstants.episodesEndpoint}/$id',
      );
      
      return EpisodeModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Falha ao carregar episódio: $e');
    }
  }
}
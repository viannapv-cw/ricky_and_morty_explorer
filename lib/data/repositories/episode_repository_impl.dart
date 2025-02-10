import 'package:rick_and_morty_explorer/domain/entities/episode.dart';

import '../../domain/repositories/episode_repository.dart';
import '../datasources/episode_remote_data_source.dart';
import '../datasources/episode_local_data_source.dart';
import '../models/episode_model.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;
  final EpisodeLocalDataSource localDataSource;

  EpisodeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Episode>> getEpisodes({int page = 1}) async {
    try {
      final remoteEpisodes = await remoteDataSource.getAllEpisodes();
      final favoriteEpisodes = await localDataSource.getFavoriteEpisodes();
      
      return remoteEpisodes.map((episode) {
        final isFavorite = favoriteEpisodes.any((fav) => fav.id == episode.id);
        return EpisodeModel(
          id: episode.id,
          name: episode.name,
          airDate: episode.airDate,
          episode: episode.episode,
          characters: episode.characters,
          isFavorite: isFavorite,
        );
      }).toList();
    } catch (e) {
      throw Exception('Falha ao obter episódios');
    }
  }

  @override
  Future<Episode> getEpisodeById(int id) async {
    try {
      final episode = await remoteDataSource.getEpisodeById(id);
      final favoriteEpisodes = await localDataSource.getFavoriteEpisodes();
      final isFavorite = favoriteEpisodes.any((fav) => fav.id == episode.id);
      
      return EpisodeModel(
        id: episode.id,
        name: episode.name,
        airDate: episode.airDate,
        episode: episode.episode,
        characters: episode.characters,
        isFavorite: isFavorite,
      );
    } catch (e) {
      throw Exception('Falha ao obter episódio');
    }
  }

  @override
  Future<List<Episode>> getFavoriteEpisodes() async {
    try {
      final favorites = await localDataSource.getFavoriteEpisodes();
      return favorites.map((episode) => 
        EpisodeModel(
          id: episode.id,
          name: episode.name,
          airDate: episode.airDate,
          episode: episode.episode,
          characters: episode.characters,
          isFavorite: true,
        )
      ).toList();
    } catch (e) {
      throw Exception('Falha ao obter favoritos');
    }
  }

  @override
  Future<void> toggleFavorite(Episode episode) async {
    try {
      if (episode.isFavorite) {
        await localDataSource.removeFavoriteEpisode(episode.id);
      } else {
        await localDataSource.saveFavoriteEpisode(
          EpisodeModel(
            id: episode.id,
            name: episode.name,
            airDate: episode.airDate,
            episode: episode.episode,
            characters: episode.characters,
            isFavorite: true,
          ),
        );
      }
    } catch (e) {
      throw Exception('Falha ao atualizar favorito');
    }
  }
} 
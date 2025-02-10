import '../entities/episode.dart';

abstract class EpisodeRepository {
  Future<List<Episode>> getEpisodes({int page = 1});
  Future<Episode> getEpisodeById(int id);
  Future<List<Episode>> getFavoriteEpisodes();
  Future<void> toggleFavorite(Episode episode);
} 
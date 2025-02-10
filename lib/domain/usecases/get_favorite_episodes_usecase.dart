import '../entities/episode.dart';
import '../repositories/episode_repository.dart';

class GetFavoriteEpisodesUseCase {
  final EpisodeRepository repository;

  GetFavoriteEpisodesUseCase(this.repository);

  Future<List<Episode>> call() {
    return repository.getFavoriteEpisodes();
  }
} 
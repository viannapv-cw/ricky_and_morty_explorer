import '../repositories/episode_repository.dart';
import '../entities/episode.dart';

class GetEpisodesUseCase {
  final EpisodeRepository repository;

  GetEpisodesUseCase(this.repository);

  Future<List<Episode>> call({int page = 1}) {
    return repository.getEpisodes(page: page);
  }
} 
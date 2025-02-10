import '../repositories/episode_repository.dart';
import '../entities/episode.dart';

class GetEpisodeDetailsUseCase {
  final EpisodeRepository repository;

  GetEpisodeDetailsUseCase(this.repository);

  Future<Episode> call(int id) {
    return repository.getEpisodeById(id);
  }
} 
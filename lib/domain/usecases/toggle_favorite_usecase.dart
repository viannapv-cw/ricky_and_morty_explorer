import '../repositories/episode_repository.dart';
import '../entities/episode.dart';

class ToggleFavoriteUseCase {
  final EpisodeRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(Episode episode) {
    return repository.toggleFavorite(episode);
  }
} 
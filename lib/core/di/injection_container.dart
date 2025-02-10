import 'package:get_it/get_it.dart';
import 'package:rick_and_morty_explorer/domain/usecases/get_favorite_episodes_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/episode_local_data_source.dart';
import '../../data/datasources/episode_remote_data_source.dart';
import '../../data/datasources/character_remote_data_source.dart';
import '../../data/repositories/episode_repository_impl.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/episode_repository.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/usecases/get_episodes_usecase.dart';
import '../../domain/usecases/get_episode_details_usecase.dart';
import '../../domain/usecases/get_characters_by_urls_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../presentation/blocs/episodes/episodes_bloc.dart';
import '../../presentation/blocs/episode_details/episode_details_bloc.dart';
import '../../presentation/blocs/favorites/favorites_bloc.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // BLoCs
  getIt.registerFactory(
    () => EpisodesBloc(
      getEpisodes: getIt(),
      toggleFavorite: getIt(),
    ),
  );

  getIt.registerFactory(
    () => EpisodeDetailsBloc(
      getEpisodeDetails: getIt(),
      getCharactersByUrls: getIt(),
      toggleFavorite: getIt(),
    ),
  );

  getIt.registerFactory(
    () => FavoritesBloc(
      getFavoriteEpisodes: getIt(),
      toggleFavorite: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetEpisodesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetEpisodeDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCharactersByUrlsUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleFavoriteUseCase(getIt()));
  getIt.registerLazySingleton(() => GetFavoriteEpisodesUseCase(getIt()));

  // Repositories
  getIt.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  
  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(getIt()),
  );

  // Data Sources
  getIt.registerLazySingleton<EpisodeRemoteDataSource>(
    () => EpisodeRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<EpisodeLocalDataSource>(
    () => EpisodeLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(getIt()),
  );

  // Core
  getIt.registerLazySingleton(() => ApiClient());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
} 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/episode_model.dart';

abstract class EpisodeLocalDataSource {
  Future<List<EpisodeModel>> getFavoriteEpisodes();
  Future<void> saveFavoriteEpisode(EpisodeModel episode);
  Future<void> removeFavoriteEpisode(int episodeId);
}

class EpisodeLocalDataSourceImpl implements EpisodeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String FAVORITE_EPISODES_KEY = 'FAVORITE_EPISODES';

  EpisodeLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<EpisodeModel>> getFavoriteEpisodes() async {
    final jsonString = sharedPreferences.getString(FAVORITE_EPISODES_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => EpisodeModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> saveFavoriteEpisode(EpisodeModel episode) async {
    final favorites = await getFavoriteEpisodes();
    favorites.add(episode);
    final jsonString = json.encode(favorites.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(FAVORITE_EPISODES_KEY, jsonString);
  }

  @override
  Future<void> removeFavoriteEpisode(int episodeId) async {
    final favorites = await getFavoriteEpisodes();
    favorites.removeWhere((episode) => episode.id == episodeId);
    final jsonString = json.encode(favorites.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(FAVORITE_EPISODES_KEY, jsonString);
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_explorer/core/theme/app_colors.dart';
import 'package:rick_and_morty_explorer/presentation/blocs/episodes/episodes_bloc.dart';
import 'package:rick_and_morty_explorer/presentation/blocs/favorites/favorites_bloc.dart';
import '../../domain/entities/episode.dart';
import '../pages/episode_details_page.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final bool isInFavoritesPage;

  const EpisodeCard({
    Key? key,
    required this.episode,
    required this.isInFavoritesPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(episode.name),
        subtitle: Text('${episode.episode} - ${episode.airDate}'),
        trailing: IconButton(
          icon: Icon(
            episode.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: episode.isFavorite ? AppColors.favorite : null,
          ),
          onPressed: () {
            if (isInFavoritesPage) {
              context.read<FavoritesBloc>().add(ToggleFavoriteInList(episode));
            } else {
              context.read<EpisodesBloc>().add(ToggleFavorite(episode));
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailsPage(episodeId: episode.id),
            ),
          );
        },
      ),
    );
  }
} 
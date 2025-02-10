import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/episode.dart';
import '../blocs/episodes/episodes_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final bool isInFavoritesPage;

  const EpisodeCard({
    Key? key,
    required this.episode,
    this.isInFavoritesPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(episode.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(episode.episode),
            Text('Air Date: ${episode.airDate}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            episode.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: episode.isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            if (isInFavoritesPage) {
              context.read<FavoritesBloc>().add(
                ToggleFavoriteInList(episode),
              );
            } else {
              context.read<EpisodesBloc>().add(
                ToggleFavoriteInEpisodes(episode),
              );
            }
          },
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/episode-details',
            arguments: episode.id,
          );
        },
      ),
    );
  }
} 
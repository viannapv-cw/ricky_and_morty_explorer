import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_explorer/core/theme/app_colors.dart';
import '../blocs/episode_details/episode_details_bloc.dart';
import '../blocs/episodes/episodes_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/episode.dart';
import '../../core/di/injection_container.dart';

class EpisodeDetailsPage extends StatelessWidget {
  final int episodeId;

  const EpisodeDetailsPage({
    Key? key,
    required this.episodeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EpisodeDetailsBloc>()
        ..add(LoadEpisodeDetails(episodeId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Episode Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  // Atualiza o estado dos favoritos
                  context.read<FavoritesBloc>().add(LoadFavorites());
                  // Aguarda um momento para garantir que o estado foi atualizado
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (context.mounted) {
                    Navigator.pop(context, true); // Indica que houve alteração
                  }
                },
              ),
            ),
            body: BlocBuilder<EpisodeDetailsBloc, EpisodeDetailsState>(
              builder: (context, state) {
                if (state is EpisodeDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is EpisodeDetailsError) {
                  return Center(child: Text(state.message));
                }
                
                if (state is EpisodeDetailsLoaded) {
                  return _buildEpisodeDetails(context, state.episode, state.characters);
                }
                
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodeDetails(BuildContext context, Episode episode, List<Character>? characters) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  episode.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              BlocBuilder<EpisodeDetailsBloc, EpisodeDetailsState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      episode.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: episode.isFavorite ? AppColors.favorite : null,
                    ),
                    onPressed: (state is EpisodeDetailsLoaded && state.isCharactersLoaded)
                      ? () {
                          context.read<EpisodeDetailsBloc>().add(
                            ToggleFavoriteInDetails(episode),
                          );
                          context.read<FavoritesBloc>().add(LoadFavorites());
                          context.read<EpisodesBloc>().add(const LoadEpisodes());
                        }
                      : null,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Episode: ${episode.episode}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Air Date: ${episode.airDate}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Characters:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (characters != null)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(character.image),
                    ),
                    title: Text(character.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: character.status.toLowerCase() == 'alive'
                                    ? Colors.green
                                    : character.status.toLowerCase() == 'dead'
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                            ),
                            Text('${character.status} - ${character.species}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Last known location:'),
                        Text(character.location.name),
                      ],
                    ),
                  ),
                );
              },
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
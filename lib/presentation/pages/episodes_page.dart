import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/episodes/episodes_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../widgets/episode_card.dart';

class EpisodesPage extends StatelessWidget {
  const EpisodesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Episodes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () async {
              context.read<FavoritesBloc>().add(LoadFavorites());
              await Future.delayed(const Duration(milliseconds: 100));
              if (context.mounted) {
                final result = await Navigator.pushNamed(context, '/favorites');
                if (result == true && context.mounted) {
                  context.read<EpisodesBloc>().add(const LoadEpisodes());
                  context.read<FavoritesBloc>().add(LoadFavorites());
                }
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<EpisodesBloc, EpisodesState>(
        builder: (context, state) {
          if (state is EpisodesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is EpisodesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EpisodesBloc>().add(const LoadEpisodes());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          if (state is EpisodesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EpisodesBloc>().add(const LoadEpisodes());
              },
              child: ListView.builder(
                itemCount: state.episodes.length,
                itemBuilder: (context, index) {
                  return EpisodeCard(
                    episode: state.episodes[index],
                    isInFavoritesPage: false,
                  );
                },
              ),
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
} 
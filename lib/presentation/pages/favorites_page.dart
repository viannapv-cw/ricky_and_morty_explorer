import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/episodes/episodes_bloc.dart';
import '../widgets/episode_card.dart';
import '../../core/di/injection_container.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Episodes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Atualiza o estado dos episódios
            context.read<EpisodesBloc>().add(const LoadEpisodes());
            // Aguarda um momento para garantir que o estado foi atualizado
            await Future.delayed(const Duration(milliseconds: 100));
            if (context.mounted) {
              Navigator.pop(context, true); // Indica que houve alteração
            }
          },
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(LoadFavorites());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          if (state is FavoritesEmpty) {
            return const Center(
              child: Text('No favorite episodes yet'),
            );
          }
          
          if (state is FavoritesLoaded) {
            return ListView.builder(
              itemCount: state.episodes.length,
              itemBuilder: (context, index) {
                final episode = state.episodes[index];
                return GestureDetector(
                  onTap: () async {
                    // Aguarda o retorno da navegação
                    final result = await Navigator.pushNamed(
                      context,
                      '/episode-details',
                      arguments: episode.id,
                    );
                    
                    // Se houve alteração, atualiza a lista
                    if (result == true && context.mounted) {
                      context.read<FavoritesBloc>().add(LoadFavorites());
                    }
                  },
                  child: EpisodeCard(
                    episode: episode,
                    isInFavoritesPage: true,
                  ),
                );
              },
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
} 
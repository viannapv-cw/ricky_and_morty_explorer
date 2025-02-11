import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/episodes/episodes_bloc.dart';
import '../widgets/episode_card.dart';
import '../../core/di/injection_container.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Carrega os favoritos quando a página é criada
    context.read<FavoritesBloc>().add(const LoadFavorites());
  }

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
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          }

          if (state.favorites.isEmpty) {
            return const Center(
              child: Text('No favorite episodes yet'),
            );
          }

          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              return EpisodeCard(
                episode: state.favorites[index],
                isInFavoritesPage: true,
              );
            },
          );
        },
      ),
    );
  }
} 
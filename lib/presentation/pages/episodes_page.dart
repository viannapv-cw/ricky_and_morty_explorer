import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_explorer/core/theme/theme_provider.dart';
import '../blocs/episodes/episodes_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../widgets/episode_card.dart';

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({Key? key}) : super(key: key);

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  @override
  void initState() {
    super.initState();
    // Carrega os episódios quando a página é criada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EpisodesBloc>().add(const LoadEpisodes());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Episodes'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
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
      body: Column(
        children: [
          _buildFilters(context),
          Expanded(
            child: _buildEpisodesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search episodes...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              context.read<EpisodesBloc>().add(SearchEpisodes(value));
            },
          ),
          const SizedBox(height: 12),
          // Season Filter
          BlocBuilder<EpisodesBloc, EpisodesState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Seasons'),
                      selected: state.selectedSeason == null,
                      onSelected: (_) {
                        context.read<EpisodesBloc>().add(const FilterBySeason(null));
                      },
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(5, (index) {
                      final season = 'S${(index + 1).toString().padLeft(2, '0')}';
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text('Season ${index + 1}'),
                          selected: state.selectedSeason == season,
                          onSelected: (_) {
                            context.read<EpisodesBloc>().add(
                              FilterBySeason(state.selectedSeason == season ? null : season)
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesList() {
    return BlocBuilder<EpisodesBloc, EpisodesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.error}'),
                const SizedBox(height: 16),
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

        final episodes = state.filteredEpisodes;
        
        if (episodes.isEmpty) {
          // Adiciona log para debug
          print('Episodes list is empty. Total episodes: ${state.episodes.length}');
          print('Search query: ${state.searchQuery}');
          print('Selected season: ${state.selectedSeason}');
          
          return const Center(
            child: Text('No episodes found'),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<EpisodesBloc>().add(const LoadEpisodes());
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              return EpisodeCard(
                episode: episode,
                isInFavoritesPage: false,
              );
            },
          ),
        );
      },
    );
  }
} 
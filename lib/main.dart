import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/pages/episodes_page.dart';
import 'presentation/pages/episode_details_page.dart';
import 'presentation/pages/favorites_page.dart';
import 'presentation/blocs/episodes/episodes_bloc.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EpisodesBloc>(
          create: (context) => di.getIt<EpisodesBloc>()
            ..add(const LoadEpisodes()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => di.getIt<FavoritesBloc>()
            ..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        title: 'Rick and Morty Explorer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const EpisodesPage(),
          '/favorites': (context) => const FavoritesPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/episode-details') {
            final episodeId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => EpisodeDetailsPage(episodeId: episodeId),
            );
          }
          return null;
        },
      ),
    );
  }
}

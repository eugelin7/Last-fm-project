import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mylastfm/logic/locst_albums_cubit.dart';
import 'package:mylastfm/ui/screens/shared.dart';
import 'package:provider/provider.dart';
import '=models=/image.dart' as img_model;
import 'data/i_lastfm_service.dart';
import 'data/i_local_storage_service.dart';
import 'data/implementations/lastfm_service.dart';
import 'data/implementations/local_storage.dart';
import 'ui/screens/album_details_screen.dart';
import 'ui/screens/albums_screen.dart';
import 'ui/screens/home_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // in order to show splash screen for a little longer...
  await Future.delayed(const Duration(milliseconds: 1200));

  await dotenv.load(fileName: '.env');

  GetIt.I.registerSingleton<ILastfmService>(LastfmService());
  GetIt.I.registerSingleton<ILocalStorageService>(LocalStorage());
  await GetIt.I<ILocalStorageService>().init();

  FlutterNativeSplash.remove();

  runApp(
    ChangeNotifierProvider(
      // we inject it here, because we use SharedRepo in several screens
      create: (_) => SharedRepo()..savedAlbumsNeedsReLoading(true),
      child: MultiBlocProvider(
        providers: [
          // we inject it here, because we use LocstAlbumsCubit in several screens
          BlocProvider(create: (_) => LocstAlbumsCubit(locSt: GetIt.I<ILocalStorageService>())),
        ],
        child: LastfmApp(),
      ),
    ),
  );
}

//---
class LastfmApp extends StatelessWidget {
  LastfmApp({
    Key? key,
  }) : super(key: key);

  final _router = GoRouter(
    initialLocation: HomeScreen.route,
    routes: [
      GoRoute(
        path: HomeScreen.route,
        name: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AlbumsScreen.route,
        name: AlbumsScreen.route,
        builder: (context, state) => AlbumsScreen(
          artistName: state.params['artistName'] ?? '',
        ),
      ),
      GoRoute(
        path: AlbumDetailsScreen.route,
        name: AlbumDetailsScreen.route,
        builder: (context, state) => AlbumDetailsScreen(
          artistName: state.params['artistName'] ?? '',
          albumName: state.params['albumName'] ?? '',
          albImages: state.extra! as List<img_model.Image>,
        ),
      ),
    ],
    //debugLogDiagnostics: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Last fm',
      theme: ThemeData(primarySwatch: Colors.pink),
      debugShowCheckedModeBanner: false,
    );
  }
}

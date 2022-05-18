import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mylastfm/data/i_lastfm_service.dart';
import 'package:mylastfm/logic/albums_cubit.dart';
import '../widgets/albums_screen_widgets/albums_query_result.dart';

class AlbumsScreen extends StatelessWidget {
  static const route = '/albums/:artistName';

  final String artistName;

  const AlbumsScreen({Key? key, required this.artistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (artistName.isEmpty) return const SizedBox.shrink();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AlbumsCubit(lastfmService: GetIt.I<ILastfmService>())
            ..getAlbumsByArtistName(artistName: artistName),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(artistName)),
        body: SafeArea(
          child: AlbumsQueryResult(artistName: artistName),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

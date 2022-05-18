import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mylastfm/=models=/image.dart' as img_model;
import 'package:mylastfm/data/i_lastfm_service.dart';
import 'package:mylastfm/data/i_local_storage_service.dart';
import 'package:mylastfm/logic/locst_checker_cubit.dart';
import 'package:mylastfm/logic/locst_remover_cubit.dart';
import 'package:mylastfm/logic/locst_writer_cubit.dart';
import 'package:mylastfm/logic/album_info_cubit.dart';
import '../widgets/album_details_screen_widgets/album_content.dart';
import '../widgets/album_details_screen_widgets/album_popup_menu_button.dart';
import '../widgets/album_details_screen_widgets/appbar_image.dart';

class AlbumDetailsScreen extends StatefulWidget {
  static const route = '/albuminfo/:artistName/:albumName';

  final String artistName;
  final String albumName;
  final List<img_model.Image> albImages;

  const AlbumDetailsScreen({
    Key? key,
    required this.artistName,
    required this.albumName,
    required this.albImages,
  }) : super(key: key);

  @override
  State<AlbumDetailsScreen> createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.artistName.isEmpty || widget.albumName.isEmpty) return const SizedBox.shrink();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AlbumInfoCubit(lastfmService: GetIt.I<ILastfmService>())
            ..getAlbumInfo(
              artistName: widget.artistName,
              albumName: widget.albumName,
            ),
        ),
        BlocProvider(
          create: (_) => LocstCheckerCubit(locSt: GetIt.I<ILocalStorageService>())
            ..checkAlbumInStorage(
              artistName: widget.artistName,
              albumName: widget.albumName,
            ),
        ),
        BlocProvider(
          create: (_) => LocstWriterCubit(locSt: GetIt.I<ILocalStorageService>()),
        ),
        BlocProvider(
          create: (_) => LocstRemoverCubit(locSt: GetIt.I<ILocalStorageService>()),
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 260,
              actions: [
                AlbumPopupMenuButton(
                  artistName: widget.artistName,
                  albumName: widget.albumName,
                ),
              ],
              flexibleSpace: AppBarImage(
                controller: _controller,
                artistName: widget.artistName,
                albumName: widget.albumName,
                albImages: widget.albImages,
              ),
            ),
            const AlbumContent()
          ],
        ),
      ),
    );
  }
}

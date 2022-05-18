import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'package:mylastfm/=models=/artist.dart';
import 'package:mylastfm/logic/locst_albums_cubit.dart';
import 'package:mylastfm/logic/locst_remover_cubit.dart';
import 'package:mylastfm/ui/screens/albums_screen.dart';
import 'package:provider/provider.dart';
import '../../screens/album_details_screen.dart';
import 'search_field_state.dart';

class ActionHandlers {
  // Home Page on Home Screen -> Grid Tile Tap
  static void localAlbumGridTileTapHandler(BuildContext context, AlbumInfo album) {
    context.pushNamed(
      AlbumDetailsScreen.route,
      params: {'artistName': album.artistName, 'albumName': album.name},
      extra: album.images,
    );
  }

  // Home Page on Home Screen -> Popup Menu -> "Remove all saved albums" item Tap
  static void removeAllSavedAlbumsItemTapHandler(BuildContext context) async {
    await context.read<LocstRemoverCubit>().removeAllAlbumsFromStorage();
    context.read<LocstAlbumsCubit>().getAlbumsFromStorage();
  }

  // Artist Page on Home Screen -> List Tile Tap
  static void artistListTileTapHandler(BuildContext context, Artist artist) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<SearchFieldState>().setFocusedStateTo(false);
    context.read<SearchFieldState>().setDoRefocusTo(false);

    context.pushNamed(AlbumsScreen.route, params: {'artistName': artist.name});
  }
}

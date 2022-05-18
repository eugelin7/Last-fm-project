import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../=models=/album.dart';
import '../../screens/album_details_screen.dart';

class ActionHandlers {
  // Albums Screen -> List Tile Tap
  static void albumListTileTapHandler(BuildContext context, Album album) {
    context.pushNamed(
      AlbumDetailsScreen.route,
      params: {'artistName': album.artistName, 'albumName': album.name},
      extra: album.images,
    );
  }
}

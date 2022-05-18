import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'package:mylastfm/logic/locst_checker_cubit.dart';
import 'package:mylastfm/logic/locst_remover_cubit.dart';
import 'package:mylastfm/logic/locst_writer_cubit.dart';
import 'package:mylastfm/ui/screens/shared.dart';
import 'package:provider/provider.dart';

class ActionHandlers {
  // Album Details Screen -> Popup Menu -> "Remove from saved list" item Tap
  static void removeAlbumFromSavedListItemTapHandler(
    BuildContext context,
    String artistName,
    String albumName,
  ) async {
    await context.read<LocstRemoverCubit>().removeAlbumFromStorage(
          artistName: artistName,
          albumName: albumName,
        );
    context.read<LocstCheckerCubit>().checkAlbumInStorage(
          artistName: artistName,
          albumName: albumName,
        );
    // We must reload locally saved albums
    context.read<SharedRepo>().savedAlbumsNeedsReLoading(true);
  }

  // Album Details Screen -> Save Button press
  static void saveAlbumToTheLocalStoragePressHandler(
    BuildContext context,
    AlbumInfo albumInfo,
  ) async {
    await context.read<LocstWriterCubit>().saveAlbum(albumInfo);
    context.read<LocstCheckerCubit>().checkAlbumInStorage(
          artistName: albumInfo.artistName,
          albumName: albumInfo.name,
        );
    // We must reload locally saved albums
    context.read<SharedRepo>().savedAlbumsNeedsReLoading(true);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/logic/x_status.dart';
import '../../../logic/albums_cubit.dart';
import 'album_list_tile.dart';

class AlbumsQueryResult extends StatelessWidget {
  final String artistName;

  const AlbumsQueryResult({Key? key, required this.artistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albumsState = context.watch<AlbumsCubit>().state;

    switch (albumsState.status) {
      case XStatus.initial:
        return const SizedBox.shrink();
      //---
      case XStatus.inProgress:
        return const Center(child: CircularProgressIndicator());
      //---
      case XStatus.failure:
        return Center(
            child: (albumsState.errorMsg != null)
                ? Text(albumsState.errorMsg!, textAlign: TextAlign.center)
                : const Text('Something went wrong', textAlign: TextAlign.center));
      //---
      case XStatus.success:
    }

    final albums = albumsState.albumsList;

    if (albums.isEmpty) {
      return const Center(
        child: Text('Not found', style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) => AlbumListTile(album: albums[index]),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }
}

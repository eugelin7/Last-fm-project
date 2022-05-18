import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/logic/x_status.dart';
import '../../../logic/artists_cubit.dart';
import 'artist_list_tile.dart';

class ArtistsSearchResult extends StatelessWidget {
  const ArtistsSearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final artistsState = context.watch<ArtistsCubit>().state;

    switch (artistsState.status) {
      //---
      case XStatus.initial:
        return const Center(
          child: Text('Type to find an artist', style: TextStyle(fontSize: 18)),
        );
      //---
      case XStatus.inProgress:
        return const Center(child: CircularProgressIndicator());
      //---
      case XStatus.failure:
        return Center(
            child: (artistsState.errorMsg != null)
                ? Text(artistsState.errorMsg!, textAlign: TextAlign.center)
                : const Text('Something went wrong', textAlign: TextAlign.center));
      //---
      case XStatus.success:
    }

    final artists = artistsState.artistsList;

    if (artists.isEmpty) {
      return const Center(
        child: Text('Not found', style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) => ArtistListTile(artist: artists[index]),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/logic/locst_albums_cubit.dart';
import 'package:mylastfm/logic/x_status.dart';
import 'package:mylastfm/ui/screens/shared.dart';
import 'package:provider/provider.dart';
import 'album_grid_tile.dart';

class SavedAlbumsContent extends StatelessWidget {
  final bool needsLoading;

  const SavedAlbumsContent({Key? key, required this.needsLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locStAlbumsState = context.watch<LocstAlbumsCubit>().state;

    switch (locStAlbumsState.status) {
      //---
      case XStatus.initial:
        if (needsLoading) {
          BlocProvider.of<LocstAlbumsCubit>(context, listen: false).getAlbumsFromStorage();
        }
        return const SizedBox.shrink();
      //---
      case XStatus.inProgress:
        return const Center(child: Text('...'));
      //---
      case XStatus.failure:
        return Center(
            child: (locStAlbumsState.errorMsg != null)
                ? Text(locStAlbumsState.errorMsg!, textAlign: TextAlign.center)
                : const Text('Something went wrong', textAlign: TextAlign.center));
      //---
      case XStatus.success:
    }

    // Local albums successfully loaded, so we don't need reloading anymore
    Provider.of<SharedRepo>(context, listen: false).savedAlbumsReLoadingFinished();

    final albums = locStAlbumsState.albums;

    if (albums.isEmpty) {
      return const Center(child: Text('There are no saved albums'));
    }

    return GridView.builder(
      itemCount: albums.length,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      itemBuilder: (_, index) => AlbumGridTile(album: albums[index]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.764,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        crossAxisCount: 2,
      ),
    );
  }
}

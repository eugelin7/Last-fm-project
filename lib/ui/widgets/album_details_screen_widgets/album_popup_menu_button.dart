import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/logic/locst_checker_cubit.dart';
import 'package:mylastfm/logic/x_status.dart';
import 'package:provider/provider.dart';
import '_action_handlers.dart';

class AlbumPopupMenuButton extends StatelessWidget {
  final String artistName;
  final String albumName;

  const AlbumPopupMenuButton({
    Key? key,
    required this.artistName,
    required this.albumName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkerState = context.watch<LocstCheckerCubit>().state;

    switch (checkerState.status) {
      case XStatus.initial:
      case XStatus.inProgress:
      case XStatus.failure:
        return const SizedBox.shrink();
      //---
      case XStatus.success:
    }

    // Here we know the result of checking

    if (!checkerState.isAlbumInStorage) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text('Remove album from saved list'),
          height: 38,
          padding: const EdgeInsets.only(left: 16),
          onTap: () =>
              ActionHandlers.removeAlbumFromSavedListItemTapHandler(context, artistName, albumName),
        ),
      ],
    );
  }
}

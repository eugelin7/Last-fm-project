import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'package:mylastfm/logic/locst_checker_cubit.dart';
import 'package:mylastfm/logic/locst_writer_cubit.dart';
import 'package:mylastfm/logic/x_status.dart';
import '_action_handlers.dart';

class SaveAlbumButton extends StatelessWidget {
  final AlbumInfo albumInfo;

  const SaveAlbumButton({
    Key? key,
    required this.albumInfo,
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
      // As album is not saved locally we must show the "Save" button.
      // That's why we need to set "Writer" into initial state every time
      // as the "Save" button may be shown and hidden several times
      BlocProvider.of<LocstWriterCubit>(context, listen: false).toInitial();
    }

    return SizedBox(
      height: 28,
      child: checkerState.isAlbumInStorage
          // Album is already in local storage
          ? const _AlbumInStorageSign()
          //
          // Album doesn't present in local storage
          // So we must show the "Save" button
          : _SaveAlbumButton(albumInfo: albumInfo),
    );
  }
}

//------
// A button which can be pressed to save album to the local storage

class _SaveAlbumButton extends StatelessWidget {
  final AlbumInfo albumInfo;

  const _SaveAlbumButton({
    Key? key,
    required this.albumInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final writerState = context.watch<LocstWriterCubit>().state;

    switch (writerState.status) {
      case XStatus.initial:
        return OutlinedButton(
          child: const Text('Save'),
          onPressed: () =>
              ActionHandlers.saveAlbumToTheLocalStoragePressHandler(context, albumInfo),
        );
      //---
      case XStatus.inProgress:
      case XStatus.failure:
        return const SizedBox.shrink();
      //---
      case XStatus.success:
        // The album has been successfully saved to the local storage
        return const _AlbumInStorageSign();
    }
  }
}

//------
// A sign which is displayed when the album is in the local storage

class _AlbumInStorageSign extends StatelessWidget {
  const _AlbumInStorageSign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(
        Icons.grade,
        color: Colors.pink.shade300,
      ),
    );
  }
}

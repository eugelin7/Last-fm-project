import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylastfm/logic/x_status.dart';
import '../../../logic/album_info_cubit.dart';
import 'album_overview.dart';
import 'album_tags_wrap.dart';
import 'track_list_tile.dart';

class AlbumContent extends StatelessWidget {
  const AlbumContent({Key? key}) : super(key: key);

  Widget _sliverWidget(Widget child) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, __) => child,
        childCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final albumInfoState = context.watch<AlbumInfoCubit>().state;

    switch (albumInfoState.status) {
      case XStatus.initial:
        return _sliverWidget(const SizedBox.shrink());
      //---
      case XStatus.inProgress:
        return _sliverWidget(
          const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      //---
      case XStatus.failure:
        return _sliverWidget(
          SizedBox(
            height: 200,
            child: (albumInfoState.errorMsg != null)
                ? Text(albumInfoState.errorMsg!, textAlign: TextAlign.center)
                : const Text('Something went wrong', textAlign: TextAlign.center),
          ),
        );
      //---
      case XStatus.success:
    }

    // albumInfoState.albumInfo can't be null here
    // as status = AlbumInfoStatus.success
    final _albumInfo = albumInfoState.albumInfo!;

    Widget? _buildSliverItem(BuildContext context, int index) {
      switch (index) {
        case 0:
          return AlbumOverviewWidget(albumInfo: _albumInfo);
        case 1:
          return AlbumTagsWrap(tags: _albumInfo.tags);
      }
      return TrackListTile(
        track: _albumInfo.tracks[index - 2],
        trackNumber: index - 1,
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        _buildSliverItem,
        childCount: _albumInfo.tracks.length + 2,
      ),
    );
  }
}

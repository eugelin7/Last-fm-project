import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_lastfm_service.dart';
import '../=models=/album.dart';
import 'x_status.dart';

//------
// State

class AlbumsState extends Equatable {
  final XStatus status;
  final List<Album> albumsList;
  final String? errorMsg;

  const AlbumsState({
    this.status = XStatus.initial,
    this.albumsList = const [],
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, albumsList, errorMsg];
}

//------
// Cubit

class AlbumsCubit extends Cubit<AlbumsState> {
  final ILastfmService _lastfmService;

  AlbumsCubit({required ILastfmService lastfmService})
      : _lastfmService = lastfmService,
        super(const AlbumsState());

  Future<void> getAlbumsByArtistName({required String artistName}) async {
    if (artistName.isEmpty) {
      toInitial();
      return;
    }
    emit(const AlbumsState(status: XStatus.inProgress));
    try {
      final _albumsList = await _lastfmService.fetchAlbums(artistName: artistName);
      emit(AlbumsState(status: XStatus.success, albumsList: _albumsList));
    } catch (e) {
      emit(AlbumsState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void toInitial() {
    emit(const AlbumsState(status: XStatus.initial));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_lastfm_service.dart';
import '../=models=/album_info.dart';
import 'x_status.dart';

//------
// State

class AlbumInfoState extends Equatable {
  final XStatus status;
  final AlbumInfo? albumInfo;
  final String? errorMsg;

  const AlbumInfoState({
    this.status = XStatus.initial,
    this.albumInfo,
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, albumInfo, errorMsg];
}

//------
// Cubit

class AlbumInfoCubit extends Cubit<AlbumInfoState> {
  final ILastfmService _lastfmService;

  AlbumInfoCubit({required ILastfmService lastfmService})
      : _lastfmService = lastfmService,
        super(const AlbumInfoState());

  Future<void> getAlbumInfo({required String artistName, required String albumName}) async {
    if ((artistName.isEmpty) || (albumName.isEmpty)) {
      toInitial();
      return;
    }
    emit(const AlbumInfoState(status: XStatus.inProgress));
    try {
      final _albumInfo =
          await _lastfmService.fetchAlbumInfo(artistName: artistName, albumName: albumName);
      emit(AlbumInfoState(status: XStatus.success, albumInfo: _albumInfo));
    } catch (e) {
      emit(AlbumInfoState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void toInitial() {
    emit(const AlbumInfoState(status: XStatus.initial));
  }
}

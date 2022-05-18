import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_local_storage_service.dart';
import '../=models=/album_info.dart';
import 'x_status.dart';

//------
// State

class LocstAlbumsState extends Equatable {
  final XStatus status;
  final List<AlbumInfo> albums;
  final String? errorMsg;

  const LocstAlbumsState({
    this.status = XStatus.initial,
    this.albums = const [],
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, albums, errorMsg];
}

//------
// Cubit

class LocstAlbumsCubit extends Cubit<LocstAlbumsState> {
  final ILocalStorageService _localStorage;

  LocstAlbumsCubit({required ILocalStorageService locSt})
      : _localStorage = locSt,
        super(const LocstAlbumsState());

  Future<void> getAlbumsFromStorage() async {
    emit(const LocstAlbumsState(status: XStatus.inProgress));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final _albums = await _localStorage.readAllSavedAlbums();
      emit(LocstAlbumsState(status: XStatus.success, albums: _albums));
    } catch (e) {
      emit(LocstAlbumsState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void toInitial() {
    emit(const LocstAlbumsState(status: XStatus.initial));
  }
}

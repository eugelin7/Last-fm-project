import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_local_storage_service.dart';
import '../=models=/album_info.dart';
import 'x_status.dart';

//------
// State

class LocstWriterState extends Equatable {
  final XStatus status;
  final String? errorMsg;

  const LocstWriterState({
    this.status = XStatus.initial,
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, errorMsg];
}

//------
// Cubit

class LocstWriterCubit extends Cubit<LocstWriterState> {
  final ILocalStorageService _localStorage;

  LocstWriterCubit({required ILocalStorageService locSt})
      : _localStorage = locSt,
        super(const LocstWriterState());

  Future<void> saveAlbum(AlbumInfo album) async {
    emit(const LocstWriterState(status: XStatus.inProgress));
    try {
      await _localStorage.saveAlbum(album: album);
      emit(const LocstWriterState(status: XStatus.success));
    } catch (e) {
      emit(LocstWriterState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void toInitial() {
    emit(const LocstWriterState(status: XStatus.initial));
  }
}

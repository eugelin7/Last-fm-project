import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_local_storage_service.dart';
import 'x_status.dart';

//------
// State

class LocstRemoverState extends Equatable {
  final XStatus status;
  final String? errorMsg;

  const LocstRemoverState({
    this.status = XStatus.initial,
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, errorMsg];
}

//------
// Cubit

class LocstRemoverCubit extends Cubit<LocstRemoverState> {
  final ILocalStorageService _localStorage;

  LocstRemoverCubit({required ILocalStorageService locSt})
      : _localStorage = locSt,
        super(const LocstRemoverState());

  Future<void> removeAllAlbumsFromStorage() async {
    emit(const LocstRemoverState(status: XStatus.inProgress));
    try {
      await _localStorage.removeAllAlbumsFromStorage();
      emit(const LocstRemoverState(status: XStatus.success));
    } catch (e) {
      emit(LocstRemoverState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  Future<void> removeAlbumFromStorage(
      {required String artistName, required String albumName}) async {
    emit(const LocstRemoverState(status: XStatus.inProgress));
    try {
      await _localStorage.removeAlbumFromStorage(artistName: artistName, albumName: albumName);
      emit(const LocstRemoverState(status: XStatus.success));
    } catch (e) {
      emit(LocstRemoverState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void toInitial() {
    emit(const LocstRemoverState(status: XStatus.initial));
  }
}

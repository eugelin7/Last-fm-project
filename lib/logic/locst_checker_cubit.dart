import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_local_storage_service.dart';
import 'x_status.dart';

//------
// State

class LocstCheckerState extends Equatable {
  final XStatus status;
  final bool isAlbumInStorage;
  final String? errorMsg;

  const LocstCheckerState({
    this.status = XStatus.initial,
    this.isAlbumInStorage = false,
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, isAlbumInStorage, errorMsg];
}

//------
// Cubit

class LocstCheckerCubit extends Cubit<LocstCheckerState> {
  final ILocalStorageService _localStorage;

  LocstCheckerCubit({required ILocalStorageService locSt})
      : _localStorage = locSt,
        super(const LocstCheckerState());

  Future<void> checkAlbumInStorage({required String artistName, required String albumName}) async {
    emit(const LocstCheckerState(status: XStatus.inProgress));
    try {
      final _answer =
          await _localStorage.checkAlbumInStorage(artistName: artistName, albumName: albumName);
      emit(LocstCheckerState(status: XStatus.success, isAlbumInStorage: _answer));
    } catch (e) {
      emit(LocstCheckerState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void toInitial() {
    emit(const LocstCheckerState(status: XStatus.initial));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylastfm/data/i_lastfm_service.dart';
import '../=models=/artist.dart';
import 'x_status.dart';

//------
// State

class ArtistsState extends Equatable {
  final XStatus status;
  final List<Artist> artistsList;
  final String? errorMsg;

  const ArtistsState({
    this.status = XStatus.initial,
    this.artistsList = const [],
    this.errorMsg,
  });

  @override
  List<Object?> get props => [status, artistsList, errorMsg];
}

//------
// Cubit

class ArtistsCubit extends Cubit<ArtistsState> {
  final ILastfmService _lastfmService;

  ArtistsCubit({required ILastfmService lastfmService})
      : _lastfmService = lastfmService,
        super(const ArtistsState());

  Future<void> getArtistsBySearchString({required String searchString}) async {
    if (searchString.isEmpty) {
      clearArtistsSearchResults();
      return;
    }
    emit(const ArtistsState(status: XStatus.inProgress));
    try {
      final _artistsList = await _lastfmService.fetchArtists(searchString: searchString);
      emit(ArtistsState(status: XStatus.success, artistsList: _artistsList));
    } catch (e) {
      emit(ArtistsState(status: XStatus.failure, errorMsg: e.toString()));
    }
  }

  void clearArtistsSearchResults() {
    emit(const ArtistsState(status: XStatus.initial, artistsList: []));
  }
}

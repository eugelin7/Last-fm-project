import 'package:mylastfm/=models=/album_info.dart';

abstract class ILocalStorageService {
  //
  Future<void> init();
  //
  Future<void> saveAlbum({required AlbumInfo album});
  //
  Future<List<AlbumInfo>> readAllSavedAlbums();
  //
  Future<bool> checkAlbumInStorage({required String artistName, required String albumName});
  //
  Future<void> removeAllAlbumsFromStorage();
  //
  Future<void> removeAlbumFromStorage({required String artistName, required String albumName});
}

import '../../=models=/artist.dart';
import '../../=models=/album.dart';
import '../../=models=/album_info.dart';

abstract class ILastfmService {
  //
  Future<List<Artist>> fetchArtists({
    required String searchString,
  });
  //
  Future<List<Album>> fetchAlbums({
    required String artistName,
  });
  //
  Future<AlbumInfo> fetchAlbumInfo({
    required String artistName,
    required String albumName,
  });
  //
}

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mylastfm/=models=/album_info.dart';
import '../i_local_storage_service.dart';
import 'hive_adapters/album_info_adapter.dart';
import 'hive_adapters/album_info_with_time_stamp.dart';
import 'hive_adapters/album_info_with_time_stamp_adapter.dart';
import 'hive_adapters/image_adapter.dart';
import 'hive_adapters/tag_adapter.dart';
import 'hive_adapters/track_adapter.dart';
import 'hive_adapters/wiki_adapter.dart';

class LocalStorage implements ILocalStorageService {
  static String lastfmBoxName = 'LastfmBox';

  late final Box<AlbumInfoWithTimeStamp> _box;

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(WikiAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(TrackAdapter());
    Hive.registerAdapter(ImageAdapter());
    Hive.registerAdapter(AlbumInfoAdapter());
    Hive.registerAdapter(AlbumInfoWithTimeStampAdapter());

    _box = await Hive.openBox<AlbumInfoWithTimeStamp>(lastfmBoxName);
  }

  String _calcKey({required String artistName, required String albumName}) {
    final key = sha256
        .convert(utf8.encode('${artistName.toUpperCase()}-${albumName.toUpperCase()}'))
        .toString();
    return key;
  }

  @override
  Future<List<AlbumInfo>> readAllSavedAlbums() async {
    final albList = _box.values.toList();
    albList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    return albList.map((e) => e.albumInfo).toList();
  }

  @override
  Future<void> saveAlbum({required AlbumInfo album}) async {
    final key = _calcKey(artistName: album.artistName, albumName: album.name);
    await _box.put(
      key,
      AlbumInfoWithTimeStamp(
        timeStamp: DateFormat('yyyy-MM-dd--HH:mm:ss').format(DateTime.now()),
        albumInfo: album,
      ),
    );
  }

  @override
  Future<bool> checkAlbumInStorage({required String artistName, required String albumName}) async {
    final key = _calcKey(artistName: artistName, albumName: albumName);
    final res = _box.keys.contains(key);
    return res;
  }

  @override
  Future<void> removeAllAlbumsFromStorage() async {
    _box.clear();
  }

  @override
  Future<void> removeAlbumFromStorage(
      {required String artistName, required String albumName}) async {
    final key = _calcKey(artistName: artistName, albumName: albumName);
    if (_box.keys.contains(key)) {
      _box.delete(key);
    }
  }
}

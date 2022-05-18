import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mylastfm/=models=/album.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../=models=/artist.dart';
import '../i_lastfm_service.dart';

class LastfmService implements ILastfmService {
  late final Dio _dio;

  LastfmService() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://ws.audioscrobbler.com/2.0';
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.queryParameters = {
      'format': 'json',
      'api_key': dotenv.env['LastFmApiKey'],
    };
    // _dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseHeader: true,
    //     responseBody: false,
    //     //error: true,
    //     //compact: true,
    //     //maxWidth: 90,
    //   ),
    // );
  }

  // Cache
  final Map<String, String> _fetchArtistsCache = {};
  final Map<String, String> _fetchAlbumsCache = {};
  final Map<String, String> _fetchAlbumInfoCache = {};

  //-------
  @override
  Future<List<Artist>> fetchArtists({required String searchString}) async {
    if (_fetchArtistsCache.containsKey(searchString)) {
      //print(searchString + ' --- from cache !');
      final artistsJsonStr = _fetchArtistsCache[searchString]!;
      final artistsJson =
          jsonDecode(artistsJsonStr)['results']['artistmatches']['artist'] as List<dynamic>;
      return artistsJson.map((a) => Artist.fromJson(a)).toList();
    }

    try {
      final response = await _dio.get(
        '/',
        queryParameters: {
          'method': 'artist.search',
          'artist': searchString,
        },
      );
      final artistsJson = response.data['results']['artistmatches']['artist'] as List<dynamic>;
      final artists = artistsJson.map((a) => Artist.fromJson(a)).toList();
      if (!_fetchArtistsCache.containsKey(searchString)) {
        _fetchArtistsCache[searchString] = jsonEncode(response.data);
      }
      return artists;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //-------
  @override
  Future<List<Album>> fetchAlbums({required String artistName}) async {
    if (_fetchAlbumsCache.containsKey(artistName)) {
      //print(artistName + ' --- from cache !');
      final albumsJsonStr = _fetchAlbumsCache[artistName]!;
      final albumsJson = jsonDecode(albumsJsonStr)['topalbums']['album'] as List<dynamic>;
      return albumsJson.map((a) => Album.fromJson(a)).toList();
    }

    try {
      final response = await _dio.get(
        '/',
        queryParameters: {
          'method': 'artist.gettopalbums',
          'artist': artistName,
        },
      );
      final albumsJson = response.data['topalbums']['album'] as List<dynamic>;
      final albums = albumsJson.map((a) => Album.fromJson(a)).toList();
      if (!_fetchAlbumsCache.containsKey(artistName)) {
        _fetchAlbumsCache[artistName] = jsonEncode(response.data);
      }
      return albums;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //-------
  @override
  Future<AlbumInfo> fetchAlbumInfo({required String artistName, required String albumName}) async {
    final cacheKey = '$artistName --- $albumName';
    if (_fetchAlbumInfoCache.containsKey(cacheKey)) {
      //print(artistName + ' ' + albumName + ' --- from cache !');
      final albumInfoJsonStr = _fetchAlbumInfoCache[cacheKey]!;
      final albumInfoJson = jsonDecode(albumInfoJsonStr)['album'];
      return AlbumInfo.fromJson(albumInfoJson);
    }

    try {
      final response = await _dio.get(
        '/',
        queryParameters: {
          'method': 'album.getinfo',
          'artist': artistName,
          'album': albumName,
        },
      );
      final albumInfoJson = response.data['album'];
      final albumInfo = AlbumInfo.fromJson(albumInfoJson);
      if (!_fetchAlbumInfoCache.containsKey(cacheKey)) {
        _fetchAlbumInfoCache[cacheKey] = jsonEncode(response.data);
      }
      return albumInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

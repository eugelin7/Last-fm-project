import 'image.dart';
import 'tag.dart';
import 'track.dart';
import 'wiki.dart';

class AlbumInfo {
  final String name;
  final String mbid;
  final String artistName;
  final int listeners;
  final String url;
  final int playCount;
  final List<Tag> tags;
  final List<Image> images;
  final List<Track> tracks;
  final Wiki wiki;

  const AlbumInfo({
    required this.name,
    required this.mbid,
    required this.artistName,
    required this.listeners,
    required this.url,
    required this.playCount,
    required this.tags,
    required this.images,
    required this.tracks,
    required this.wiki,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? _imagesJson = json['image'];

    List<dynamic>? _tagsJson;
    try {
      _tagsJson = json['tags']['tag'];
    } catch (e) {
      _tagsJson = [];
    }

    List<dynamic>? _tracksJson;
    try {
      _tracksJson = json['tracks']['track'];
    } catch (e) {
      try {
        _tracksJson = [json['tracks']['track']];
      } catch (e) {
        _tracksJson = [];
      }
    }

    return AlbumInfo(
      name: json['name'] ?? '',
      mbid: json['mbid'] ?? '',
      artistName: json['artist'] ?? '',
      listeners: int.tryParse(json['listeners'].toString()) ?? 0,
      url: json['url'] ?? '',
      playCount: int.tryParse(json['playcount'].toString()) ?? 0,
      tags: (_tagsJson == null) ? [] : _tagsJson.map((x) => Tag.fromJson(x)).toList(),
      images: (_imagesJson == null) ? [] : _imagesJson.map((x) => Image.fromJson(x)).toList(),
      tracks: (_tracksJson == null) ? [] : _tracksJson.map((x) => Track.fromJson(x)).toList(),
      wiki: (json['wiki'] == null) ? Wiki.empty() : Wiki.fromJson(json['wiki']),
    );
  }
}

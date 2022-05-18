import 'image.dart';

class Album {
  final String name;
  final int playCount;
  final String mbid;
  final String url;
  final String artistName;
  final String artistMbid;
  final List<Image> images;

  const Album({
    required this.name,
    required this.playCount,
    required this.mbid,
    required this.url,
    required this.artistName,
    required this.artistMbid,
    required this.images,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> _artistJson = json['artist'];
    return Album(
      name: json['name'] ?? '',
      playCount: int.tryParse(json['playcount'].toString()) ?? 0,
      mbid: json['mbid'] ?? '',
      url: json['url'] ?? '',
      artistName: _artistJson['name'] ?? '',
      artistMbid: _artistJson['mbid'] ?? '',
      images: List<Image>.from(json['image'].map((x) => Image.fromJson(x))),
    );
  }
}

import 'image.dart';

class Artist {
  final String name;
  final int listeners;
  final String mbid;
  final String url;
  final String streamable;
  final List<Image> images;

  const Artist({
    required this.name,
    required this.listeners,
    required this.mbid,
    required this.url,
    required this.streamable,
    required this.images,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json['name'] ?? '',
        listeners: int.tryParse(json['listeners']) ?? 0,
        mbid: json['mbid'] ?? '',
        url: json['url'] ?? '',
        streamable: json['streamable'] ?? '',
        images: List<Image>.from(json['image'].map((x) => Image.fromJson(x))),
      );
}

class Track {
  final int duration;
  final String url;
  final String name;
  final String artistName;
  final String artistMbid;

  const Track({
    required this.duration,
    required this.url,
    required this.name,
    required this.artistName,
    required this.artistMbid,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> _artistJson = json['artist'];
    return Track(
      duration: int.tryParse(json['duration'].toString()) ?? 0,
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      artistName: _artistJson['name'] ?? '',
      artistMbid: _artistJson['mbid'] ?? '',
    );
  }
}

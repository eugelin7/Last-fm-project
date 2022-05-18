class Tag {
  final String url;
  final String name;

  const Tag({
    required this.url,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        url: json['url'] ?? '',
        name: json['name'] ?? '',
      );
}

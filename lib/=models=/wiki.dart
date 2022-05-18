class Wiki {
  final String published;
  final String summary;
  final String content;

  const Wiki({
    required this.published,
    required this.summary,
    required this.content,
  });

  factory Wiki.fromJson(Map<String, dynamic> json) {
    return Wiki(
      published: json['published'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
    );
  }

  factory Wiki.empty() {
    return const Wiki(
      published: '',
      summary: '',
      content: '',
    );
  }
}

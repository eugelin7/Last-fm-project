import 'package:flutter/foundation.dart';

enum ImageSize { small, medium, large, extralarge, mega }

class Image {
  final String text;
  final ImageSize size;

  const Image({
    required this.text,
    required this.size,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    var imgSize = ImageSize.extralarge;
    if (json['size'].toString().isNotEmpty) {
      imgSize =
          ImageSize.values.firstWhere((e) => describeEnum(e) == json['size']);
    }
    return Image(
      text: json['#text'] ?? '',
      size: imgSize,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../=models=/image.dart';
import '../../../=models=/artist.dart';
import '_action_handlers.dart';

class ArtistListTile extends StatelessWidget {
  final Artist artist;

  const ArtistListTile({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imgUrl;
    try {
      imgUrl = artist.images.firstWhere((img) => img.size == ImageSize.large).text;
    } catch (e) {
      imgUrl = '';
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: _getCachedNetworkImage(imgUrl),
      ),
      title: Text(
        artist.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${NumberFormat.decimalPattern("en").format(artist.listeners)} listeners'),
      onTap: () => ActionHandlers.artistListTileTapHandler(context, artist),
    );
  }
}

//---
ImageProvider? _getCachedNetworkImage(String url) {
  if (url.isEmpty) return null;

  ImageProvider? image;
  try {
    image = CachedNetworkImageProvider(url);
  } catch (e) {
    image = null;
  }
  return image;
}

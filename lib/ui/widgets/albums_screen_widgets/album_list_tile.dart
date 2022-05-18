import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../=models=/image.dart';
import '../../../=models=/album.dart';
import '_action_handlers.dart';

class AlbumListTile extends StatelessWidget {
  final Album album;

  const AlbumListTile({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imgUrl;
    try {
      imgUrl = album.images.firstWhere((img) => img.size == ImageSize.large).text;
    } catch (e) {
      imgUrl = '';
    }

    const clrLightGrey = 0xFFE0E0E0;
    const clrLightPink = 0xFFFCE4EC;

    const iconAlbum = SizedBox(
      width: 64,
      height: 64,
      child: Center(
        child: Icon(Icons.library_music, size: 54, color: Color(clrLightGrey)),
      ),
    );

    const iconError = SizedBox(
      width: 64,
      height: 64,
      child: Center(
        child: Icon(Icons.error, size: 50, color: Color(clrLightPink)),
      ),
    );

    return ListTile(
      onTap: () => ActionHandlers.albumListTileTapHandler(context, album),
      leading: imgUrl.isEmpty
          ? iconError
          : CachedNetworkImage(
              imageUrl: imgUrl,
              width: 64,
              height: 64,
              placeholder: (_, __) => iconAlbum,
              errorWidget: (_, __, ___) => iconError,
            ),
      title: Text(
        album.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${NumberFormat.decimalPattern("en").format(album.playCount)} plays'),
    );
  }
}

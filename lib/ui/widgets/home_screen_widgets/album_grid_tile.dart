import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'package:mylastfm/=models=/image.dart' as image_model;
import '_action_handlers.dart';

class AlbumGridTile extends StatelessWidget {
  final AlbumInfo album;

  const AlbumGridTile({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      color: Colors.grey.shade100,
      elevation: 5,
      child: InkWell(
        onTap: () => ActionHandlers.localAlbumGridTileTapHandler(context, album),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 6),
              child: Text(album.artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.secularOne(
                    fontSize: 15,
                    color: Colors.grey[800],
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _AlbumImage(images: album.images),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 1),
              child: Text(
                album.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.signikaNegative(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.blueGrey[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 8),
              child: Text(
                '${NumberFormat.decimalPattern("en").format(album.listeners)} listeners',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                    fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//---
class _AlbumImage extends StatelessWidget {
  final List<image_model.Image> images;

  const _AlbumImage({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeHolder = Icon(Icons.library_music, size: 128, color: Color(0x55BDBDBD));

    String imgUrl;
    try {
      imgUrl = images.firstWhere((img) => img.size == image_model.ImageSize.large).text;
    } catch (e) {
      imgUrl = '';
    }

    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imgUrl,
      placeholder: (_, __) => placeHolder,
      errorWidget: (_, __, ___) => placeHolder,
    );
  }
}

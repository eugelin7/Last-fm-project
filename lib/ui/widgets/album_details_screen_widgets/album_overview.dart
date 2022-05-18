import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../=models=/album_info.dart';
import 'save_album_button.dart';

class AlbumOverviewWidget extends StatelessWidget {
  final AlbumInfo albumInfo;

  const AlbumOverviewWidget({
    Key? key,
    required this.albumInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  albumInfo.name,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SaveAlbumButton(albumInfo: albumInfo),
              ),
              const SizedBox(width: 8),
            ],
          ),
          Text(
            albumInfo.artistName,
            maxLines: 1,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '${NumberFormat.decimalPattern("en").format(albumInfo.listeners)} listeners',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          if (albumInfo.wiki.summary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Html(
              data: albumInfo.wiki.summary,
              style: {
                'body': Style(
                    margin: const EdgeInsets.fromLTRB(1, 2, 8, 4),
                    padding: const EdgeInsets.all(0),
                    fontSize: FontSize.em(0.93),
                    color: Colors.grey[600]),
                'a': Style(textDecoration: TextDecoration.none),
              },
              onLinkTap: (url, context, attributes, element) {
                if (url != null) {
                  launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}

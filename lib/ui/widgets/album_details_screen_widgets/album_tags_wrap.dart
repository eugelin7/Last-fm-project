import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../=models=/tag.dart';

class AlbumTagsWrap extends StatelessWidget {
  final List<Tag> tags;

  const AlbumTagsWrap({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: -2,
        children: tags.map((tag) => _AlbumTagButton(tag: tag)).toList(),
      ),
    );
  }
}

class _AlbumTagButton extends StatelessWidget {
  final Tag tag;

  const _AlbumTagButton({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () => {
        launchUrl(
          Uri.parse(tag.url),
          mode: LaunchMode.externalApplication,
        )
      },
      label: Text(tag.name),
      labelPadding: const EdgeInsets.fromLTRB(12, 1, 12, 2),
      backgroundColor: const Color(0xFFDEE4E7),
      labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey[700]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

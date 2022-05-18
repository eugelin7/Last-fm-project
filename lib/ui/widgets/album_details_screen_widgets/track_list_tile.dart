import 'package:flutter/material.dart';
import '../../../=models=/track.dart';

class TrackListTile extends StatelessWidget {
  final Track track;
  final int trackNumber;

  const TrackListTile(
      {Key? key, required this.track, required this.trackNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 40,
        child: Center(
          child: Text(
            trackNumber.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      title: Text(track.name),
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.only(right: 16),
      subtitle: Text(track.artistName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formattedDuration(Duration(seconds: track.duration)),
            style: TextStyle(fontSize: 14.5, color: Colors.blueGrey[600]),
          ),
          const SizedBox(width: 15),
        ],
      ),
      onTap: () => {},
    );
  }

  String _formattedDuration(Duration duration) {
    String _twoDigit(int number) => number >= 10 ? '$number' : '0$number';
    final minutes = _twoDigit(duration.inMinutes % 60);
    final seconds = _twoDigit(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }
}

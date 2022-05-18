import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'package:mylastfm/=models=/image.dart';
import 'package:mylastfm/=models=/tag.dart';
import 'package:mylastfm/=models=/track.dart';
import 'package:mylastfm/=models=/wiki.dart';

class AlbumInfoAdapter extends TypeAdapter<AlbumInfo> with EquatableMixin {
  @override
  final int typeId = 5;

  @override
  AlbumInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumInfo(
      name: fields[0] as String,
      mbid: fields[1] as String,
      artistName: fields[2] as String,
      listeners: fields[3] as int,
      url: fields[4] as String,
      playCount: fields[5] as int,
      tags: (fields[6] as List).cast<Tag>(),
      images: (fields[7] as List).cast<Image>(),
      tracks: (fields[8] as List).cast<Track>(),
      wiki: fields[9] as Wiki,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumInfo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mbid)
      ..writeByte(2)
      ..write(obj.artistName)
      ..writeByte(3)
      ..write(obj.listeners)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.playCount)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.images)
      ..writeByte(8)
      ..write(obj.tracks)
      ..writeByte(9)
      ..write(obj.wiki);
  }

  @override
  List<Object?> get props => [typeId];
}

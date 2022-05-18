import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mylastfm/=models=/track.dart';

class TrackAdapter extends TypeAdapter<Track> with EquatableMixin {
  @override
  final int typeId = 1;

  @override
  Track read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      duration: fields[0] as int,
      url: fields[1] as String,
      name: fields[2] as String,
      artistName: fields[3] as String,
      artistMbid: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.artistName)
      ..writeByte(4)
      ..write(obj.artistMbid);
  }

  @override
  List<Object?> get props => [typeId];
}

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mylastfm/=models=/album_info.dart';
import 'album_info_with_time_stamp.dart';

class AlbumInfoWithTimeStampAdapter extends TypeAdapter<AlbumInfoWithTimeStamp>
    with EquatableMixin {
  @override
  final int typeId = 6;

  @override
  AlbumInfoWithTimeStamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumInfoWithTimeStamp(
      timeStamp: fields[0] as String,
      albumInfo: fields[1] as AlbumInfo,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumInfoWithTimeStamp obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timeStamp)
      ..writeByte(1)
      ..write(obj.albumInfo);
  }

  @override
  List<Object?> get props => [typeId];
}

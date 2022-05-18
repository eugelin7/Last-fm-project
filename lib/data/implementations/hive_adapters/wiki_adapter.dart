import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mylastfm/=models=/wiki.dart';

class WikiAdapter extends TypeAdapter<Wiki> with EquatableMixin {
  @override
  final int typeId = 0;

  @override
  Wiki read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wiki(
      published: fields[0] as String,
      summary: fields[1] as String,
      content: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Wiki obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.published)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  List<Object?> get props => [typeId];
}

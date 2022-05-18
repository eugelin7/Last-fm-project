import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mylastfm/=models=/tag.dart';

class TagAdapter extends TypeAdapter<Tag> with EquatableMixin {
  @override
  final int typeId = 2;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      url: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  List<Object?> get props => [typeId];
}

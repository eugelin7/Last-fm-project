import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mylastfm/=models=/image.dart';

class ImageAdapter extends TypeAdapter<Image> with EquatableMixin {
  @override
  final int typeId = 3;

  @override
  Image read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Image(
      text: fields[0] as String,
      size: ImageSize.values[fields[1] as int],
    );
  }

  @override
  void write(BinaryWriter writer, Image obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(ImageSize.values.indexOf(obj.size));
  }

  @override
  List<Object?> get props => [typeId];
}

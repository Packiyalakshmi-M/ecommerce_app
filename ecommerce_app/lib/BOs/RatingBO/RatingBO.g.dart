// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RatingBO.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RatingBOAdapter extends TypeAdapter<RatingBO> {
  @override
  final int typeId = 2;

  @override
  RatingBO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingBO(
      rate: fields[0] as num,
      count: fields[1] as num,
    );
  }

  @override
  void write(BinaryWriter writer, RatingBO obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.rate)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingBOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

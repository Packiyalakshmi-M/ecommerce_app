// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductBO.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductBOAdapter extends TypeAdapter<ProductBO> {
  @override
  final int typeId = 1;

  @override
  ProductBO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductBO(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as num,
      description: fields[3] as String,
      category: fields[4] as String,
      image: fields[5] as String,
      rating: fields[6] as RatingBO,
    );
  }

  @override
  void write(BinaryWriter writer, ProductBO obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductBOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

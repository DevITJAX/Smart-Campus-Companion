// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteModelAdapter extends TypeAdapter<QuoteModel> {
  @override
  final int typeId = 2;

  @override
  QuoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteModel(
      id: fields[0] as String,
      content: fields[1] as String,
      author: fields[2] as String,
      fetchedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.fetchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

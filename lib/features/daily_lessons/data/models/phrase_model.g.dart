// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phrase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhraseModelAdapter extends TypeAdapter<PhraseModel> {
  @override
  final int typeId = 1;

  @override
  PhraseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhraseModel(
      english: fields[0] as String,
      persian: fields[1] as String,
      userId: fields[2] as String,
      aiProvider: fields[3] as AiProviderType,
      createdAt: fields[4] as DateTime,
      tokensUsed: fields[5] as int,
      requestId: fields[6] as String,
      isUsed: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PhraseModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.english)
      ..writeByte(1)
      ..write(obj.persian)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.aiProvider)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.tokensUsed)
      ..writeByte(6)
      ..write(obj.requestId)
      ..writeByte(7)
      ..write(obj.isUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhraseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

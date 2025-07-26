// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabularyModelAdapter extends TypeAdapter<VocabularyModel> {
  @override
  final int typeId = 0;

  @override
  VocabularyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabularyModel(
      english: fields[0] as String,
      persian: fields[1] as String,
      userId: fields[2] as String,
      aiProvider: fields[3] as AiProviderType,
      tokensUsed: fields[4] as int,
      requestId: fields[5] as String,
      createdAt: fields[6] as DateTime,
      isUsed: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VocabularyModel obj) {
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
      ..write(obj.tokensUsed)
      ..writeByte(5)
      ..write(obj.requestId)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearningRequestModelAdapter extends TypeAdapter<LearningRequestModel> {
  @override
  final int typeId = 3;

  @override
  LearningRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearningRequestModel(
      requestId: fields[0] as String,
      userId: fields[1] as String,
      userLevel: fields[2] as Level,
      focusAreas: (fields[3] as List).cast<String>(),
      aiProvider: fields[4] as AiProviderType,
      aiModel: fields[5] as String,
      totalTokensUsed: fields[6] as int,
      estimatedCost: fields[7] as double,
      requestTimestamp: fields[8] as DateTime,
      createdAt: fields[9] as DateTime,
      systemPrompt: fields[10] as String,
      userPrompt: fields[11] as String,
      status: fields[12] as RequestStatus,
      errorMessage: fields[13] as String?,
      vocabularies: (fields[14] as List).cast<VocabularyModel>(),
      phrases: (fields[15] as List).cast<PhraseModel>(),
      metadata: (fields[16] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, LearningRequestModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.requestId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userLevel)
      ..writeByte(3)
      ..write(obj.focusAreas)
      ..writeByte(4)
      ..write(obj.aiProvider)
      ..writeByte(5)
      ..write(obj.aiModel)
      ..writeByte(6)
      ..write(obj.totalTokensUsed)
      ..writeByte(7)
      ..write(obj.estimatedCost)
      ..writeByte(8)
      ..write(obj.requestTimestamp)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.systemPrompt)
      ..writeByte(11)
      ..write(obj.userPrompt)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.errorMessage)
      ..writeByte(14)
      ..write(obj.vocabularies)
      ..writeByte(15)
      ..write(obj.phrases)
      ..writeByte(16)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

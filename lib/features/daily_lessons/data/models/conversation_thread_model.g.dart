// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_thread_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationThreadModelAdapter
    extends TypeAdapter<ConversationThreadModel> {
  @override
  final int typeId = 5;

  @override
  ConversationThreadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationThreadModel(
      userId: fields[0] as String,
      threadId: fields[1] as String,
      messages: (fields[2] as List).cast<ConversationMessageModel>(),
      createdAt: fields[3] as DateTime,
      lastUpdatedAt: fields[4] as DateTime,
      context: fields[5] as String,
      userLevel: fields[6] as UserLevel,
      focusAreas: (fields[7] as List).cast<String>(),
      preferencesHash: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConversationThreadModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.threadId)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastUpdatedAt)
      ..writeByte(5)
      ..write(obj.context)
      ..writeByte(6)
      ..write(obj.userLevel)
      ..writeByte(7)
      ..write(obj.focusAreas)
      ..writeByte(8)
      ..write(obj.preferencesHash);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationThreadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConversationMessageModelAdapter
    extends TypeAdapter<ConversationMessageModel> {
  @override
  final int typeId = 6;

  @override
  ConversationMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationMessageModel(
      role: fields[0] as String,
      content: fields[1] as String,
      timestamp: fields[2] as DateTime,
      metadata: (fields[3] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ConversationMessageModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.role)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiProviderTypeAdapter extends TypeAdapter<AiProviderType> {
  @override
  final int typeId = 2;

  @override
  AiProviderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AiProviderType.openai;
      case 1:
        return AiProviderType.gemini;
      case 2:
        return AiProviderType.deepseek;
      default:
        return AiProviderType.openai;
    }
  }

  @override
  void write(BinaryWriter writer, AiProviderType obj) {
    switch (obj) {
      case AiProviderType.openai:
        writer.writeByte(0);
        break;
      case AiProviderType.gemini:
        writer.writeByte(1);
        break;
      case AiProviderType.deepseek:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiProviderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

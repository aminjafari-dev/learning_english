// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLevelAdapter extends TypeAdapter<UserLevel> {
  @override
  final int typeId = 5;

  @override
  UserLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserLevel.beginner;
      case 1:
        return UserLevel.elementary;
      case 2:
        return UserLevel.intermediate;
      case 3:
        return UserLevel.advanced;
      default:
        return UserLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, UserLevel obj) {
    switch (obj) {
      case UserLevel.beginner:
        writer.writeByte(0);
        break;
      case UserLevel.elementary:
        writer.writeByte(1);
        break;
      case UserLevel.intermediate:
        writer.writeByte(2);
        break;
      case UserLevel.advanced:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

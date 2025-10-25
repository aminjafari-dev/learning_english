// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_path_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearningPathModelAdapter extends TypeAdapter<LearningPathModel> {
  @override
  final int typeId = 10;

  @override
  LearningPathModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearningPathModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      level: fields[3] as String,
      focusAreas: (fields[4] as List).cast<String>(),
      subCategory: fields[5] as SubCategoryModel,
      courses: (fields[6] as List).cast<CourseModel>(),
      createdAt: fields[7] as String,
      updatedAt: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LearningPathModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.focusAreas)
      ..writeByte(5)
      ..write(obj.subCategory)
      ..writeByte(6)
      ..write(obj.courses)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningPathModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningPathModel _$LearningPathModelFromJson(Map<String, dynamic> json) =>
    LearningPathModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      level: json['level'] as String,
      focusAreas: (json['focusAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subCategory: SubCategoryModel.fromJson(
          json['subCategory'] as Map<String, dynamic>),
      courses: (json['courses'] as List<dynamic>)
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$LearningPathModelToJson(LearningPathModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'level': instance.level,
      'focusAreas': instance.focusAreas,
      'subCategory': instance.subCategory,
      'courses': instance.courses,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

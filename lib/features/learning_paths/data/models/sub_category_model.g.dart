// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubCategoryModelAdapter extends TypeAdapter<SubCategoryModel> {
  @override
  final int typeId = 4;

  @override
  SubCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubCategoryModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      difficulty: fields[3] as String,
      estimatedLessons: fields[4] as int,
      keyTopics: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubCategoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.estimatedLessons)
      ..writeByte(5)
      ..write(obj.keyTopics);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryModel _$SubCategoryModelFromJson(Map<String, dynamic> json) =>
    SubCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      estimatedLessons: (json['estimatedLessons'] as num).toInt(),
      keyTopics:
          (json['keyTopics'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SubCategoryModelToJson(SubCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'difficulty': instance.difficulty,
      'estimatedLessons': instance.estimatedLessons,
      'keyTopics': instance.keyTopics,
    };

SubCategoriesResponse _$SubCategoriesResponseFromJson(
        Map<String, dynamic> json) =>
    SubCategoriesResponse(
      subCategories: (json['subCategories'] as List<dynamic>)
          .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubCategoriesResponseToJson(
        SubCategoriesResponse instance) =>
    <String, dynamic>{
      'subCategories': instance.subCategories,
    };

/// User's English proficiency level

import 'package:hive/hive.dart';

part 'level_type.g.dart';

@HiveType(typeId: 5)
enum UserLevel {
  @HiveField(0)
  beginner,
  @HiveField(1)
  elementary,
  @HiveField(2)
  intermediate,
  @HiveField(3)
  advanced,
}

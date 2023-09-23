import 'package:hive/hive.dart';

part 'roles.g.dart';

@HiveType(typeId: 1)
enum Role {
  @HiveField(0)
  UNKNOWN,
  @HiveField(1)
  TENANT,
  @HiveField(2)
  DEVELOPER
}

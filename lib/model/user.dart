import 'package:hive/hive.dart';

part 'user.g.dart'; // The generated file

@HiveType(typeId: 0) // Assign a unique typeId
class User extends HiveObject {
  @HiveField(0) // Field index must be unique
  final String username;

  @HiveField(1)
  final String email;

  User({required this.username, required this.email});
}

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  String status;

  @HiveField(3)
  String image;

  @HiveField(4)
  String date;

  @HiveField(5)
  String time;

  Habit({
    required this.name,
    this.isCompleted = false,
    required this.status,
    required this.image,
    required this.date,
    required this.time,
  });
}
@HiveType(typeId: 2)
class CustomNote extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  CustomNote({
    required this.title,
    required this.content,

  });
}

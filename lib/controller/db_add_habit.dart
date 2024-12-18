import 'package:habit_tracker/model/user.dart';
import 'package:hive_flutter/adapters.dart';



Future<void> addHabit(Habit habit) async {
  final box = Hive.box<Habit>('habits'); // Access the habits box
  await box.add(habit); // Add the habit
}

List<Habit> getAllHabits() {
  final box = Hive.box<Habit>('habits'); // Access the habits box
  return box.values.toList(); // Get all habits as a list
}

Future<void> updateHabit(int index, Habit updatedHabit) async {
  final box = Hive.box<Habit>('habits'); // Access the habits box
  await box.putAt(index, updatedHabit); // Update habit at the given index
}
Future<void> deleteAllHabits() async {
  final box = Hive.box<Habit>('habits'); // Access the habits box
  await box.clear(); // Delete all habits
}




// controller/note_controller.dart
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/view/home.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Function to add a note
Future<void> addNote(CustomNote note) async {
  final box = Hive.box<CustomNote>('notes'); // Access the notes box
  await box.add(note); // Add the note to the box
}

// Function to get all notes
List<CustomNote> getAllNotes() {
  final box = Hive.box<CustomNote>('notes'); // Access the notes box
  return box.values.toList(); // Get all notes as a list
}

// Function to update a note
Future<void> updateNote(int index, CustomNote updatedNote) async {
  final box = Hive.box<CustomNote>('notes'); // Access the notes box
  await box.putAt(index, updatedNote); // Update the note at the given index
}

// Function to delete all notes
Future<void> deleteAllNotes() async {
  final box = Hive.box<CustomNote>('notes'); // Access the notes box
  await box.clear(); // Delete all notes
}

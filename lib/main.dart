import 'package:flutter/material.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/view/add.dart';
import 'package:habit_tracker/view/splash.dart';
import 'package:habit_tracker/view/task_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<User>('userBox');
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<CustomNote>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddScreen(),
    );
  }
}

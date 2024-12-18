import 'dart:async';

import 'package:habit_tracker/model/user.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> addUser(User user) async {
  var box = Hive.box<User>('users');

  await box.add(user);
  print('success');
}

Future<List<User>> getAllUsers() async {
  var box = Hive.box<User>('users');
  return box.values.toList();
}

Future<void> updateUser(User user) async {
  await user.save();
}
Future<void> deleteUser(String id) async {
  var box = Hive.box<User>('users');
  await box.delete(id);
}
Future<void> _saveLoggedInUserName(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('loggedInUserName', username);
}
Future<String?> getLoggedInUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('loggedInUserName');
}


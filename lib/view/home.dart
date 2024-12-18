import 'package:flutter/material.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/view/add.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import the add screen

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({
    super.key,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Habit> habitBox;

  @override
  void initState() {
    super.initState();
    // Initialize the Hive box
    habitBox = Hive.box<Habit>('habits');
  }

  void deleteHabit(int index) {
    habitBox.deleteAt(index); // Delete habit from the database
  }

  void navigateToAddScreen(Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>AddScreen( habit: habit), // Navigate with data
      ),
    ).then((_) {
      setState(() {}); // Refresh after returning
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/image 1 (1).png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: widget.username != ""
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Hello, \n${widget.username}!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Image.asset(
                        'assets/images/calender.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: habitBox.listenable(),
                builder: (context, Box<Habit> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'No habits found!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final habit = box.getAt(index);
                      if (habit == null) return const SizedBox.shrink();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ListTile(
                          // Display image in leading
                          leading: habit.image != 
                                  habit.image.isNotEmpty
                              ? Image.asset(
                                  habit.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                          title: Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(habit.name,),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteHabit(index);
                            },
                          ),
                          onTap: () {
                            navigateToAddScreen(habit); // Navigate on tap
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/view/add.dart';
import 'package:habit_tracker/view/task_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatefulWidget {
  final String username;
  final double taskCompletionPercentage;

  HomeScreen({
    super.key,
    required this.username,
    required this.taskCompletionPercentage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Habit> habitBox;
  late Box<CustomNote>
      noteBox; // Assuming there's a Note class for storing notes
  String? noteTitle;
  String? noteContent;

  @override
  void initState() {
    super.initState();
    // Initialize the Hive boxes
    habitBox = Hive.box<Habit>('habits');
    noteBox = Hive.box<CustomNote>('notes');
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      final habit = habitBox.getAt(index);
      if (habit != null) {
        habit.isCompleted = !habit.isCompleted;
        habitBox.putAt(index, habit);
      }
    });
  }

  void deleteHabit(int index) {
    habitBox.deleteAt(index);
  }

  void navigateToAddScreen(Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(
          habit: habit,
          username: widget.username,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void markAsSkipped(int index) {
    setState(() {
      final habit = habitBox.getAt(index);
      if (habit != null) {
        habit.status = 'skipped';
        habitBox.putAt(index, habit);
      }
    });
  }

  void _showTakeDayOffAlert(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Take a day off?'),
          content: const Text(
              'Mark this habit as "skipped" if you have an exact reason. The skipped status will not break your streak.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                markAsSkipped(index);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    final currentDate = DateFormat('dd - MMM - yyyy').format(DateTime.now());
    final greeting = getGreeting();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          // Wrap content in SingleChildScrollView
          child: Column(
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
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x99000000), // Transparent Black
              Color(0x66000000), // More Transparent Black
            ],
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
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
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
                    ]
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Hope you're enjoying your $greeting",
                style: const TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$currentDay\n$currentDate',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.taskCompletionPercentage.toStringAsFixed(1)}% done',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Completed Tasks',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Add Task',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(
                    ' or ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Create/Activate Routine',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: ValueListenableBuilder(
                  valueListenable: habitBox.listenable(),
                  builder: (context, Box<Habit> box, _) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text(
                          'What needs to be done today?',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
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
                          color: Colors.black,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                const SizedBox(width: 10),
                                Checkbox(
                                    value: habit.isCompleted,
                                    onChanged: (value) async {
                                      final isCompleted =
                                          await Navigator.push<bool>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskScreen(
                                                  habit: habit,
                                                ),
                                              ));
                                      if (isCompleted == true) {
                                        toggleTaskCompletion(index);
                                      }
                                    }),
                              ],
                            ),
                            title: Text(
                              habit.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: habit.status == 'skipped'
                                    ? Colors.grey
                                    : (habit.isCompleted
                                        ? Colors.white
                                        : Colors.white),
                              ),
                            ),
                            subtitle: Text(
                              habit.isCompleted
                                  ? 'Finished'
                                  : (habit.status == 'skipped'
                                      ? 'Skipped'
                                      : ''),
                            ),
                            trailing: PopupMenuButton<String>(
                              color: Colors.black,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  navigateToAddScreen(habit);
                                } else if (value == 'delete') {
                                  deleteHabit(index);
                                } else if (value == 'skip') {
                                  _showTakeDayOffAlert(index);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )),
                                const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )),
                                const PopupMenuItem(
                                    value: 'skip',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.local_cafe,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Take day off',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
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
      ),
    );
  }
}

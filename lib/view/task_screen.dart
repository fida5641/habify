import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/habit/analyse.dart';
import 'package:habit_tracker/habit/stop_watch.dart';

import 'package:habit_tracker/habit/timer_screen.dart';
import 'package:habit_tracker/model/user.dart'; // For Timer

class TaskScreen extends StatefulWidget {
  final Habit habit;
  const TaskScreen({super.key, required this.habit});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool iscompleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/image 1 (1).png'), // Your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
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
          ),
          Positioned(
            top: 40, // Adjust top margin
            left: 10, // Adjust left margin
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Task Image
                  Center(
                    child: Image.asset(
                      widget.habit.image, // Update your habit image path
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.habit.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomChip(label: getSegmentLabel(widget.habit.segment)),
                      const SizedBox(width: 10),
                      CustomChip(
                          label: widget.habit.days.length == 7
                              ? "Every Day"
                              : 'Mixed Days'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(
                          label: widget.habit.selectedOptions,
                          finished: 0,
                          target: widget.habit.selectedNumber),
                      InfoCard(
                          label: 'DAYS',
                          finished: 0,
                          target: widget.habit.target),
                      InfoCard(
                          label: 'CURRENT',
                          finished: 0,
                          target: 5,
                          isStreak: true),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Spacer(),
                  ToggledButton(label: 'Complete one Lap'),
                  const SizedBox(height: 16),
                  ToggledButton(label: 'Finish all Laps'),
                  const Spacer(),
                  const SizedBox(height: 20),
                  // // Toggle Button for Task Completed

                  const SizedBox(
                    height: 40,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Timer Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimerScreen(),
                              ));
                        },
                        child: Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, color: Colors.white),
                              SizedBox(height: 5),
                              Text("Timer",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),

                      // Analyse Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnalyseScreen(),
                              ));
                        },
                        child: Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.analytics, color: Colors.white),
                              SizedBox(height: 5),
                              Text("Analyse",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),

                      // Stopwatch Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StopwatchScreen(),
                              ));
                        },
                        child: Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer_off, color: Colors.white),
                              SizedBox(height: 5),
                              Text("Stopwatch",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToggledButton extends StatefulWidget {
  final String label;
  const ToggledButton({super.key, required this.label});

  @override
  State<ToggledButton> createState() => _ToggledButtonState();
}

class _ToggledButtonState extends State<ToggledButton> {
  bool isCompleted = false;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          isCompleted = details.primaryDelta! > 0;
        });
      },
      onTap: () {
        setState(() {
          isCompleted = !isCompleted;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 80,
        width: 350,
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey[300],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isCompleted ? 250 : 10,
              top: 5,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
  child: Text(
    isCompleted ? "Task Completed" : widget.label,  // <-- Use widget.label here
    style: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}


class CustomChip extends StatelessWidget {
  final String label;

  CustomChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey[800],
    );
  }
}

String getSegmentLabel(int segment) {
  switch (segment) {
    case 0:
      return 'Any Time';
    case 1:
      return 'Morning';
    case 2:
      return 'Afternoon';
    case 3:
      return 'Evening';
    case 4:
      return 'Night';
    default:
      return 'Any Time'; // Default to "Any Time" if the value is null
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final int finished;
  final int target;
  final bool isStreak;

  InfoCard({
    required this.label,
    required this.finished,
    required this.target,
    this.isStreak = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            'FINISHED',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            finished.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isStreak ? 'Best: $target' : 'Target: $target',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;

  CustomButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

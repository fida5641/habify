import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/habit/analyse.dart';
import 'package:habit_tracker/habit/stop_watch.dart';

import 'package:habit_tracker/habit/timer_screen.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/view/add.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart'; // For Timer

class TaskScreen extends StatefulWidget {
  final Habit habit;
  const TaskScreen({super.key, required this.habit});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool iscompleted = false;
  int _swipeCount = 0;

  void _updateSwipeCount(int count) {
    setState(() {
      _swipeCount = count;
      if (_swipeCount >= widget.habit.selectedNumber) {
        // Mark as completed when target is reached
        iscompleted = true;
      }
    });
  }

  void _updateIsCompleted() {
    setState(() {
      iscompleted = true;
    });
  }

  void _resetProgress() {
    setState(() {
      _swipeCount = 0;
      iscompleted = false;
    });
  }

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
            left: 30, // Adjust left margin
            child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),

          Positioned(
            top: 40, // Adjust the vertical position
            right: 10, // Adjust the horizontal position
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'reset') {
                  _resetProgress();
                } else if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddScreen(
                        habit: widget.habit,
                        username: '',
                      ), // Navigate to AddScreen for edit
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'reset',
                    child: Text('Reset'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                ];
              },
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
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
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomChip(
                            label: getSegmentLabel(widget.habit.segment)),
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
                            finished: _swipeCount,
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
                      height: 20,
                    ),
                    // const Spacer(),
                    iscompleted
                        ? Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        "Congratulations! You've successfully completed your daily habit.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 200,
                                      ),
                                      child: Lottie.asset(
                                        'assets/success.json', // Corrected the file path
                                        width: 150,
                                        height: 150,
                                        repeat: true, // Play animation once
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "See you tomorrow",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              ToggledButton(
                                label: 'Complete one Lap',
                                swipeCount: _swipeCount,
                                isCompleted: iscompleted,
                                onSwipeUpdate: _updateSwipeCount,
                                onCompleted: _updateIsCompleted,
                                maxSwipes: widget.habit.selectedNumber,
                              ),
                              const SizedBox(height: 10),
                              ToggledButton(
                                label: 'Finish all Laps',
                                swipeCount: widget.habit.selectedNumber,
                                isCompleted: iscompleted,
                                onCompleted: _updateIsCompleted,
                                onSwipeUpdate: _updateSwipeCount,
                                maxSwipes: widget.habit.selectedNumber,
                              ),
                            ],
                          ),
                    // const Spacer(),
                    // const SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }
}

class ToggledButton extends StatefulWidget {
  final String label;
  final int maxSwipes; // Target count
  int swipeCount;
  bool isCompleted;
  final Function(int) onSwipeUpdate; // Callback to update count
  final Function() onCompleted;

  ToggledButton({
    super.key,
    required this.label,
    required this.maxSwipes,
    required this.onSwipeUpdate,
    required this.swipeCount,
    required this.isCompleted,
    required this.onCompleted,
  });

  @override
  State<ToggledButton> createState() => _ToggledButtonState();
}

class _ToggledButtonState extends State<ToggledButton> {
  bool showTick = false; // Show tick for 3 seconds
  bool showSuccessMessage = false;

  // Show success message
  void _handleSuccess() {
    if (widget.swipeCount >= widget.maxSwipes) {
      setState(() {
        widget.onCompleted();
        showSuccessMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      text: widget.isCompleted
          ? 'Completed!'
          : '${widget.label} (${widget.swipeCount}/${widget.maxSwipes})',
      outerColor: widget.isCompleted ? Colors.green : Colors.grey[900],
      innerColor: widget.isCompleted ? Colors.green : Colors.deepOrange,
      onSubmit: () {
        if (!widget.isCompleted) {
          if (widget.label == 'Finish all Laps') {
            // ✅ Special handling for this button
            widget.onSwipeUpdate(
                widget.maxSwipes); // ✅ Instantly complete all laps
            setState(() {
              widget.swipeCount = widget.maxSwipes;
              showTick = true;
            });

            // Call the completion function
            _handleSuccess();
          } else {
            // Default behavior (increment one by one)
            if (widget.swipeCount < widget.maxSwipes) {
              widget.onSwipeUpdate(widget.swipeCount + 1);
              setState(() {
                showTick = true;
              });
            }
          }
        }
      },
      child: widget.isCompleted
          ? showTick
              ? const Icon(Icons.check, color: Colors.white, size: 40)
              : showSuccessMessage
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Congratulations! You've successfully completed your daily habit.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Lottie.asset(
                            'assets\success.json', // Ensure the file path is correct
                            width: 80,
                            height: 100,
                            repeat: false, // Play animation once
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "See you tomorrow",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()
          : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ]),
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
          const Text(
            'FINISHED',
            style: TextStyle(color: Colors.grey, fontSize: 14),
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

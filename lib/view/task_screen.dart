import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool iscompleted = false;

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
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: ),
                  // Timer Icon Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.timer_outlined,
                          size: 30, color: Colors.white54),
                      onPressed: () {
                        // Navigate to TimerScreen when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TimerScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Task Image
                  Center(
                    child: Image.asset(
                      'assets/images/drink water.png', // Update your habit image path
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Task Title
                  const Text(
                    'Task',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Habit Name
                  const Text(
                    'Habit name',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Meditation Text
                  const Text(
                    'Meditation',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Task Completed Section
                  const Text(
                    'Task completed',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Toggle Button for Task Completed
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      // Allow drag gestures to move the circle
                      setState(() {
                        iscompleted = details.primaryDelta! > 0;
                      });
                    },
                    onTap: () {
                      // Toggle button state on tap
                      setState(() {
                        iscompleted = !iscompleted;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 80, // Larger height
                      width: 350, // Larger width
                      decoration: BoxDecoration(
                        color: iscompleted
                            ? const Color(0xFF4CAF50) // Green when active
                            : Colors.grey[300], // Grey when inactive
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Stack(
                        children: [
                          // Task Completed Text
                          Positioned(
                            left: 30,
                            top: 25,
                            child: Text(
                              'Task completed',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: iscompleted
                                    ? Colors.white
                                    : Colors.black54, // Text color changes
                              ),
                            ),
                          ),
                          // Moving Circle
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            left: iscompleted ? 270 : 10, // Circle moves
                            top: 10,
                            child: Container(
                              width: 60, // Bigger circle
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // Stopwatch variables
  bool isStopwatchRunning = false;
  int stopwatchSeconds = 0;
  late Timer stopwatchTimer;

  // Countdown timer variables
  bool isCountdownRunning = false;
  int countdownSeconds = 0;
  late Timer countdownTimer;

  // Countdown input values
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  // For controlling which timer (stopwatch or countdown) is active
  bool isStopwatchSelected = true;

  @override
  void dispose() {
    stopwatchTimer.cancel();
    countdownTimer.cancel();
    super.dispose();
  }

  // Stopwatch start/stop logic
  void _toggleStopwatch() {
    if (isStopwatchRunning) {
      stopwatchTimer.cancel();
    } else {
      stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          stopwatchSeconds++;
        });
      });
    }
    setState(() {
      isStopwatchRunning = !isStopwatchRunning;
    });
  }

  // Countdown start/stop logic
  void _toggleCountdown() {
    if (isCountdownRunning) {
      countdownTimer.cancel();
    } else {
      countdownSeconds = (hours * 3600) + (minutes * 60) + seconds;
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdownSeconds > 0) {
          setState(() {
            countdownSeconds--;
          });
        } else {
          countdownTimer.cancel();
        }
      });
    }
    setState(() {
      isCountdownRunning = !isCountdownRunning;
    });
  }

  // Toggle between Stopwatch and Countdown
  void _toggleTimerSelection(bool isStopwatch) {
    setState(() {
      isStopwatchSelected = isStopwatch;
      stopwatchSeconds = 0; // Reset stopwatch
      countdownSeconds = 0; // Reset countdown
      hours = 0; // Reset countdown input
      minutes = 0;
      seconds = 0;
    });
  }

  // Format countdown time
  String formatTime(int seconds) {
    int hrs = (seconds ~/ 3600);
    int min = (seconds % 3600) ~/ 60;
    int sec = (seconds % 3600) % 60;
    return '$hrs:${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  // Reset Timer
  void _resetTimer() {
    setState(() {
      stopwatchSeconds = 0;
      countdownSeconds = 0;
      hours = 0;
      minutes = 0;
      seconds = 0;
      isStopwatchRunning = false;
      isCountdownRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Column with Stopwatch and Countdown options
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Stopwatch option with icon
                    GestureDetector(
                      onTap: () => _toggleTimerSelection(true),
                      child: Column(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 40,
                            color: isStopwatchSelected
                                ? Colors.green
                                : Colors.white,
                          ),
                          Text(
                            'Stopwatch',
                            style: TextStyle(
                              color: isStopwatchSelected
                                  ? Colors.green
                                  : Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    // Countdown option with icon
                    GestureDetector(
                      onTap: () => _toggleTimerSelection(false),
                      child: Column(
                        children: [
                          Icon(
                            Icons.timer_off,
                            size: 40,
                            color: !isStopwatchSelected
                                ? Colors.green
                                : Colors.white,
                          ),
                          Text(
                            'Countdown',
                            style: TextStyle(
                              color: !isStopwatchSelected
                                  ? Colors.green
                                  : Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
            // Show "Start", "Pause", and "Stop" buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start or Pause button
                ElevatedButton(
                  onPressed:
                      isStopwatchSelected ? _toggleStopwatch : _toggleCountdown,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    isStopwatchSelected
                        ? (isStopwatchRunning ? 'Pause' : 'Start')
                        : (isCountdownRunning ? 'Pause' : 'Start'),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 20),
                // Stop button
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.red, // Red color for stop button
                  ),
                  child: const Text(
                    'Stop',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Display the time (Stopwatch or Countdown)
            Text(
              isStopwatchSelected
                  ? formatTime(stopwatchSeconds)
                  : formatTime(countdownSeconds),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            // Show countdown timer with input fields for hours, minutes, and seconds
            if (!isStopwatchSelected)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour input field
                  _timeInputField('HH', (value) {
                    setState(() {
                      hours = int.tryParse(value) ?? 0;
                    });
                  }),
                  const SizedBox(width: 10),
                  const Text(':',
                      style: TextStyle(fontSize: 35, color: Colors.white)),
                  const SizedBox(width: 10),
                  // Minute input field
                  _timeInputField('MM', (value) {
                    setState(() {
                      minutes = int.tryParse(value) ?? 0;
                    });
                  }),
                  const SizedBox(width: 10),
                  const Text(':',
                      style: TextStyle(fontSize: 35, color: Colors.white)),
                  const SizedBox(width: 10),
                  // Second input field
                  _timeInputField('SS', (value) {
                    setState(() {
                      seconds = int.tryParse(value) ?? 0;
                    });
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Time input field for hour, minute, and second
  Widget _timeInputField(String label, Function(String) onChanged) {
    return SizedBox(
      width: 80,
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 25),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        onChanged: onChanged,
        maxLength: 2,
      ),
    );
  }
}

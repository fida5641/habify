import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late final Stopwatch stopwatch;
  late final Duration timerInterval;
  String formattedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    timerInterval = const Duration(milliseconds: 100); // For smoother updates
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      if (stopwatch.isRunning) {
        setState(() {
          formattedTime = formatTime(stopwatch.elapsedMilliseconds);
        });
      }
      await Future.delayed(timerInterval);
      return stopwatch.isRunning;
    });
  }

  String formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void startStopwatch() {
    stopwatch.start();
    startTimer();
  }

  void pauseStopwatch() {
    stopwatch.stop();
  }

  void resetStopwatch() {
    stopwatch.reset();
    setState(() {
      formattedTime = "00:00:00";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0038),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Spacer(),
            // Timer Circle
            Stack(
              alignment: Alignment.center,
              children: [
                // Circular progress
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: stopwatch.elapsedMilliseconds / 3600000.0,
                    strokeWidth: 8,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.purpleAccent,
                    ),
                    backgroundColor: Colors.purple.withOpacity(0.3),
                  ),
                ),
                // Timer text
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Start/Resume Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: stopwatch.isRunning ? pauseStopwatch : startStopwatch,
                    child: Text(
                      stopwatch.isRunning ? "Pause" : "Start",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  // Restart Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: resetStopwatch,
                    child: const Text(
                      "Restart",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

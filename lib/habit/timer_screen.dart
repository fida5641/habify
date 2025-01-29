import 'package:flutter/material.dart';

void main() {
  runApp(ScreenTimer());
}

class ScreenTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int duration = 5; // Default duration in minutes
  bool isRunning = false;
  late int currentTime;
  late final Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    currentTime = duration * 60; // Initial duration in seconds
    stopwatch = Stopwatch();
  }

  void startTimer() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
      isRunning = true;
      setState(() {});
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!stopwatch.isRunning) return false;
        setState(() {
          currentTime = duration * 60 - stopwatch.elapsed.inSeconds;
        });
        return currentTime > 0;
      }).then((_) {
        stopwatch.reset();
        isRunning = false;
        setState(() {});
      });
    }
  }

  void restartTimer() {
    stopwatch.reset();
    currentTime = duration * 60;
    isRunning = false;
    setState(() {});
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0038),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  // Handle back action
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
                    value: currentTime > 0
                        ? 1 - (currentTime / (duration * 60))
                        : 1, // Handle edge cases
                    strokeWidth: 8,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.purpleAccent,
                    ),
                    backgroundColor: Colors.purple.withOpacity(0.3),
                  ),
                ),
                // Timer text
                Text(
                  formatTime(currentTime),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Duration Picker
            const Text(
              "Set Duration",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<int>(
                value: duration,
                dropdownColor: const Color(0xFF1B0038),
                iconEnabledColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                underline: const SizedBox(),
                onChanged: (int? newValue) {
                  setState(() {
                    duration = newValue!;
                    restartTimer();
                  });
                },
                items: List.generate(100, (index) => index + 1)
                    .map<DropdownMenuItem<int>>(
                      (int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Spacer(),
            // Start and Restart Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Start Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: startTimer,
                    child: const Text(
                      "Start",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  // Restart Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: restartTimer,
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

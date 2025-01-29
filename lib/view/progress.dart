import 'package:flutter/material.dart';

class ProgresScreen extends StatelessWidget {
  ProgresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(

            decoration: const BoxDecoration(
              color: Colors.black
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'STATISTICS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        
                      ),
                ),
                const SizedBox(height: 20),

                // Stats Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statsCard("Total Running\nHabits", "11"),
                    statsCard("Completed\nHabits", "2"),
                  ],
                ),
                const SizedBox(height: 30),

                // Most Active Days
                Text(
                  'MOST ACTIVE DAYS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                mostActiveDaysGraph(),

                const SizedBox(height: 30),

                // Today Completion Rate
                Text(
                  'TODAY COMPLETION RATE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                completionRateBar(18.18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stats Card Widget
  Widget statsCard(String title, String value) {
    return Expanded(
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Most Active Days Graph
  Widget mostActiveDaysGraph() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.0),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      height: 250, // Adjusted for better visual size
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ["S", "M", "T", "W", "T", "F", "S"].map((day) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 18,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 18,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  day,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Completion Rate Bar
  Widget completionRateBar(double percentage) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[800],
                color: Colors.red,
                minHeight: 12,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "${percentage.toStringAsFixed(2)}%",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

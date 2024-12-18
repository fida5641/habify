import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgresScreen extends StatelessWidget {
  const ProgresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 0.56;  // This value can be dynamic, representing the progress

    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Stack(
                children: [
                  // Background image container with a semi-transparent overlay to make content visible
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image 1 (1).png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
               const Center(
                 child: Column(
                   children: [
                     Text(
                                    "Progress of Habit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                   ],
                 ),
               ),
                  // Center widget with CircularPercentIndicator and text inside
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CircularPercentIndicator showing the progress
                        CircularPercentIndicator(
                          radius: 80.0,  // Increased radius for a bigger circle
                          lineWidth: 15.0,  // Adjusted line width
                          animation: true,
                          animationDuration: 1200, // 1.2 seconds for animation
                          percent: progress, // Dynamic progress (0.56 for 56%)
                          center: Text(
                            "${(progress * 100).toStringAsFixed(0)}%", // Display percentage
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          footer: const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.green, // Color of the progress circle
                          backgroundColor: Colors.grey[300]!, // Background color of the circle
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${(100 - (progress * 100)).toStringAsFixed(0)}% of habit is not completed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
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

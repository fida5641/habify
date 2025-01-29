import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import TableCalendar

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  // Define variables for the calendar's focused day and selected day
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // The AspectRatio widget ensures the container maintains a 1:1 ratio
          AspectRatio(
            aspectRatio: 1, // The aspect ratio of 1:1 (Width = Height)
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Stack(
                children: [
                  // Background image container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image 1 (1).png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    // To prevent overflow, use a ScrollView
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView( // Wrap with a SingleChildScrollView
                        child: TableCalendar(
                          focusedDay: _focusedDay,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2025, 12, 31),
                          selectedDayPredicate: (day) {
                            // Return true if the selected day is the same as the current day
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay; // Update the focused day
                            });
                          },
                        ),
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

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ),
                  // Calendar widget inside a constrained space
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300, // You can adjust the width here
                        height: 300, // You can adjust the height here
                        child: TableCalendar(
                          firstDay: DateTime.utc(2023, 1, 1),
                          lastDay: DateTime.utc(2024, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            outsideDaysVisible: false,
                            // Adjust the text size here if you want
                            // textStyle: TextStyle(
                            //   fontSize: 12, // Reduce font size for the dates
                            //   color: Colors.white,
                            // ),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontSize: 14, // Reduce the header font size
                            ),
                          ),
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

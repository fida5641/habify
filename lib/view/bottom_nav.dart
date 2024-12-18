import 'package:flutter/material.dart';
import 'package:habit_tracker/view/add.dart';
import 'package:habit_tracker/view/chart.dart';
import 'package:habit_tracker/view/home.dart';
import 'package:habit_tracker/view/profile.dart';
import 'package:habit_tracker/view/progress.dart'; // Assuming you have this screen

class BottomNav extends StatefulWidget {
  final String username;

  const BottomNav({super.key, required this.username});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(username: widget.username ), 
      const ChartScreen(),  
      const AddScreen(),    
      const ProgresScreen(), 
       ProfileScreen(username: widget.username) 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(2); // Switch to AddScreen
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF29068D),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              color: _selectedIndex == 0
                  ? const Color.fromARGB(255, 12, 12, 129)
                  : const Color.fromARGB(255, 43, 42, 42),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_sharp),
              color: _selectedIndex == 1
                  ? const Color.fromARGB(255, 12, 12, 129)
                  : const Color.fromARGB(255, 43, 42, 42),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40), // Space for the FAB
            IconButton(
              icon: const Icon(Icons.graphic_eq),
              color: _selectedIndex == 3
                  ? const Color.fromARGB(255, 12, 12, 129)
                  : const Color.fromARGB(255, 43, 42, 42),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: _selectedIndex == 4
                  ? const Color.fromARGB(255, 12, 12, 129)
                  : const Color.fromARGB(255, 43, 42, 42),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}

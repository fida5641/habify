import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/controller/db_note_controller.dart';
import 'package:habit_tracker/model/user.dart';
import 'package:habit_tracker/view/add.dart';
import 'package:habit_tracker/view/chart.dart';
import 'package:habit_tracker/view/home.dart';
import 'package:habit_tracker/view/profile.dart';
import 'package:habit_tracker/view/progress.dart';

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
      HomeScreen(username: widget.username, taskCompletionPercentage: 0.0),
      const ChartScreen(),
      AddScreen(username: widget.username),
      ProgresScreen(),
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
        onPressed: _showAddOptions,
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

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.task),
                title: const Text('Add Task'),
                onTap: () {
                  setState(() {
                    _selectedIndex = 2; // Switch to AddScreen
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text('Add Note'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddNotePopup();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddNotePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String content = '';
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  content = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                CustomNote note = CustomNote(title: title, content: content);
                await addNote(note);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

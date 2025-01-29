import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/controller/db_add_habit.dart';
import 'package:habit_tracker/view/bottom_nav.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/model/user.dart';

class AddScreen extends StatefulWidget {
  final Habit? habit;
  final String username;
  const AddScreen({super.key, this.habit, required this.username});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> selectedDays = []; // To keep track of selected days
  final List<int> numberOptions = List.generate(100, (index) => index + 1);
  int selectedNumber = 1;
  String selectedOptions = 'Hours';
  int? groupValue = 0;

  // Options for the unit column
  final List<String> options = [
    'Hours',
    'Minutes',
    'Pages',
    'Liter',
    'Meter',
    'Cups'
  ];

  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _otherHabitController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  final List<Map<String, String>> habitOptions = [
    {'name': 'Wakeup', 'image': 'assets/images/wakeup.png'},
    {'name': 'Drink Water', 'image': 'assets/images/drink water.png'},
    {'name': 'Self Care', 'image': 'assets/images/selfcare.png'},
    {'name': 'Morning Routine', 'image': 'assets/images/morning routine.png'},
    {'name': 'To-Do Planning', 'image': 'assets/images/to_do plan.png'},
    {'name': 'Workout', 'image': 'assets/images/workout.png'},
    {'name': 'Reading', 'image': 'assets/images/reading.png'},
    {'name': 'Socializing', 'image': 'assets/images/socializing.png'},
    {'name': 'Screen Time', 'image': 'assets/images/limit screen time.png'},
    {'name': 'Sleep', 'image': 'assets/images/sleep.png'},
    {'name': 'Other', 'image': ''},
  ];

  String? selectedHabit;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     setState(() {});
  //   }
  // }

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {});
  //   }
  // }

  Future<void> _saveHabit() async {
    if (_habitNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }
    final int? targetValue = int.tryParse(_targetController.text);
    if (targetValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid target number.')),
      );
      return;
    }
    final habit = Habit(
      name: _habitNameController.text,
      image: habitOptions.firstWhere(
        (habit) => habit['name'] == selectedHabit,
        orElse: () => {'image': ''},
      )['image']!,
      target: targetValue,
      status: '',
      days: selectedDays,
      segment: groupValue ?? 0,
      selectedNumber: selectedNumber,
      selectedOptions: selectedOptions,
    );
    print("here is reached with habit class $habit");

    await addHabit(habit);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => BottomNav(username: widget.username),
      ),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit saved successfully!')),
    );

    setState(() {
      _habitNameController.clear();
      _otherHabitController.clear();
      _targetController.clear();
      selectedDays.clear();
    });
  }

  Future<void> _editHabit() async {
    if (widget.habit == null) return;

    final int? targetValue = int.tryParse(_targetController.text);
  if (targetValue == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid target number.')),
    );
    return;
  }

    final updatedHabit = Habit(
      name: _habitNameController.text,
      image: habitOptions.firstWhere(
        (habit) => habit['name'] == selectedHabit,
        orElse: () => {'image': ''},
      )['image']!,
      target: targetValue,
      status: '',
      days: selectedDays,
      segment: groupValue ?? 0,
      selectedNumber: selectedNumber,
      selectedOptions: selectedOptions,
    );

    final box = await Hive.openBox<Habit>('habits');
    await box.put(widget.habit!.key, updatedHabit);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit updated successfully!')),
    );

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        body: Stack(children: [
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
      ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start your Habit',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 10),
            Form(
              key: formKey,
              child: DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null) {
                    return "pleaseekknknn";
                  } else {
                    return null;
                  }
                },
                value: selectedHabit,
                hint: const Text(
                  'Select Habit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedHabit = value;
                    if (value != 'Other') {
                      _habitNameController.text = value ?? '';
                      _otherHabitController.clear();
                    }
                  });
                },
                items: habitOptions.map((habit) {
                  return DropdownMenuItem<String>(
                    value: habit['name'],
                    child: Row(
                      children: [
                        if (habit['image'] != '')
                          Image.asset(
                            habit['image']!,
                            width: 30,
                            height: 30,
                          ),
                        if (habit['image'] != '') const SizedBox(width: 10),
                        Text(habit['name']!),
                      ],
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  fillColor: Colors.white,
                  hintText: 'Select Habit',
                ),
              ),
            ),
            if (selectedHabit == 'Other')
              Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _otherHabitController,
                    decoration: const InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      fillColor: Colors.white,
                      hintText: 'Enter Habit Name',
                    ),
                    onChanged: (value) {
                      _habitNameController.text = value;
                    },
                  ),
                ],
              ),
            SizedBox(height: 20),
             TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Target Days",
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Select Days',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Days Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var day in daysOfWeek)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedDays.contains(day)) {
                          selectedDays.remove(day);
                        } else {
                          selectedDays.add(day);
                          print(selectedDays);
                        }
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: selectedDays.contains(day)
                              ? const Color(0xFF29068D)
                              : Colors.white10,
                          child: Text(
                            day[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          day,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              // padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set Counter',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                  // const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First Picker: Numbers
                      SizedBox(
                        height: 100, // Adjust height of the picker
                        width: 100, // Adjust width of the picker
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedNumber - 1),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedNumber = index + 1;
                            });
                          },
                          children: List.generate(
                            100,
                            (index) => Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Second Picker: Options
                      SizedBox(
                        height: 100, // Adjust height of the picker
                        width: 120, // Adjust width of the picker
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                              initialItem: options.indexOf(selectedOptions)),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedOptions = options[index];
                            });
                          },
                          children: options
                              .map(
                                (option) => Center(
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Per Day Text
                      const Text(
                        'per day',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Do it at',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                  const SizedBox(
                      height: 15), // Space between text and segmented control
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      alignment: Alignment.center,
                      child: CupertinoSlidingSegmentedControl<int>(
                        thumbColor: const Color(0xFF29068D),
                        groupValue: groupValue,
                        children: {
                          0: buildSegment('Any Time'),
                          1: buildSegment('Morning'),
                          2: buildSegment('Afternoon'),
                          3: buildSegment('Evening'),
                          4: buildSegment('Night'),
                          // Add more segments if needed
                        },
                        onValueChanged: (int? newValue) {
                          setState(() {
                            groupValue = newValue!;
                          });
                          saveSegment(newValue!);
                          print('Selected Segment: $groupValue');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  log('submitted${formKey.currentState?.validate()}');
                  if (formKey.currentState?.validate() == true) {
                    log("test 1 passed");
                    if (widget.habit != null) {
                      log("test2 ");
                      await _editHabit();
                    } else {
                      await _saveHabit();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                  backgroundColor: const Color(0xFF29068D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  widget.habit != null ? 'Update' : 'Submit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ])
    ]));
  }

  void saveSegment(int newValue) async {
    if (widget.habit != null) {
      // Update the habit object and save
      widget.habit!.segment = newValue;
      await widget.habit!.save(); // Save the updated habit in the Hive box
      print('Segment saved: $newValue');
    } else {
      print('No habit to update');
    }
  }

  // Helper function to build each segment with no text wrapping
  Widget buildSegment(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white // Set text color to black for visibility
              ),
          textAlign: TextAlign.center, // Center text in the segment
          overflow: TextOverflow.ellipsis, // Ensure text does
          maxLines: 1, // Prevent the text from wrapping to the next line
        ),
      ),
    );
  }
}

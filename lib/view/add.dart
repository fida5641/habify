import 'package:flutter/material.dart';
import 'package:habit_tracker/controller/db_add_habit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/model/user.dart'; 

class AddScreen extends StatefulWidget {
  final Habit? habit; 
  const AddScreen({super.key, this.habit});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _otherHabitController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _habitNameController.text = widget.habit!.name;
      _dateController.text = widget.habit!.date;
      _timeController.text = widget.habit!.time;
      selectedHabit = widget.habit!.name;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _saveHabit() async {
    if (_habitNameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    final habit = Habit(
      name: _habitNameController.text,
      image: habitOptions.firstWhere(
        (habit) => habit['name'] == selectedHabit,
        orElse: () => {'image': ''},
      )['image']!,
      date: _dateController.text,
      time: _timeController.text,
    );

    await addHabit(habit);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit saved successfully!')),
    );

    _habitNameController.clear();
    _dateController.clear();
    _timeController.clear();
    _otherHabitController.clear();
  }

  Future<void> _editHabit() async {
    if (widget.habit == null) return;

    final updatedHabit = Habit(
      name: _habitNameController.text,
      image: habitOptions.firstWhere(
        (habit) => habit['name'] == selectedHabit,
        orElse: () => {'image': ''},
      )['image']!,
      date: _dateController.text,
      time: _timeController.text,
    );

    final box = await Hive.openBox<Habit>('habits');
    await box.put(widget.habit!.key, updatedHabit);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit updated successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/image 1 (1).png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Start a New Habit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),),
                      ),
                      SizedBox(height: 50,),
                      DropdownButtonFormField<String>(
                        value: selectedHabit,
                        hint: const Text(
                          'Select Habit',
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
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
                                if (habit['image'] != '')
                                  const SizedBox(width: 10),
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
                      if (selectedHabit == 'Other')
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _otherHabitController,
                              decoration: const InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
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
                      const SizedBox(height: 15),
                      const Text('Set Date & Time',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              decoration: const InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                fillColor: Colors.white,
                                hintText: 'Select Date',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              onTap: () => _selectTime(context),
                              decoration: const InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                fillColor: Colors.white,
                                hintText: 'Select Time',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState?.validate() == true) {
                              if (widget.habit != null) {
                                await _editHabit(); 
                              } else {
                                await _saveHabit(); 
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

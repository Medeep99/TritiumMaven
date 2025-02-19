import 'package:flutter/material.dart';
import 'package:maven/feature/template/bloc/template/workout_template_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  int _currentGoal = 3; // Default goal if not set

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  // Load the saved goal from SharedPreferences
  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentGoal = prefs.getInt('workout_goal') ?? _currentGoal;
      _goalController.text = _currentGoal.toString();
    });
  }

  // Save the updated goal to SharedPreferences
  Future<void> _saveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final int? newGoal = int.tryParse(_goalController.text);

    if (newGoal != null && newGoal > 0 && newGoal <= 7) {
      await prefs.setInt('workout_goal', newGoal);
      setState(() {
        _currentGoal = newGoal;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout goal updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number (1-7).')),
      );
    }

    // Mock routine and exercise list data
    generateWorkoutTemplate(context, newGoal ?? 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Goal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Workout Goal: $_currentGoal days per week',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter new goal (1-7 days)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Save Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

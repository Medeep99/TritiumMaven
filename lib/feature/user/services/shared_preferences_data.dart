import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static const String _goalKey = 'weekly_goal';

  // Save the goal to SharedPreferences
  static Future<void> setGoal(int goal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalKey, goal);
  }

  // Get the goal from SharedPreferences
  static Future<int?> getGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goalKey);
  }

  // Remove the goal (optional)
  static Future<void> removeGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_goalKey);
  }
}
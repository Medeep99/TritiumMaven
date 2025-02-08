import 'package:maven/database/table/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {

  static const _goalKey = 'sessionWeeklyGoal';
  static const _volumeKey = 'sessionVolume';

  // Fetch the goal value from SharedPreferences
  Future<int> getSessionWeeklyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goalKey) ?? 0; // Default to 0 if not set
  }

  // Set the goal value in SharedPreferences
  Future<void> setSessionWeeklyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_goalKey, goal);
  }
  
}
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../ml_model/calorie_record.dart';

class CalorieStorageService {
  static const String _storageKey = 'calorie_history';
  final SharedPreferences _prefs;

  CalorieStorageService(this._prefs);

  // Save calorie records
  Future<void> saveCalorieRecords(List<CalorieRecord> records) async {
    final List<Map<String, dynamic>> jsonList = 
        records.map((record) => record.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  // Load calorie records
  List<CalorieRecord> loadCalorieRecords() {
    final String? jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => CalorieRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading calorie records: $e');
      return [];
    }
  }

  // Clear all records
  Future<void> clearCalorieRecords() async {
    await _prefs.remove(_storageKey);
  }
}
import 'package:floor/floor.dart';
import 'package:maven/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maven/feature/ml_model/calorie_manager.dart';

Future<void> deleteMyDatabase() async {
  try {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tritium_database.db');
    await deleteDatabase(path); // Deletes the database
    print("Database deleted successfully.");
  } catch (e) {
    print("Error deleting database: $e");
  }
}

Future<void> clearSharedPreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all key-value pairs
    print("SharedPreferences cleared.");
  } catch (e) {
    print("Error clearing SharedPreferences: $e");
  }
}

Future<void> clearCache() async {
  try {
    await DefaultCacheManager().emptyCache(); // Clears the image cache
    print("Cache cleared.");
  } catch (e) {
    print("Error clearing cache: $e");
  }
}

Future<void> clearAppData() async {
  await deleteMyDatabase(); // Clear the database
  await clearSharedPreferences(); // Clear SharedPreferences
  await clearCache(); // Clear cache
}

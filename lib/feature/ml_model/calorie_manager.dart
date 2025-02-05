import '../ml_model/calorie_record.dart';
import 'calorie_storage_service.dart';

class CalorieManager {
  final CalorieStorageService _storageService;
  List<CalorieRecord> _calorieHistory = [];
  static const int maxRecords = 10;

  CalorieManager(this._storageService) {
    _loadHistory();
  }

  // Load saved history
  void _loadHistory() {
    _calorieHistory = _storageService.loadCalorieRecords();
    _maintainHistoryLimit();
    
  }

  // Add new record
  Future<void> addCalorieRecord(double calories) async {
    final record = CalorieRecord(
      calories: calories,
      timestamp: DateTime.now(),
      
    );
    
    _calorieHistory.add(record);
    _maintainHistoryLimit();
    await _storageService.saveCalorieRecords(_calorieHistory);
  }

  // Keep only last 5 records
  void _maintainHistoryLimit() {
    if (_calorieHistory.length > maxRecords) {
      _calorieHistory = _calorieHistory.sublist(_calorieHistory.length - maxRecords);
    }
  }

  // Get all records
  List<CalorieRecord> getCalorieHistory() {
    return List.unmodifiable(_calorieHistory);
  }
  

  // Clear all records
  Future<void> clearHistory() async {
    _calorieHistory.clear();
    await _storageService.clearCalorieRecords();
  }
}
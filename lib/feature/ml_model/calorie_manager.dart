import 'dart:async';

import 'package:maven/database/table/user.dart';
import 'package:maven/feature/ml_model/calorie_burnt.dart';

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
    
    
    Future<double?> predictCalories(User user, double workoutDuration, double volume) async {
    print (volume);
    if(volume >0){
    double hr_workout = calculateHr(user.age.toDouble(), workoutDuration , volume, user.gender.toString());
    final inputData = {
      'Gender': user.gender.toApiString(),
      'Age': user.age.toDouble(),
      'Height': user.height.toDouble(),
      'Weight': user.weight.toDouble(),
      'Duration': (workoutDuration).toDouble(),
      'Heart_Rate': (hr_workout).toDouble(),
      'Body_Temp': 38.5,
    };
      print('Sending data to API: $inputData');
    try {
      String prediction = await getPrediction(inputData).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Prediction timeout'),
      );
      double? calorieValue = double.tryParse(prediction);
      print (calorieValue);

      if(calorieValue != null){
      print('this is predicted calorie $calorieValue');
      
      double calorie = double.tryParse(prediction)??0;
      await addCalorieRecord(calorie);
      print ('Calories saved succesfully');
      return (calorie);
      }
    } catch (e) {
      print('Prediction error: $e');
      print ('Error saving calories');
      return null;
    }
    
    }
    else{
    await addCalorieRecord(0.0);
    return 0.0;
    }
    }
    // Get the latest calorie record
  double getLatestCalorieRecord() {
    if (_calorieHistory.isNotEmpty) {
      return _calorieHistory.last as double;
    }
    return 0.0; // Return null if there are no records
  }
  double calculateHr(double age, double workoutDuration, double workoutVolume, String gender) {
   double W_ref = (gender == 'male') ? 3.5 : 2.5;
   double HR_rest = 70.0;
   double HR_max = 208 - (0.7 * age);
   double HRR = HR_max - HR_rest;

   double W_actual = workoutVolume / workoutDuration;
   double W_max = W_ref * (1 - (0.035 * (age - 25.0)));
   
   if (W_max <= 0) {
      print("Warning: W_max is too low, adjusting to 1.0 to prevent division error.");
      W_max = 1.0;
   }

   double I = W_actual / W_max;
   I = I.clamp(0, 1); // Ensure intensity is within a realistic range

   double HR_workout = HR_rest + I * HRR;

   print("W_actual: $W_actual, W_max: $W_max, I: $I, HR_workout: $HR_workout");
   return HR_workout;
}


}
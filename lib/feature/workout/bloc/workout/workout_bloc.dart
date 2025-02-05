import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/feature/ml_model/calorie_burnt.dart';
import 'package:maven/feature/ml_model/calorie_manager.dart';
import 'package:maven/feature/template/template.dart';

import '../../../../database/database.dart';
import '../../../exercise/exercise.dart';
import '../../../routine/service/service.dart';
import '../../model/workout.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc({
    required this.routineService,
    required this.databaseService,
    required this.calorieManager,
   

    
  }) : super(const WorkoutState()) {
    on<WorkoutInitialize>(_initialize);
    on<WorkoutStart>(_start);
    on<WorkoutStateEmpty>(_empty);
    on<WorkoutFinish>(_finish);
    on<WorkoutDelete>(_delete);
  }

  final RoutineService routineService;
  final DatabaseService databaseService;
  final CalorieManager calorieManager;
  
 

  Future<void> _initialize(WorkoutInitialize event, emit) async {
    Workout? workout = await routineService.getWorkout();

    emit(state.copyWith(
      status: workout == null ? WorkoutStatus.none : WorkoutStatus.active,
      workout: workout,
    ));
  }

  Future<void> _start(WorkoutStart event, Emitter<WorkoutState> emit) async {
    emit(state.copyWith(
      status: WorkoutStatus.loading,
    ));
    
    Workout? workout = await routineService.startTemplate(event.template);
  
    emit(state.copyWith(
      status: WorkoutStatus.active,
      workout: workout,
    ));
  }

  Future<void> _empty(WorkoutStateEmpty event, Emitter<WorkoutState> emit) async {
    emit(state.copyWith(
      status: WorkoutStatus.loading,
    ));

    Workout workout = await routineService.addWorkout(Routine(
      name: 'Empty Workout',
      note: '',
      timestamp: DateTime.now(),
      type: RoutineType.workout,
    ));

    emit(state.copyWith(
      status: WorkoutStatus.active,
      workout: workout,
    ));
  }

  // Future<void> _finish(WorkoutFinish event, Emitter<WorkoutState> emit) async {
  //   final User currentUser = await databaseService.userDao.get() as User;
  //    // Send data for prediction after workout finishes
  // final Map<String, dynamic> inputData = {
  //   // 'Gender': [currentUser.gender.toString()], // You should replace this with actual user gender
  //   'Gender': ['male'],
  //   'Age': [currentUser.age.toDouble()], // Replace with actual user age
  //   'Height': [currentUser.height.toDouble()], // Replace with actual user height
  //   'Weight': [currentUser.weight.toDouble()], // Replace with actual user weight
  //   'Duration': [((event.workout.data.timeElapsed.toSeconds())/60.0).toDouble()], // Use the actual workout duration
  //   'Heart_Rate': [180.0], // Default heart rate or capture from the user
  //   'Body_Temp': [39.8], // Default body temp or capture from the user
  // };

  // // Call the prediction function (you may need to adapt it to your actual setup)
  // String prediction = await getPrediction(inputData);

  // // Optionally, use the prediction (e.g., log it, update UI, etc.)
  // print('Prediction is: $prediction');
    
  //   await routineService.deleteRoutine(event.workout.routine);
    

  //   emit(state.copyWith(
  //     status: WorkoutStatus.none,
  //   ));
  // }
//  Future<void> _finish(WorkoutFinish event, Emitter<WorkoutState> emit) async {
//   try {
//     final User currentUser = await databaseService.userDao.get() as User;

//     // Convert Gender enum to string before sending to API
//     final String genderString = currentUser.gender.toApiString();

//     // Prepare input data for prediction
//     final Map<String, dynamic> inputData = {
//       'Gender': genderString, // Now sending string instead of enum
//       'Age': currentUser.age.toDouble(),
//       'Height': currentUser.height.toDouble(),
//       'Weight': currentUser.weight.toDouble(),
//       'Duration': ((event.workout.data.timeElapsed.toSeconds()) / 60.0).toDouble(),
//       'Heart_Rate': 180.0,
//       'Body_Temp': 39.8,
//     };

//     print('Sending data to API: $inputData'); // Debug print

//     String prediction = await getPrediction(inputData);
    
//     if (prediction.startsWith('Error')) {
//       print('Prediction error: $prediction');
//       emit(state.copyWith(
//         status: WorkoutStatus.error,
        
//       )
      
//       );
//       print ('Error : $prediction()');
//     } else {
//       print('Calories burned: $prediction');
//       emit(state.copyWith(
//         status: WorkoutStatus.none,
//       ));
//     }

//     await routineService.deleteRoutine(event.workout.routine);

//   } catch (e) {
//     print('Error in _finish: $e');
//     emit(state.copyWith(
//       status: WorkoutStatus.error,
      
//     ));
//     print ('Error : $e.$toString()');
//   }
// }
Future<void> _finish(WorkoutFinish event, Emitter<WorkoutState> emit) async {
  try {
    final User currentUser = await databaseService.userDao.get() as User;

    // Convert Gender enum to string before sending to API
    final String genderString = currentUser.gender.toApiString();

    // Prepare input data for prediction
    final Map<String, dynamic> inputData = {
      'Gender': genderString,
      'Age': currentUser.age.toDouble(),
      'Height': currentUser.height.toDouble(),
      'Weight': currentUser.weight.toDouble(),
      'Duration': ((event.workout.data.timeElapsed.toSeconds()) / 60.0).toDouble(),
      'Heart_Rate': 180.0,
      'Body_Temp': 39.8,
    };

    print('Sending data to API: $inputData');

    // String prediction = await getPrediction(inputData);
    String prediction = await getPrediction(inputData).timeout(
      const Duration(seconds: 5),
      onTimeout: () => 'Error: Prediction timeout',
    );
    
    if (prediction.startsWith('Error')) {
      print('Prediction error: $prediction');
      emit(state.copyWith(
        status: WorkoutStatus.error,
      ));
      print ('Error : $prediction()');
    } else {
      print('Calories burned: $prediction');
      // Add this block to save calories
      try {
        double calories = double.parse(prediction);
        await calorieManager.addCalorieRecord(calories);  // Add this line
        print('Calories saved successfully');
      } catch (e) {
        print('Error saving calories: $e');
      }
      
      emit(state.copyWith(
        status: WorkoutStatus.none,
      ));
    }

    await routineService.deleteRoutine(event.workout.routine);

  } catch (e) {
    print('Error in _finish: $e');
    emit(state.copyWith(
      status: WorkoutStatus.error,
    ));
    print ('Error : $e.$toString()');
  }
}


  Future<void> _delete(WorkoutDelete event, Emitter<WorkoutState> emit) async {
    await routineService.deleteRoutine(state.workout!.routine);

    emit(state.copyWith(
      status: WorkoutStatus.none,
    ));
  }

 
}

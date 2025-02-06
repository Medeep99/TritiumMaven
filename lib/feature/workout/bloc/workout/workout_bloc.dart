import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/common/common.dart';
import 'package:maven/feature/ml_model/calorie_burnt.dart';
import 'package:maven/feature/ml_model/calorie_manager.dart';
import 'package:maven/feature/session/model/session.dart';
import 'package:maven/feature/settings/widget/settings_inherited_widget.dart';
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

Future<void> _finish(WorkoutFinish event, Emitter<WorkoutState> emit) async {
  try {
    final User currentUser = await databaseService.userDao.get() as User;

    // Convert Gender enum to string before sending to API
    final String genderString = currentUser.gender.toApiString();
    double min = event.workout.data.timeElapsed.toSeconds()/60.0;
    double hr=0.0;
    double bt = 0.0;
    if (min>=10){
      hr = 140;
      bt= 37.0;
    }
    else if (min>20.0 && min <=45.0) {
      hr = 160;
       bt= 38.0;
    }
    else if (min >=45.0 && min<=60.0){
      hr = 180;
       bt= 38.0;
    }
    else if (min >60.0 ){
      hr =200;
       bt= 39.0;
    }
    else if (min <10.0){
      hr =100;
       bt= 39.0;
    }
    // Prepare input data for prediction
    final Map<String, dynamic> inputData = {
      'Gender': genderString,
      'Age': currentUser.age.toDouble(),
      'Height': currentUser.height.toDouble(),
      'Weight': currentUser.weight.toDouble(),
      'Duration': ((event.workout.data.timeElapsed.toSeconds()) / 60.0).toDouble(),
      'Heart_Rate':hr.toDouble(),
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
        // await calorieManager.addCalorieRecord(50.0);

        // await calorieManager.addCalorieRecord(20.0);
        
        // await calorieManager.addCalorieRecord(300.0);
        
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/common/model/timed.dart';
import 'package:maven/database/enum/equipment.dart';
import 'package:maven/database/enum/muscle.dart';
import 'package:maven/database/enum/muscle_group.dart';
import 'package:maven/database/table/exercise.dart' as db;
import 'package:maven/database/table/exercise.dart';
import 'package:maven/database/table/routine.dart';
import 'package:maven/feature/exercise/model/exercise_list.dart';
import 'package:maven/feature/template/bloc/template/template_bloc.dart';
import 'package:maven/feature/template/bloc/template/workout_template_service.dart';

// Function to generate mock routines and exercises based on goal (number of days per week)
void generateMockWorkoutData(BuildContext context, int goal) {
  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  switch (goal) {
    case 3:
      generatePPLTemplate(context, isTwice: false);
      
      break;
    case 6:
      generatePPLTemplate(context, isTwice: true);
      
      break;

    default:
        // Sample exercise to be added to routines
        const sampleExercise = Exercise(
          id: 1,
          name: 'Arnold Press (Dumbbell)',
          muscle: Muscle.adductors,
          muscleGroup: MuscleGroup.back,
          equipment: Equipment.ball,
          videoPath: '',
          timer: Timed.zero(),
        );
      for (int i = 0; i < goal; i++) {

        final routine = Routine(
          id: i + 1,
          name: '${daysOfWeek[i % 7]} Workout', // Assigning day names cyclically
          note: 'Workout plan for ${daysOfWeek[i % 7]}',
          timestamp: DateTime.now(),
          type: RoutineType.template,
        );

        final exerciseList = ExerciseList();
        exerciseList.addExerciseGroup(sampleExercise);
        exerciseList.addExerciseSet(0);

        // Dispatching the TemplateCreate event with the generated mock data
        context.read<TemplateBloc>().add(
          TemplateCreate(
            routine: routine,
            exerciseList: exerciseList,
          ),
        );

        print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
      }

  }

}


// Function to generate mock PPL workout templates for 3 or 6 days
void generatePPLTemplate(BuildContext context, {bool isTwice = false}) {
  // Define the workout plan days based on goal (3 or 6-day split)
  final List<String> days = isTwice
      ? ['Sunday', 'Monday', 'Tuesday', 'Thursday', 'Friday', 'Saturday']
      : ['Sunday', 'Tuesday', 'Thursday'];

  final List<String> routineNames = ['Push', 'Pull', 'Legs'];

  // Create routines based on the selected days
  final List<Routine> routines = List.generate(days.length, (index) {
    return Routine(
      id: index + 1,
      name: '${days[index]} ${routineNames[index % 3]} Workout',
      note: 'This is a sample note for ${routineNames[index % 3]} workout on ${days[index]}.',
      timestamp: DateTime.now(),
      type: RoutineType.template,
    );
  });

  // Sample exercises categorized for Push, Pull, and Legs
  final pushExercises = [
    const Exercise(
      id: 1,
      name: 'Bench Press',
      muscle: Muscle.pectoralisMajor,
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.barbell,
      videoPath: '',
      timer: Timed.zero(),
    ),
    const Exercise(
      id: 2,
      name: 'Shoulder Press (Dumbbell)',
      muscle: Muscle.deltoid,
      muscleGroup: MuscleGroup.shoulders,
      equipment: Equipment.dumbbell,
      videoPath: '',
      timer: Timed.zero(),
    ),
    const Exercise(
      id: 3,
      name: 'Triceps Dips',
      muscle: Muscle.tricepsBrachii,
      muscleGroup: MuscleGroup.arms,
      equipment: Equipment.bodyWeight,
      videoPath: '',
      timer: Timed.zero(),
    ),
  ];

  final pullExercises = [
    const Exercise(
      id: 4,
      name: 'Pull-Ups',
      muscle: Muscle.latissimusDorsi,
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.bodyWeight,
      videoPath: '',
      timer: Timed.zero(),
    ),
    const Exercise(
      id: 5,
      name: 'Barbell Rows',
      muscle: Muscle.rhomboids,
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.barbell,
      videoPath: '',
      timer: Timed.zero(),
    ),
    const Exercise(
      id: 6,
      name: 'Bicep Curls (Dumbbell)',
      muscle: Muscle.bicepsBrachii,
      muscleGroup: MuscleGroup.arms,
      equipment: Equipment.dumbbell,
      videoPath: '',
      timer: Timed.zero(),
    ),
  ];

  final legExercises = [
    const Exercise(
      id: 7,
      name: 'Squats',
      muscle: Muscle.quadriceps,
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.barbell,
      videoPath: '',
      timer: Timed.zero(),
    ),
    const Exercise(
      id: 8,
      name: 'Leg Press',
      muscle: Muscle.hamstrings,
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.machine,
      videoPath: '',
      timer: Timed.zero(),
    ),
    const Exercise(
      id: 9,
      name: 'Calf Raises',
      muscle: Muscle.gastrocnemius,
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.machine,
      videoPath: '',
      timer: Timed.zero(),
    ),
  ];

  final List<List<Exercise>> exerciseGroups = [
    pushExercises,
    pullExercises,
    legExercises,
  ];

  // Create routines and dispatch events
  for (int i = 0; i < routines.length; i++) {
    final exerciseList = ExerciseList();

    for (var exercise in exerciseGroups[i % 3]) {
      exerciseList.addExerciseGroup(exercise);
      exerciseList.addExerciseSet(0);
    }

    // Dispatch the TemplateCreate event with the generated mock data
    context.read<TemplateBloc>().add(
      TemplateCreate(
        routine: routines[i],
        exerciseList: exerciseList,
      ),
    );

    print('Routine created: ${routines[i].name} with ${exerciseList.getLength()} exercises.');
  }
}

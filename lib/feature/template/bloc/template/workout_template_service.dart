import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/common/model/timed.dart';
import 'package:maven/database/enum/equipment.dart';
import 'package:maven/database/enum/exercise_field_type.dart';
import 'package:maven/database/enum/muscle.dart';
import 'package:maven/database/enum/muscle_group.dart';
import 'package:maven/database/enum/weight_unit.dart';
import 'package:maven/database/table/exercise.dart';
import 'package:maven/database/table/exercise_field.dart';
import 'package:maven/database/table/routine.dart';
import 'package:maven/feature/exercise/model/exercise_list.dart';
import 'package:maven/feature/template/bloc/template/template_bloc.dart';
import 'package:maven/feature/transfer/model/exercise_conversion.dart';
import 'package:maven/feature/transfer/model/transfer_source.dart';

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

    case 1:
      generateFullBodyWorkout(context, daysOfWeek[0]); // Monday
      break;

    case 2:
      generateUpperLowerSplit(context, ['Monday', 'Thursday']); // Upper-Lower split
      break;

    case 4:
      generateUpperLowerSplit(context, ['Sunday', 'Tuesday', 'Thursday', 'Saturday']);
      break;

    case 5:
      generateUpperLowerLegSplit(context);
      break;

    default:
      generateCustomWorkout(context, goal, daysOfWeek);
  }
}

// Function to generate PPL workout templates for 3 or 6 days
void generatePPLTemplate(BuildContext context, {bool isTwice = false}) {
  final List<String> days = isTwice
      ? ['Sunday', 'Monday', 'Tuesday', 'Thursday', 'Friday', 'Saturday']
      : ['Sunday', 'Tuesday', 'Thursday'];

  final List<String> routineNames = ['Push', 'Pull', 'Legs'];

  final List<List<Exercise>> exerciseGroups = [
    _getPushExercises(),
    _getPullExercises(),
    _getLegExercises(),
  ];

  for (int i = 0; i < days.length; i++) {
    final routine = Routine(
      id: i + 1,
      name: '${days[i]} ${routineNames[i % 3]} Workout',
      note: 'Sample note for ${routineNames[i % 3]} on ${days[i]}.',
      timestamp: DateTime.now(),
      type: RoutineType.template,
    );

    final exerciseList = ExerciseList();
    for (var exercise in exerciseGroups[i % 3]) {
      exerciseList.addExerciseGroup(exercise);
      exerciseList.addExerciseSet(0);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

// Function to generate Full-Body Workout
void generateFullBodyWorkout(BuildContext context, String day) {
  final routine = Routine(
    id: 1,
    name: '$day Full Body Workout',
    note: 'Comprehensive full-body workout on $day.',
    timestamp: DateTime.now(),
    type: RoutineType.template,
  );

  final exerciseList = ExerciseList();
  for (var exercise in _getFullBodyExercises()) {
    exerciseList.addExerciseGroup(exercise);
    exerciseList.addExerciseSet(0);
  }

  context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
  print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
}

// Function to generate Upper-Lower split
void generateUpperLowerSplit(BuildContext context, List<String> days) {
  final List<String> splitNames = ['Upper', 'Lower'];
  final List<List<Exercise>> exerciseGroups = [_getUpperExercises(), _getLowerExercises()];

  for (int i = 0; i < days.length; i++) {
    final routine = Routine(
      id: i + 1,
      name: '${days[i]} ${splitNames[i % 2]} Workout',
      note: '${splitNames[i % 2]} body workout on ${days[i]}.',
      timestamp: DateTime.now(),
      type: RoutineType.template,
    );

    final exerciseList = ExerciseList();
    for (var exercise in exerciseGroups[i % 2]) {
      exerciseList.addExerciseGroup(exercise);
      exerciseList.addExerciseSet(0);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

// Function to generate Upper-Lower-Leg split for 5 days
void generateUpperLowerLegSplit(BuildContext context) {
  final List<String> days = ['Monday', 'Wednesday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> routineNames = ['Upper', 'Lower', 'Legs'];

  final List<List<Exercise>> exerciseGroups = [
    _getUpperExercises(),
    _getLowerExercises(),
    _getLegExercises()
  ];

  for (int i = 0; i < days.length; i++) {
    final routine = Routine(
      id: i + 1,
      name: '${days[i]} ${routineNames[i % 3]} Workout',
      note: '${routineNames[i % 3]} body workout on ${days[i]}.',
      timestamp: DateTime.now(),
      type: RoutineType.template,
    );

    final exerciseList = ExerciseList();
    for (var exercise in exerciseGroups[i % 3]) {
      exerciseList.addExerciseGroup(exercise);
      exerciseList.addExerciseSet(0);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

// Function to generate custom workout plans
void generateCustomWorkout(BuildContext context, int goal, List<String> daysOfWeek) {
  for (int i = 0; i < goal; i++) {
    final routine = Routine(
      id: i + 1,
      name: '${daysOfWeek[i % 7]} Workout',
      note: 'Workout plan for ${daysOfWeek[i % 7]}',
      timestamp: DateTime.now(),
      type: RoutineType.template,
    );

    final exerciseList = ExerciseList();
    for (var exercise in _getFullBodyExercises()) {
      exerciseList.addExerciseGroup(exercise);
      exerciseList.addExerciseSet(0);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

// Exercise data generators
List<Exercise> _getPushExercises() => [
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

List<Exercise> _getPullExercises() => [
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

List<Exercise> _getLegExercises() => [
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

List<Exercise> _getUpperExercises() => [
      const Exercise(id: 10, name: 'Incline Bench Press', muscle: Muscle.adductors, muscleGroup: MuscleGroup.legs, equipment: Equipment.barbell, videoPath: '', timer: Timed.zero()),
    ];

List<Exercise> _getLowerExercises() => [
      const Exercise(id: 12, name: 'Deadlifts', muscle: Muscle.adductors, muscleGroup: MuscleGroup.legs, equipment: Equipment.barbell, videoPath: '', timer: Timed.zero()),
    ];

List<Exercise> _getFullBodyExercises() => [
const Exercise(
    id: 1,
    name: 'Ab Wheel',
    muscle: Muscle.iliopsoas,
    muscleGroup: MuscleGroup.core,
    equipment: Equipment.wheelRoller,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 1,
      second: 30,
    ),
    weightUnit: WeightUnit.kilogram,
    fields: [
      ExerciseField(
        type: ExerciseFieldType.reps,
        exerciseId: -1,
      ),
    ],
    conversions: [
      ExerciseConversion(
        source: TransferSource.strong,
        name: 'Ab Wheel',
      ),
    ],
  ),
  const Exercise(
    id: 2,
    name: 'Arnold Press (Dumbbell)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.dumbbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 1,
      second: 30,
    ),
    weightUnit: WeightUnit.kilogram,
    fields: [
      ExerciseField(
        type: ExerciseFieldType.weight,
        exerciseId: -1,
      ),
      ExerciseField(
        type: ExerciseFieldType.reps,
        exerciseId: -1,
      ),
    ],
    conversions: [
      ExerciseConversion(
        source: TransferSource.strong,
        name: 'Arnold Press (Dumbbell)',
      ),
    ],
  ),
  const Exercise(
    id: 3,
    name: 'Around the World',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.dumbbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 1,
      second: 30,
    ),
    weightUnit: WeightUnit.kilogram,
    fields: [
      ExerciseField(
        type: ExerciseFieldType.weight,
        exerciseId: -1,
      ),
      ExerciseField(
        type: ExerciseFieldType.reps,
        exerciseId: -1,
      ),
    ],
    conversions: [
      ExerciseConversion(
        source: TransferSource.strong,
        name: 'Around the World',
      ),
    ],
  ),
  const Exercise(
    id: 4,
    name: 'Back Extension',
    muscle: Muscle.erectorSpinae,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.machine,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 1,
      second: 30,
    ),
    weightUnit: WeightUnit.pound,
    fields: [
      ExerciseField(
        type: ExerciseFieldType.weight,
        exerciseId: -1,
      ),
      ExerciseField(
        type: ExerciseFieldType.reps,
        exerciseId: -1,
      ),
    ],
    conversions: [
      ExerciseConversion(
        source: TransferSource.strong,
        name: 'Back Extension',
      ),
    ],
  ),
      ];

import 'dart:math';

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

void generateWorkoutTemplate(BuildContext context, int goal) {
  final List<String> daysOfWeek = [
    
   'Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  switch (goal) {
    case 3:
      generatePPLTemplate(context, isTwice: false);
      break;

    case 6:
      generatePPLTemplate(context, isTwice: true);
      break;

    case 1:
      generateFullBodyWorkout(context, daysOfWeek[2]); // Monday
      break;

    case 2:
      generateUpperLowerSplit(context, ['Monday', 'Thursday']); // Upper-Lower split
      break;

    case 4:
      generateUpperLowerSplit(context, ['Sunday', 'Tuesday', 'Thursday', 'Saturday']);
      break;

    case 5:
      generateUpperLowerFullBodySplit(context);
      break;

    default:
      generateCustomWorkout(context, goal, daysOfWeek);
  }
}




//Functions to generate splits
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
      exerciseList.addExerciseSet(-1);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

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
      exerciseList.addExerciseSet(-1);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

void generateUpperLowerFullBodySplit(BuildContext context) {
  final List<String> days = ['Monday', 'Wednesday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> routineNames = ['Upper', 'Lower', 'Full Body'];

  final List<List<Exercise>> exerciseGroups = [
    _getUpperExercises(),
    _getLowerExercises(),
    _getFullBodyExercises()
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
      exerciseList.addExerciseSet(-1);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

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
      note: 'Workout for ${routineNames[i % 3]} on ${days[i]}.',
      timestamp: DateTime.now(),
      type: RoutineType.template,
    );

    final exerciseList = ExerciseList();
    for (var exercise in exerciseGroups[i % 3]) {
      exerciseList.addExerciseGroup(exercise);
      exerciseList.addExerciseSet(-1);
    }

    context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
    print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
  }
}

void generateFullBodyWorkout(BuildContext context, String day) {
  final routine = Routine(
    id: 1,
    name: '$day Full Body Workout',
    note: 'Comprehensive full-body workout.',
    timestamp: DateTime.now(),
    type: RoutineType.template,
  );

  final exerciseList = ExerciseList();
  for (var exercise in _getFullBodyExercises()) {
    exerciseList.addExerciseGroup(exercise);
    exerciseList.addExerciseSet(-1);
    
  }

  context.read<TemplateBloc>().add(TemplateCreate(routine: routine, exerciseList: exerciseList));
  print('Routine created: ${routine.name} with ${exerciseList.getLength()} exercises.');
}


//best compound and isolation Exercises
List<Exercise> _getUpperExercises() {
List <Exercise> compoundExercises = [
const Exercise(
    id: 9,
    name: 'Bench Press (Barbell)',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bench Press (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 135,
    name: 'Overhead Press (Barbell)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
      )
    ],
    conversions: [
      ExerciseConversion(
        name: 'Overhead Press (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 17,
    name: 'Bent-over Row (Barbell)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bent-over Row (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
   const Exercise(
    id: 19,
    name: 'Bent-over Row - Underhand (Barbell)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bent-over Row - Underhand (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),

];
List <Exercise> isolationExercises = [
 const Exercise(
    id: 38,
    name: 'Chest Fly (Machine)',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.machine,
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
        name: 'Chest Fly (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
const Exercise(
    id: 70,
    name: 'Front Raise (Barbell)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.barbell,
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
        name: 'Front Raise (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 21,
    name: 'Bicep Curl (Cable)',
    muscle: Muscle.bicepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.cable,
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
        name: 'Bicep Curl (Cable)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 31,
    name: 'Cable Kickback',
    muscle: Muscle.tricepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.cable,
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
        name: 'Cable Kickback',
        source: TransferSource.strong,
      ),
    ]
  ),
  const Exercise(
    id: 105,
    name: 'Iso-Lateral Row (Machine)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.machine,
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
        name: 'Iso-Lateral Row (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
];
return exercisesSelector(compoundExercises, isolationExercises, 2, 4);
}

List<Exercise> _getLowerExercises() {
return _getLegExercises();
}

List<Exercise> _getPushExercises() {
  List<Exercise> compoundExercises = [
const Exercise(
    id: 9,
    name: 'Bench Press (Barbell)',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bench Press (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 59,
    name: 'Decline Bench Press (Barbell)',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Decline Bench Press (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 135,
    name: 'Overhead Press (Barbell)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
      )
    ],
    conversions: [
      ExerciseConversion(
        name: 'Overhead Press (Barbell)',
        source: TransferSource.strong,
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
  
  ];
  List <Exercise> isolationExercises = [
    const Exercise(
    id: 38,
    name: 'Chest Fly (Machine)',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.machine,
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
        name: 'Chest Fly (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),

const Exercise(
    id: 13,
    name: 'Bench Press Close Grip (Barbell)',
    muscle: Muscle.tricepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bench Press Close Grip (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
const Exercise(
    id: 123,
    name: 'Lateral Raise (Cable)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.cable,
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
        name: 'Lateral Raise (Cable)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 65,
    name: 'Face Pull (Cable)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.cable,
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
        name: 'Face Pull (Cable)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 118,
    name: 'Lat Pulldown (Machine)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.machine,
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
        name: 'Lat Pulldown (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),

 
 
 ];
  return exercisesSelector(compoundExercises, isolationExercises, 2, 4);
}

List<Exercise> _getPullExercises() {
List <Exercise> compoundExercises = [
const Exercise(
    id: 55,
    name: 'Deadlift (Barbell)',
    muscle: Muscle.gluteus,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Deadlift (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
   const Exercise(
    id: 17,
    name: 'Bent-over Row (Barbell)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bent-over Row (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
   const Exercise(
    id: 19,
    name: 'Bent-over Row - Underhand (Barbell)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bent-over Row - Underhand (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
];
List <Exercise> isolationExercises = [
  const Exercise(
    id: 21,
    name: 'Bicep Curl (Cable)',
    muscle: Muscle.bicepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.cable,
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
        name: 'Bicep Curl (Cable)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 31,
    name: 'Cable Kickback',
    muscle: Muscle.tricepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.cable,
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
        name: 'Cable Kickback',
        source: TransferSource.strong,
      ),
    ]
  ),
  const Exercise(
    id: 105,
    name: 'Iso-Lateral Row (Machine)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.machine,
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
        name: 'Iso-Lateral Row (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 65,
    name: 'Face Pull (Cable)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.cable,
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
        name: 'Face Pull (Cable)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 118,
    name: 'Lat Pulldown (Machine)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.machine,
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
        name: 'Lat Pulldown (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),

      


];
return exercisesSelector(compoundExercises, isolationExercises, 2, 3);
}

List<Exercise> _getLegExercises() {
List<Exercise> compoundExercises = [
const Exercise(
    id: 26,
    name: 'Box Squat (Barbell)',
    muscle: Muscle.gluteus,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Box Squat (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
const Exercise(
    id: 127,
    name: 'Leg Press',
    muscle: Muscle.quadriceps,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.machine,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
      second: 0,
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
        name: 'Leg Press',
        source: TransferSource.strong,
      ),
    ],
  ),
const Exercise(
    id: 55,
    name: 'Deadlift (Barbell)',
    muscle: Muscle.gluteus,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Deadlift (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),

];
List <Exercise> isolationExercises = [
const Exercise(
    id: 130,
    name: 'Lunge (Dumbbell)',
    muscle: Muscle.quadriceps,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
    ),
    weightUnit: WeightUnit.kilogram,
    fields: [
      ExerciseField(
        type: ExerciseFieldType.weighted,
        exerciseId: -1,
      ),
      ExerciseField(
        type: ExerciseFieldType.reps,
        exerciseId: -1,
      ),
    ],
    conversions: [
      ExerciseConversion(
        name: 'Lunge (Dumbbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
 const Exercise(
    id: 131,
    name: 'Lying Leg Curl (Machine)',
    muscle: Muscle.hamstrings,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.machine,
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
        name: 'Lying Leg Curl (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
 const Exercise(
    id: 27,
    name: 'Bulgarian Split Squat (Dumbbell)',
    muscle: Muscle.quadriceps,
    muscleGroup: MuscleGroup.legs,
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
        name: 'Bulgarian Split Squat (Dumbbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
const Exercise(
    id: 93,
    name: 'Hip Thrust (Barbell)',
    muscle: Muscle.gluteus,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Hip Thrust (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
 const Exercise(
    id: 92,
    name: 'Hip Adductor (Machine)',
    muscle: Muscle.adductors,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.machine,
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
        name: 'Hip Adductor (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
];
return exercisesSelector(compoundExercises, isolationExercises, 2, 3);

}

List<Exercise> _getFullBodyExercises() {
  
  List<Exercise> compoundExercises = [
    const Exercise(
      id: 26,
      name: 'Box Squat (Barbell)',
      muscle: Muscle.gluteus,
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.barbell,
      videoPath: 'VIDEOPATH',
      timer: Timed(
        minute: 3,
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
          name: 'Box Squat (Barbell)',
          source: TransferSource.strong,
        ),
      ],
    ),
    const Exercise(
    id: 55,
    name: 'Deadlift (Barbell)',
    muscle: Muscle.gluteus,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Deadlift (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 9,
    name: 'Bench Press (Barbell)',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bench Press (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 135,
    name: 'Overhead Press (Barbell)',
    muscle: Muscle.deltoid,
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
      )
    ],
    conversions: [
      ExerciseConversion(
        name: 'Overhead Press (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 17,
    name: 'Bent-over Row (Barbell)',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
    videoPath: 'VIDEOPATH',
    timer: Timed(
      minute: 3,
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
        name: 'Bent-over Row (Barbell)',
        source: TransferSource.strong,
      ),
    ],
  ),

  ];

  // List of isolation exercises (remaining exercises)
  List<Exercise> isolationExercises = [
     const Exercise(
    id: 22,
    name: 'Bicep Curl (Dumbbell)',
    muscle: Muscle.bicepsBrachii,
    muscleGroup: MuscleGroup.arms,
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
        name: 'Bicep Curl (Dumbbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
   const Exercise(
    id: 31,
    name: 'Cable Kickback',
    muscle: Muscle.tricepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.cable,
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
        name: 'Cable Kickback',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 124,
    name: 'Lateral Raise (Dumbbell)',
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
        name: 'Lateral Raise (Dumbbell)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 126,
    name: 'Leg Extension (Machine)',
    muscle: Muscle.quadriceps,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.machine,
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
        name: 'Leg Extension (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 131,
    name: 'Lying Leg Curl (Machine)',
    muscle: Muscle.hamstrings,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.machine,
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
        name: 'Lying Leg Curl (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
  const Exercise(
    id: 91,
    name: 'Hip Abductor (Machine)',
    muscle: Muscle.adductors,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.machine,
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
        name: 'Hip Abductor (Machine)',
        source: TransferSource.strong,
      ),
    ],
  ),
  ];
  return exercisesSelector(compoundExercises, isolationExercises, 3, 4);
}


//exercise selector
List<Exercise> exercisesSelector (List <Exercise> compoundExercises, List<Exercise> isolationExercises, int compValue, int isoValue){
  Random random = Random();

  // Select n compound exercises randomly
  List<Exercise> selectedCompoundExercises = [];
  while (selectedCompoundExercises.length < compValue) {
    Exercise randomCompound = compoundExercises[random.nextInt(compoundExercises.length)];
    if (!selectedCompoundExercises.contains(randomCompound)) {
      selectedCompoundExercises.add(randomCompound);
    }
  }

  // Select n isolation exercises randomly
  List<Exercise> selectedIsolationExercises = [];
  while (selectedIsolationExercises.length < isoValue) {
    Exercise randomIsolation = isolationExercises[random.nextInt(isolationExercises.length)];
    if (!selectedIsolationExercises.contains(randomIsolation)) {
      selectedIsolationExercises.add(randomIsolation);
    }
  }

  // Combine selected exercises into one list and return it
  return selectedCompoundExercises + selectedIsolationExercises;
}
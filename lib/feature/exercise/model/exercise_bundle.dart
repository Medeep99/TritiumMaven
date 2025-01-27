import 'package:maven/common/common.dart';
import 'package:maven/feature/exercise/model/exercise_list.dart';

import '../../../database/database.dart';
import '../exercise.dart';

class ExerciseBundle {
  ExerciseBundle({
    required this.exercise,
    required this.exerciseGroup,
    required this.exerciseSets,
    required this.barId, 
  });

  Exercise exercise;
  ExerciseGroupDto exerciseGroup;
  List<BaseExerciseSet> exerciseSets;
  int? barId;

  ExerciseBundle copyWith({
    Exercise? exercise,
    ExerciseGroupDto? exerciseGroup,
    List<BaseExerciseSet>? exerciseSets,
    int? barId,
  }) {
    return ExerciseBundle(
      exercise: exercise ?? this.exercise,
      exerciseGroup: exerciseGroup ?? this.exerciseGroup,
      // TODO: MIGHT BE BROKEN
      exerciseSets: [],
      barId: barId ?? this.barId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseBundle &&
          runtimeType == other.runtimeType &&
          exercise == other.exercise &&
          exerciseGroup == other.exerciseGroup &&
          exerciseSets == other.exerciseSets &&
          barId == other.barId;

  @override
  int get hashCode =>
      exercise.hashCode ^
      exerciseGroup.hashCode ^
      exerciseSets.hashCode ^
      barId.hashCode;

  @override
  String toString() {
    return 'ExerciseBundle{exercise: $exercise, exerciseGroup: $exerciseGroup, exerciseSets: $exerciseSets, barId: $barId}';
  }
}


// Mock data
Exercise mockExercise = const Exercise(
    id: 1, // id (auto-generated for real DB, manually set here)
    name: 'push-up',
    muscle: Muscle.adductors, // Assuming Muscle is an enum with chest as one of the values
    muscleGroup: MuscleGroup.arms, // Assuming MuscleGroup is an enum with upperBody as one of the values
    equipment: Equipment.none, // Assuming Equipment is an enum with 'none' representing bodyweight exercises
    videoPath: 'assets/videos/push_up.mp4', // Path to the video (this can be a local or remote path)
    timer: Timed(minute: 0, second: 30), // Assuming Timed is a class that holds time duration
    barId: null, // For bodyweight exercises, barId can be null
    weightUnit: WeightUnit.kilogram, // Assuming WeightUnit is an enum
    distanceUnit: DistanceUnit.meter, // Assuming DistanceUnit is an enum
    fields: [], // Optional list of fields if needed
    conversions: [], // Optional list of conversions if needed
    isCustom: false, // Not a custom exercise
    isHidden: false, // Exercise is not hidden
  );

  // Create ExerciseGroupDto with mock data
  ExerciseGroupDto mockExerciseGroup = const ExerciseGroupDto(
    id: 1, // ID of the exercise group
    timer: Timed(minute: 0, second: 30), // Timer (mocked with 30 seconds)
    weightUnit: WeightUnit.kilogram, // Assuming kg as weight unit
    distanceUnit: DistanceUnit.meter, // Assuming meters as distance unit
    exerciseId: 1, // Exercise ID (referring to an Exercise)
    barId: null, // Bar ID can be null for bodyweight exercises
    routineId: 101, // Routine ID to categorize exercises
  );

int mockBarId = 101; // Bar ID for the exercise

// Create the ExerciseBundle variable and assign mock data to it
ExerciseBundle mockExerciseBundle = ExerciseBundle(
  exercise: mockExercise,
  exerciseGroup: mockExerciseGroup,
  exerciseSets: [],
  barId: mockBarId,
);



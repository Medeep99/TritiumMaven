import 'package:Maven/database/model/workout_exercise_set.dart';
import 'package:equatable/equatable.dart';

import '../../../database/model/template_exercise_set.dart';
import 'set_type.dart';

class ExerciseSet extends Equatable {
  const ExerciseSet({
    required this.exerciseSetId,
    required this.option1,
    this.option2,
    this.checked,
    this.setType = SetType.regular,
    required this.exerciseGroupId,
  });

  final int exerciseSetId;
  final int option1;
  final int? option2;
  final int? checked;
  final SetType setType;
  final int exerciseGroupId;

  ExerciseSet copyWith({
    int? exerciseSetId,
    int? option1,
    int? option2,
    int? checked,
    SetType? setType,
    int? exerciseGroupId,
  }) {
    return ExerciseSet(
      exerciseSetId: exerciseSetId ?? this.exerciseSetId,
      option1: option1 ?? this.option1,
      option2: option2 ?? this.option2,
      checked: checked ?? this.checked,
      setType: setType ?? this.setType,
      exerciseGroupId: exerciseGroupId ?? this.exerciseGroupId,
    );
  }

  WorkoutExerciseSet toWorkoutExerciseSet(int workoutId) {
    return WorkoutExerciseSet(
      workoutExerciseSetId: exerciseSetId,
      option_1: option1,
      option_2: option2,
      checked: checked ?? 0,
      setType: setType,
      workoutExerciseGroupId: exerciseGroupId,
      workoutId: workoutId,
    );
  }

  static ExerciseSet from(TemplateExerciseSet templateExerciseSet) {
    return ExerciseSet(
      exerciseSetId: templateExerciseSet.templateExerciseSetId!,
      exerciseGroupId: templateExerciseSet.templateExerciseGroupId,
      option1: templateExerciseSet.option1,
      option2: templateExerciseSet.option2,
      checked: 0,
    );
  }

  @override
  List<Object?> get props => [
    exerciseSetId,
    option1,
    option2,
    checked,
    exerciseGroupId,
  ];
}
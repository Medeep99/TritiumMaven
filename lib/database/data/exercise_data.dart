import '../../common/model/model.dart';
import '../database.dart';

/// Returns a list of default exercises.
///
/// The list contains pre-defined [Exercise] instances that can be used as a starting point
/// or default set of exercises.
List<Exercise> getDefaultExercises() => [
  Exercise(
    exerciseId: 1,
    name: 'Barbell Squat',
    muscle: Muscle.quadriceps,
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
    videoPath: 'assets/exercises/videos/barbell_squat.mp4',
    timer: Timed.zero(),
    barId: 1,
  ),
  Exercise(
    exerciseId: 2,
    name: 'Barbell Bench Press',
    muscle: Muscle.pectoralisMajor,
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
    videoPath: 'assets/exercises/videos/barbell_bench_press.mp4',
    timer: Timed.zero(),
    barId: 1,
  ),
  Exercise(
    exerciseId: 3,
    name: 'Pull-up',
    muscle: Muscle.latissimusDorsi,
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.bodyWeight,
    videoPath: 'assets/exercises/videos/pull_up.mp4',
    timer: Timed.zero(),
  ),
  Exercise(
    exerciseId: 4,
    name: 'Machine-assisted Triceps Dip',
    muscle: Muscle.tricepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.machine,
    videoPath: 'assets/exercises/videos/barbell_squat.mp4',
    timer: Timed.zero(),
  ),
  Exercise(
    exerciseId: 5,
    name: 'Dumbbell Curl',
    muscle: Muscle.bicepsBrachii,
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.dumbbell,
    videoPath: 'assets/exercises/videos/dumbell_curl.mp4',
    timer: Timed.zero(),
  ),
  Exercise(
    exerciseId: 6,
    name: 'Running',
    muscle: Muscle.fullBody,
    muscleGroup: MuscleGroup.fullBody,
    equipment: Equipment.machine,
    videoPath: 'assets/exercises/videos/dumbell_curl.mp4',
    timer: Timed.zero(),
  ),
  Exercise(
    exerciseId: 7,
    name: 'Farmer\'s Walk',
    muscle: Muscle.fullBody,
    muscleGroup: MuscleGroup.fullBody,
    equipment: Equipment.trapBar,
    videoPath: 'assets/exercises/videos/dumbell_curl.mp4',
    timer: Timed.zero(),
    barId: 3,
  ),
];
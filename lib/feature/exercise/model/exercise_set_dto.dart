// import 'package:copy_with_extension/copy_with_extension.dart';

// import '../../../database/database.dart';
// import '../exercise.dart';

// part 'exercise_set_dto.g.dart';

// @CopyWith()
// class ExerciseSetDto extends BaseExerciseSet {
//   ExerciseSetDto({
//     super.id,
//     required super.type,
//     required super.checked,
//     required super.exerciseGroupId,
//     this.data = const [],
//   });

//   ExerciseSetDto.fromBase({
//     required BaseExerciseSet baseExerciseSet,
//     this.data = const [],
//   }) : super(
//           id: baseExerciseSet.id,
//           type: baseExerciseSet.type,
//           checked: baseExerciseSet.checked,
//           exerciseGroupId: baseExerciseSet.exerciseGroupId,
//         );
//         // toJson method
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type,
//       'checked': checked,
//       'exerciseGroupId': exerciseGroupId,
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }

//   // fromJson method
//   static ExerciseSetDto fromJson(Map<String, dynamic> json) {
//     return ExerciseSetDto(
//       id: json['id'],
//       type: json['type'],
//       checked: json['checked'],
//       exerciseGroupId: json['exerciseGroupId'],
//       data: (json['data'] as List)
//           .map((e) => ExerciseSetDataDto.fromJson(e))
//           .toList(),
//     );
//   }

//   final List<ExerciseSetDataDto> data;
// }


//------gpt generated:
import 'package:copy_with_extension/copy_with_extension.dart';
import '../../../database/database.dart';
import '../exercise.dart';
import 'exercise_set_data_dto.dart'; // Make sure to import ExerciseSetDataDto

part 'exercise_set_dto.g.dart';

@CopyWith()
class ExerciseSetDto extends BaseExerciseSet {
  ExerciseSetDto({
    super.id,
    required super.type,
    required super.checked,
    required super.exerciseGroupId,
    this.data = const [],
  });

  ExerciseSetDto.fromBase({
    required BaseExerciseSet baseExerciseSet,
    this.data = const [],
  }) : super(
          id: baseExerciseSet.id,
          type: baseExerciseSet.type,
          checked: baseExerciseSet.checked,
          exerciseGroupId: baseExerciseSet.exerciseGroupId,
        );

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'checked': checked,
      'exerciseGroupId': exerciseGroupId,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  // fromJson method
  static ExerciseSetDto fromJson(Map<String, dynamic> json) {
    return ExerciseSetDto(
      id: json['id'],
      type: json['type'],
      checked: json['checked'],
      exerciseGroupId: json['exerciseGroupId'],
      data: (json['data'] as List)
          .map((e) => ExerciseSetDataDto.fromJson(e))
          .toList(),
    );
  }

  final List<ExerciseSetDataDto> data;
}

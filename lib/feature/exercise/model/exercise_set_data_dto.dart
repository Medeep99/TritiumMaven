
import 'package:copy_with_extension/copy_with_extension.dart';
import 'dart:convert'; // For JSON encoding/decoding

import '../../../database/database.dart';

part 'exercise_set_data_dto.g.dart';

@CopyWith()
class ExerciseSetDataDto extends BaseExerciseSetData {
  ExerciseSetDataDto({
    super.id,
    required super.value,
    required super.fieldType,
    required super.exerciseSetId,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'fieldType': fieldType,
      'exerciseSetId': exerciseSetId,
    };
  }

  // fromJson method
  static ExerciseSetDataDto fromJson(Map<String, dynamic> json) {
    return ExerciseSetDataDto(
      id: json['id'],
      value: json['value'],
      fieldType: json['fieldType'],
      exerciseSetId: json['exerciseSetId'],
    );
  }
}

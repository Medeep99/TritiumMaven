import 'dart:convert';
import 'package:floor/floor.dart';
import 'package:maven/feature/exercise/model/exercise_set_dto.dart'; // Import ExerciseSetDto

class ExerciseSetListConverter extends TypeConverter<List<ExerciseSetDto>, String> {
  // Convert List<ExerciseSetDto> to JSON string
  @override
  String toSql(List<ExerciseSetDto> value) {
    return jsonEncode(value.map((exerciseSet) => exerciseSet.toJson()).toList());
  }

  // Convert JSON string back to List<ExerciseSetDto>
  @override
  List<ExerciseSetDto> fromSql(String dbValue) {
    final List<dynamic> decoded = jsonDecode(dbValue);
    return decoded.map((exerciseSetJson) => ExerciseSetDto.fromJson(exerciseSetJson)).toList();
  }
  
  @override
  List<ExerciseSetDto> decode(String databaseValue) {
    // TODO: implement decode
    throw UnimplementedError();
  }
  
  @override
  String encode(List<ExerciseSetDto> value) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}

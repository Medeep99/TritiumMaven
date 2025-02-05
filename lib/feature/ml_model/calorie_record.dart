import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CalorieRecord {
  final double calories;
  final DateTime timestamp;
  
  CalorieRecord({
    required this.calories,
    required this.timestamp,
  });

  // From JSON
  factory CalorieRecord.fromJson(Map<String, dynamic> json) {
    return CalorieRecord(
      calories: json['calories'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
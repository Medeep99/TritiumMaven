// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: (json['id'] as num?)?.toInt(),
      data: json['data'] as String,
      exerciseGroupId: (json['exerciseGroupId'] as num).toInt(),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'exerciseGroupId': instance.exerciseGroupId,
    };

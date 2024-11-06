// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RoutineCWProxy {
  Routine id(int? id);

  Routine name(String name);

  Routine note(String note);

  Routine timestamp(DateTime timestamp);

  Routine type(RoutineType type);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Routine(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Routine(...).copyWith(id: 12, name: "My name")
  /// ````
  Routine call({
    int? id,
    String? name,
    String? note,
    DateTime? timestamp,
    RoutineType? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRoutine.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRoutine.copyWith.fieldName(...)`
class _$RoutineCWProxyImpl implements _$RoutineCWProxy {
  const _$RoutineCWProxyImpl(this._value);

  final Routine _value;

  @override
  Routine id(int? id) => this(id: id);

  @override
  Routine name(String name) => this(name: name);

  @override
  Routine note(String note) => this(note: note);

  @override
  Routine timestamp(DateTime timestamp) => this(timestamp: timestamp);

  @override
  Routine type(RoutineType type) => this(type: type);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Routine(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Routine(...).copyWith(id: 12, name: "My name")
  /// ````
  Routine call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? timestamp = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return Routine(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      note: note == const $CopyWithPlaceholder() || note == null
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
      timestamp: timestamp == const $CopyWithPlaceholder() || timestamp == null
          ? _value.timestamp
          // ignore: cast_nullable_to_non_nullable
          : timestamp as DateTime,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as RoutineType,
    );
  }
}

extension $RoutineCopyWith on Routine {
  /// Returns a callable class that can be used as follows: `instanceOfRoutine.copyWith(...)` or like so:`instanceOfRoutine.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RoutineCWProxy get copyWith => _$RoutineCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<String, dynamic> json) => Routine(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      note: json['note'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$RoutineTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$RoutineTypeEnumMap[instance.type]!,
    };

const _$RoutineTypeEnumMap = {
  RoutineType.template: 'template',
  RoutineType.workout: 'workout',
  RoutineType.session: 'session',
};

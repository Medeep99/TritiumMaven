// import '../../../database/database.dart';
// import '../exercise.dart';

// class ExerciseList {
//   static const int blank = -1;

//   final List<ExerciseGroupDto> _exercises;

//   ExerciseList(
//     List<ExerciseGroupDto>? exercises,
//   ) : _exercises = exercises ?? [];

//   int getLength() {
//     return _exercises.length;
//   }

//   void addExerciseGroup(Exercise exercise) {
//     ExerciseGroupDto exerciseGroup = ExerciseGroupDto(
//       timer: exercise.timer,
//       weightUnit: exercise.weightUnit,
//       distanceUnit: exercise.distanceUnit,
//       exerciseId: exercise.id!,
//       barId: exercise.barId,
//       routineId: blank,
//       sets: [
//         ExerciseSetDto(
//           checked: false,
//           type: ExerciseSetType.regular,
//           exerciseGroupId: blank,
//           data: exercise.fields.map((field) {
//             return ExerciseSetDataDto(
//               value: '',
//               fieldType: field.type,
//               exerciseSetId: blank,
//             );
//           }).toList(),
//         ),
//       ],
//     );

//     _exercises.add(exerciseGroup);
//   }

//   void removeExerciseGroup(int index) {
//     _exercises.removeAt(index);
//   }

//   void addExerciseSet(int index) {
//     ExerciseGroupDto exerciseGroup = _exercises[index];
//     ExerciseSetDto exerciseSet = ExerciseSetDto(
//       checked: false,
//       type: ExerciseSetType.regular,
//       exerciseGroupId: blank,
//       data: exerciseGroup.sets.last.data.map((data) {
//         return data.copyWith();
//       }).toList(),
//     );

//     exerciseGroup.sets.add(exerciseSet);
//   }

//   ExerciseGroupDto getExerciseGroup(int index) {
//     return _exercises[index];
//   }

//   void updateExerciseSet(ExerciseSetDto value, int index, int index2) {
//     _exercises[index].sets[index2] = value;
//   }

//   void removeExerciseSet(int index, int index2) {
//     _exercises[index].sets.removeAt(index2);
//   }

//   void updateExerciseGroup(ExerciseGroupDto value, int index) {
//     _exercises[index] = value;
//   }

//   // figure some shit out for this temp solution
//   ExerciseList deepCopy() {
//     return ExerciseList(_exercises
//         .map(
//           (exerciseGroup) => exerciseGroup.copyWith(
//             sets: exerciseGroup.sets
//                 .map(
//                   (exerciseSet) => exerciseSet.copyWith(
//                     data: exerciseSet.data
//                         .map(
//                           (exerciseSetData) => exerciseSetData.copyWith(),
//                         )
//                         .toList(),
//                   ),
//                 )
//                 .toList(),
//             notes: exerciseGroup.notes
//                 .map(
//                   (note) => note.copyWith(),
//                 )
//                 .toList(),
//           ),
//         )
//         .toList());
//   }
// }

import '../../../database/database.dart';
import '../exercise.dart';

class ExerciseList {
  static const int blank = -1;

  final List<ExerciseGroupDto> _exercises;

  ExerciseList([List<ExerciseGroupDto>? exercises]) : _exercises = exercises ?? [];

  int getLength() => _exercises.length;

  void addExerciseGroup(Exercise exercise) {
    ExerciseGroupDto exerciseGroup = _createExerciseGroup(exercise);
    _exercises.add(exerciseGroup);
  }

  void removeExerciseGroup(int index) {
    if (index >= 0 && index < _exercises.length) {
      _exercises.removeAt(index);
    }
  }

  void addExerciseSet(int index) {
    if (index >= 0 && index < _exercises.length) {
      ExerciseGroupDto exerciseGroup = _exercises[index];
      ExerciseSetDto exerciseSet = _createExerciseSet(exerciseGroup);
      exerciseGroup.sets.add(exerciseSet);
    }
  }

  ExerciseGroupDto getExerciseGroup(int index) {
    if (index >= 0 && index < _exercises.length) {
      return _exercises[index];
    }
    throw IndexError(index, _exercises);
  }

  void updateExerciseSet(ExerciseSetDto value, int index, int setIndex) {
    if (index >= 0 && index < _exercises.length) {
      ExerciseGroupDto exerciseGroup = _exercises[index];
      if (setIndex >= 0 && setIndex < exerciseGroup.sets.length) {
        exerciseGroup.sets[setIndex] = value;
      }
    }
  }

  void removeExerciseSet(int index, int setIndex) {
    if (index >= 0 && index < _exercises.length) {
      ExerciseGroupDto exerciseGroup = _exercises[index];
      if (setIndex >= 0 && setIndex < exerciseGroup.sets.length) {
        exerciseGroup.sets.removeAt(setIndex);
      }
    }
  }

  void updateExerciseGroup(ExerciseGroupDto value, int index) {
    if (index >= 0 && index < _exercises.length) {
      _exercises[index] = value;
    }
  }

  ExerciseList deepCopy() {
    return ExerciseList(
      _exercises.map((exerciseGroup) => exerciseGroup.copyWith(
        sets: exerciseGroup.sets.map((exerciseSet) => exerciseSet.copyWith(
          data: exerciseSet.data.map((exerciseSetData) => exerciseSetData.copyWith()).toList(),
        )).toList(),
        notes: exerciseGroup.notes.map((note) => note.copyWith()).toList(),
      )).toList(),
    );
  }

  // Helper method to create an ExerciseGroupDto from an Exercise
  ExerciseGroupDto _createExerciseGroup(Exercise exercise) {
    return ExerciseGroupDto(
      timer: exercise.timer,
      weightUnit: exercise.weightUnit,
      distanceUnit: exercise.distanceUnit,
      exerciseId: exercise.id!,
      barId: exercise.barId,
      routineId: blank,
      sets: [
        ExerciseSetDto(
          checked: false,
          type: ExerciseSetType.regular,
          exerciseGroupId: blank,
          data: exercise.fields.map((field) {
            return ExerciseSetDataDto(
              value: '',
              fieldType: field.type,
              exerciseSetId: blank,
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper method to create an ExerciseSetDto from an ExerciseGroupDto
  ExerciseSetDto _createExerciseSet(ExerciseGroupDto exerciseGroup) {
    return ExerciseSetDto(
      checked: false,
      type: ExerciseSetType.regular,
      exerciseGroupId: blank,
      data: exerciseGroup.sets.isNotEmpty
          ? exerciseGroup.sets.last.data.map((data) => data.copyWith()).toList()
          : [],
    );
  }
}

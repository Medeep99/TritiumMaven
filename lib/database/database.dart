import 'dart:async';
import 'dart:ui';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:maven/database/converter/exerciseSetDto_converter.dart';
import 'package:maven/database/converter/noteList_converter.dart';
import 'package:maven/feature/transfer/data/data.dart';
import 'package:maven/feature/user/screen/user_setup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../feature/theme/theme.dart';
import '../feature/transfer/transfer.dart';
import 'converter/converter.dart';
import 'data/data.dart';
import 'enum/enum.dart';
import 'table/table.dart';

export 'converter/converter.dart';
export 'data/data.dart';
export 'enum/enum.dart';
export 'service/service.dart';
export 'table/table.dart';

part 'database.g.dart';

@Database(
  version: 1,
  entities: [
    Bar,
    Exercise,
    ExerciseField,
    BaseExerciseGroup,
    BaseExerciseSet,
    BaseExerciseSetData,
    Plate,
    Program,
    ProgramExerciseGroup,
    ProgramFolder,
    ProgramTemplate,
    Settings,
    Routine,
    Note,
    WorkoutData,
    SessionData,
    TemplateData,
    User,
    Import,
    Export,
    AppTheme,
    AppThemeColor,
  ],
)
@TypeConverters([
  ExerciseSetListConverter,
  NoteListConverter,
  DateTimeConverter,
  ColorConverter,
  TimedConverter,
  LocaleConverter,
  SetTypeConverter,
  DurationConverter,
])
abstract class TritiumDatabase extends FloorDatabase {
  BarDao get barDao;
  ExerciseDao get exerciseDao;
  ExerciseGroupDao get baseExerciseGroupDao;
  ExerciseSetDao get exerciseSetDao;
  ExerciseSetDataDao get exerciseSetDataDao;
  ExerciseFieldDao get exerciseFieldDao;
  PlateDao get plateDao;
  ProgramDao get programDao;
  ProgramExerciseGroupDao get programExerciseGroupDao;
  ProgramFolderDao get programFolderDao;
  ProgramTemplateDao get programTemplateDao;
  RoutineDao get routineDao;
  SettingsDao get settingsDao;
  NoteDao get noteDao;
  WorkoutDataDao get workoutDataDao;
  SessionDataDao get sessionDataDao;
  TemplateDataDao get templateDataDao;
  UserDao get userDao;
  ImportDao get importDao;
  ExportDao get exportDao;
  AppThemeDao get themeDao;
  AppThemeColorDao get themeColorDao;

  static bool _isFirstTime = false;
  bool get isFirstTime => _isFirstTime;
  static changeFirstTimeForNewUser (){
    _isFirstTime=true;
  }
  // void deleteMyDatabase(){

  // };

  static final Callback _callback = Callback(
    onCreate: (database, version) {
      _isFirstTime = true;
    },
    onOpen: (database) {},
    onUpgrade: (database, startVersion, endVersion) {},
  );
  
  static Future<TritiumDatabase> initialize() async {
    TritiumDatabase db = await $FloorTritiumDatabase
        .databaseBuilder('TritiumDatabase.db')
        .addCallback(_callback)
        .build();
    if (_isFirstTime) {
      
      db.settingsDao.add(const Settings.empty());
      db.plateDao.addAll(getDefaultPlates());
      db.barDao.addAll(getDefaultBars());
      
      for (AppTheme theme in getDefaultAppThemes) {
        db.themeDao.add(theme);
        db.themeColorDao.add(theme.option.color);
      }
      for (Exercise exercise in getDefaultExercises()) {
        int exerciseId = await db.exerciseDao.add(exercise);
        for (ExerciseField field in exercise.fields) {
          db.exerciseFieldDao.add(field.copyWith(
            exerciseId: exerciseId,
          ));
          
        }
      } 
      //create a code to navigate to setup screen here
    }
    return db;
  }

}
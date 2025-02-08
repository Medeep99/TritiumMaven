import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:maven/feature/exercise/service/shared_preferences_service.dart';
import 'package:maven/feature/ml_model/calorie_manager.dart';
import 'package:maven/feature/user/services/shared_preferences_data.dart';

import '../../../../common/common.dart';
import '../../../../database/database.dart';
import '../../../exercise/exercise.dart';
import '../../../routine/routine.dart';
import '../../../transfer/transfer.dart';
import '../../../workout/workout.dart';
import '../../session.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required this.routineService,

    required this.databaseService,
    required this.calorieManager,

  }) : super(const SessionState()) {
    on<SessionInitialize>(_initialize);
    on<SessionAdd>(_add);
    on<SessionUpdate>(_update);
    on<SessionDelete>(_delete);
    on<SessionSetSort>(_setSort);
  }

  final RoutineService routineService;
  
  final DatabaseService databaseService;
  final CalorieManager calorieManager;

  Future<void> _initialize(SessionInitialize event,
      Emitter<SessionState> emit) async {
    emit(state.copyWith(
      status: SessionStatus.loaded,
      sessions: await routineService.getSessions(),
    ));
  }

  Future<void> _add(SessionAdd event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
      status: SessionStatus.loading,
    ));
    
    Session session = await routineService.addSession(event.workout);
    print('Print volueme:::::: ${session.volume}');
    
    final User currentUser = await databaseService.userDao.get()as User;
    double timeElapsed = (event.workout.data.timeElapsed.toSeconds()/60.0);
    await calorieManager.predictCalories(currentUser,timeElapsed, session.volume);

    emit(state.copyWith(
      status: SessionStatus.loaded,
      sessions: [session, ...state.sessions],
    ));
  }

  Future<void> _update(SessionUpdate event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
      status: SessionStatus.loading,
    ));

    await routineService.deleteRoutine(event.session.routine);

   
    add(SessionAdd(
      workout: Workout(
        routine: event.session.routine,
        exerciseGroups: event.session.exerciseGroups,
        data: WorkoutData(
          isActive: false,
          timeElapsed:  Timed.zero(),
          routineId: -1,
        ),),
    ),
      
    );
    
  }

  Future<void> _delete(SessionDelete event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
      status: SessionStatus.loading,
    ));

    await routineService.deleteRoutine(event.session.routine);

    emit(state.copyWith(
      status: SessionStatus.loaded,
      sessions: state.sessions.where((session) =>
      session.routine.id != event.session.routine.id).toList(),
    ));
  }

  Future<void> _setSort(SessionSetSort event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
      status: SessionStatus.loading,
    ));

    emit(state.copyWith(
      sessions: await routineService.getSessions(sort: event.sort),
      status: SessionStatus.loaded,
      sort: event.sort,
    ));
  }
}

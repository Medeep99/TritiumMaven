import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maven/database/clear_app_data.dart';
import 'package:maven/feature/template/template.dart';
import 'package:maven/feature/user/screen/user_edit_screen.dart';
import 'package:maven/feature/user/screen/user_setup_screen.dart';

import '../../../../database/database.dart';
import '../../../../main.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required this.userDao,
    required this.database,

  }) : super(const UserState()) {
    on<UserInitialize>(_initialize);
    on<UserUpdate>(_update);
    on<UserAdd>(_addUser); 
    on<UserDelete>(_deleteUser); // Added event to handle user data input
  }

  final UserDao userDao;
  final TritiumDatabase database;
  

  // Initialize the user by checking if data exists
  Future<void> _initialize(UserInitialize event, Emitter<UserState> emit) async {
    User? user = await userDao.get(); // Try to get the user data by id

    if (user == null) {
      // If no user is found, you may need to prompt for user data
      emit(state.copyWith(status: UserStatus.promptUserInput)); // Indicate the need for user input
    } else {
      emit(state.copyWith(
        status: UserStatus.loaded,
        user: user,
      ));
    }
  }

  // Handle updating user data
  Future<void> _update(UserUpdate event, Emitter<UserState> emit) async {
    await userDao.modify(event.user);

    emit(state.copyWith(
      status: UserStatus.loaded,
      user: event.user,
    ));
  }

  // Handle adding a new user (after user input is collected)
  Future<void> _addUser(UserAdd event, Emitter<UserState> emit) async {
    await userDao.add(event.user); // Store the user in the database

    emit(state.copyWith(
      status: UserStatus.loaded,
      user: event.user,
    ));
   
  }
   Future<void> _deleteUser(UserDelete event, Emitter<UserState> emit) async {
     try {

    // Perform the deletion from the database
    await userDao.remove(); // This will remove the user from the database
     // Close the database before performing the deletion
    await database.close();
    // Clear app data (database, shared preferences, and cache)
    await clearAppData();


    // Simulate a delay to ensure everything is cleared before exiting
    await Future.delayed(const Duration(seconds: 2));

    // Close the app
    SystemNavigator.pop();
    
    
    // Emit state to prompt for new user input
    emit(state.copyWith(status: UserStatus.promptUserInput, user: null));
  } catch (e) {
    // Log or handle any errors
    print("Error during user deletion: $e");
  }
  }
}

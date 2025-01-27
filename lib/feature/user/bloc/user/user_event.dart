
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserInitialize extends UserEvent {
  const UserInitialize();

  @override
  List<Object?> get props => [];
}

class UserUpdate extends UserEvent {
  const UserUpdate({
    required this.user,
  });

  final User user;

  @override
  List<Object?> get props => [
    user,
  ];
}

class UserPromptInput extends UserEvent { // New event for prompting user input
  const UserPromptInput();

  @override
  List<Object?> get props => [];
}

class UserAdd extends UserEvent { // New event for adding a new user
  final User user;

  const UserAdd(this.user);

  @override
  List<Object?> get props => [
    user,
  ];
}
class UserDelete extends UserEvent { // New event for deleting a user
  const UserDelete(userId);

  @override
  List<Object?> get props => [];
}
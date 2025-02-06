
part of 'user_bloc.dart';

// Enum for representing the various states of the user
enum UserStatus {
  loading,
  loaded,
  error,
  promptUserInput, // New status for prompting user input on first launch
}

extension UserStatusExtension on UserStatus {
  bool get isLoading => this == UserStatus.loading;
  bool get isLoaded => this == UserStatus.loaded;
  bool get isError => this == UserStatus.error;
  bool get isPromptUserInput => this == UserStatus.promptUserInput; // New check for prompting user input
}

class UserState extends Equatable {
  final UserStatus status;
  final User? user;

  const UserState({
    this.status = UserStatus.loading,
    this.user,
  });

  // Method to create a new UserState with updated values
  UserState copyWith({
    UserStatus? status,
    User? user,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
  ];
}

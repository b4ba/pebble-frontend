part of 'logged_user_bloc.dart';

abstract class LoggedUserState {
  const LoggedUserState();
}

class LoggedUserInitial extends LoggedUserState {}

class LoggedUserLoaded extends LoggedUserState {
  final Voter user;

  const LoggedUserLoaded({required this.user});
}

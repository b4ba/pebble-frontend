part of 'logged_user_bloc.dart';

abstract class LoggedUserEvent {
  const LoggedUserEvent();
}

class LoginLoggedUserEvent extends LoggedUserEvent {
  final String userId;

  const LoginLoggedUserEvent({required this.userId});
}

class ConfirmVoteLoggedUserEvent extends LoggedUserEvent {
  final Choice choice;
  final String id;

  const ConfirmVoteLoggedUserEvent({required this.choice, required this.id});
}

class JoinElectionLoggedUserEvent extends LoggedUserEvent {
  final String id;

  const JoinElectionLoggedUserEvent({required this.id});
}

class JoinOrganizationLoggedUserEvent extends LoggedUserEvent {
  final String organizationIdentifier;

  const JoinOrganizationLoggedUserEvent({required this.organizationIdentifier});
}

class LoadJoinedOrganizationsEvent extends LoggedUserEvent {
  final Organization organization;

  const LoadJoinedOrganizationsEvent({required this.organization});
}

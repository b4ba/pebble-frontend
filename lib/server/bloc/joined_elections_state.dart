part of 'joined_elections_bloc.dart';

abstract class JoinedElectionsState {
  const JoinedElectionsState();
}

class JoinedElectionsInitial extends JoinedElectionsState {}

class JoinedElectionsLoaded extends JoinedElectionsState {
  final Map<Election, ElectionStatusEnum> elections;

  const JoinedElectionsLoaded({required this.elections});
}

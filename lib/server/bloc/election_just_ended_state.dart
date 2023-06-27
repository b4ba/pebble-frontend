part of 'election_just_ended_bloc.dart';

abstract class ElectionJustEndedState extends Equatable {
  const ElectionJustEndedState();

  @override
  List<Object> get props => [];
}

class ElectionJustEndedInitial extends ElectionJustEndedState {}

class ElectionJustEndedLoaded extends ElectionJustEndedState {
  final Election election;
  final ElectionStatusEnum status;

  const ElectionJustEndedLoaded({required this.election, required this.status});

  @override
  List<Object> get props => [election];
}

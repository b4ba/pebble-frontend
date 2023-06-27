part of 'election_just_ended_bloc.dart';

abstract class ElectionJustEndedEvent extends Equatable {
  const ElectionJustEndedEvent();

  @override
  List<Object> get props => [];
}

class LoadElectionJustEnded extends ElectionJustEndedEvent {
  final List<Election> elections;

  const LoadElectionJustEnded({required this.elections});

  @override
  List<Object> get props => [elections];
}

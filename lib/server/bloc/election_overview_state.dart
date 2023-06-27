part of 'election_overview_bloc.dart';

abstract class ElectionOverviewState {
  const ElectionOverviewState();
}

class ElectionOverviewInitial extends ElectionOverviewState {}

class ElectionOverviewLoaded extends ElectionOverviewState {
  final Election election;
  final ElectionStatusEnum status;
  final String id;

  const ElectionOverviewLoaded({required this.election, required this.status, required this.id});
}

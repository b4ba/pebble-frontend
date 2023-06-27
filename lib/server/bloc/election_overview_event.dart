part of 'election_overview_bloc.dart';

abstract class ElectionOverviewEvent {
  const ElectionOverviewEvent();
}

class LoadElectionOverview extends ElectionOverviewEvent {
  final String id;
  final String userId;

  const LoadElectionOverview({
    required this.id,
    required this.userId,
  });
}

class ChangeElectionOverview extends ElectionOverviewEvent {
  final Election election;
  final ElectionStatusEnum status;

  const ChangeElectionOverview({required this.election, required this.status});
}

class RefreshElectionOverview extends ElectionOverviewEvent {
  final String id;
  final String userId;

  const RefreshElectionOverview({
    required this.id,
    required this.userId,
  });
}

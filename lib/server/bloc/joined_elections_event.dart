part of 'joined_elections_bloc.dart';

abstract class JoinedElectionsEvent {
  const JoinedElectionsEvent();

  // const JoinedElectionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadJoinedElection extends JoinedElectionsEvent {
  final Voter user;

  // const LoadJoinedElection();
  const LoadJoinedElection({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateStatusJoinedElection extends JoinedElectionsEvent {
  final Election election;
  final ElectionStatusEnum status;

  const UpdateStatusJoinedElection(
      {required this.election, required this.status});
}

// class RemoveJoinedElection extends JoinedElectionsEvent {
//   final Election election;

//   const RemoveJoinedElection(this.election);

//   @override
//   List<Object> get props => [election];
// }

// events.dart
import 'package:ecclesia_ui/data/models/election_model.dart';

abstract class ElectionEvent {}

class AddElection extends ElectionEvent {
  final Election election;

  AddElection(this.election);
}

class RemoveElection extends ElectionEvent {
  final String electionId;

  RemoveElection(this.electionId);
}

// states.dart
abstract class ElectionState {}

class ElectionInitial extends ElectionState {}

class ElectionLoaded extends ElectionState {
  final List<Election> elections;

  ElectionLoaded(this.elections);
}

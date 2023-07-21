import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/voter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// election_bloc.dart

import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ElectionEvent {}

class LoadJoinedElectionEvent extends ElectionEvent {
  final Voter user;

  LoadJoinedElectionEvent({required this.user});
}

class AddElectionEvent extends ElectionEvent {
  final Election election;

  AddElectionEvent({required this.election});
}

class RemoveElectionEvent extends ElectionEvent {
  final String electionId;

  RemoveElectionEvent({required this.electionId});
}

// States
abstract class ElectionState {}

class ElectionInitial extends ElectionState {}

class ElectionLoaded extends ElectionState {
  final List<Election> elections;

  ElectionLoaded(this.elections);
}

// Bloc
class ElectionBloc extends Bloc<ElectionEvent, ElectionState> {
  ElectionBloc() : super(ElectionInitial());

  @override
  Stream<ElectionState> mapEventToState(ElectionEvent event) async* {
    if (event is LoadJoinedElectionEvent) {
      // Fetch the initial list of joined elections here
      // You can use the provided user object to get the relevant data
      final List<Election> joinedElections =
          []; // Implement your logic to fetch joined elections

      yield ElectionLoaded(joinedElections);
    } else if (event is AddElectionEvent) {
      // Retrieve the current state
      final currentState = state;

      if (currentState is ElectionLoaded) {
        // Add the new election to the existing list
        final updatedElections = List.from(currentState.elections)
          ..add(event.election);

        final updatedElectionList = updatedElections.map((dynamic election) {
          // Assuming the Election.fromJson method is available, use it to convert each dynamic element to Election
          return Election.fromJson(election);
        }).toList();

        // Emit the updated state
        yield ElectionLoaded(updatedElectionList);
      }
    } else if (event is RemoveElectionEvent) {
      // Retrieve the current state
      final currentState = state;

      if (currentState is ElectionLoaded) {
        // Remove the election with the specified ID
        final updatedElections = currentState.elections
            .where((election) => election.id != event.electionId)
            .toList();

        // Emit the updated state
        yield ElectionLoaded(updatedElections);
      }
    }
  }
}


// // class ElectionBloc extends Bloc<ElectionEvent, ElectionState> {
//   FlutterSecureStorage storage = FlutterSecureStorage();
// //   ElectionBloc() : super(ElectionInitial());

//   Future<int> fetchIdFromStorage() async {
//     String? id = await storage.read(key: 'latestElectionId');
//     try {
//       return int.parse(id!);
//     } catch (e) {
//       return -1;
//     }
//   }

//   Future<Election> _assignIdToElection(Election election) async {
//     final int uniqueId = await fetchIdFromStorage();
//     if (uniqueId == -1) {
//       // print error accessing secure storage
//     }
//     await storage.write(
//         key: 'latestElectionId', value: (uniqueId + 1).toString());
//     return Election(
//       id: uniqueId.toString(),
//       title: election.title,
//       description: election.description,
//       organization: election.organization,
//       startTime: election.startTime,
//       endTime: election.endTime,
//       choices: election.choices,
//     );
//   }

//   @override
//   Stream<ElectionState> mapEventToState(ElectionEvent event) async* {
//     if (event is AddElection) {
//       // Retrieve the current state
//       final currentState = state;

//       if (currentState is ElectionLoaded) {
//         // Add the new election to the existing list
//         final updatedElections = List.from(currentState.elections)
//           ..add(await _assignIdToElection(event.election));

//         if (currentState is ElectionLoaded) {
//           final updatedElections = currentState.elections
//               .where((election) => election.id != event.election.id)
//               .toList();
//           // Emit the updated state
//           yield ElectionLoaded(updatedElections);
//         }
//       }
//     } else if (event is RemoveElection) {
//       // Retrieve the current state
//       final currentState = state;

//       if (currentState is ElectionLoaded) {
//         // Remove the election with the specified ID
//         final updatedElections = currentState.elections
//             .where((election) => election.id != event.electionId)
//             .toList();

//         // Emit the updated state
//         yield ElectionLoaded(updatedElections);
//       }
//     }
//   }
// }

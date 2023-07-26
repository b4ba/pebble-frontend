import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/voter_model.dart';
import 'package:ecclesia_ui/services/get_election_status.dart';
import 'package:ecclesia_ui/services/isar_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'election_overview_event.dart';
part 'election_overview_state.dart';

class ElectionOverviewBloc
    extends Bloc<ElectionOverviewEvent, ElectionOverviewState> {
  ElectionOverviewBloc() : super(ElectionOverviewInitial()) {
    on<LoadElectionOverview>((event, emit) async {
      //event.id needs to be the invitation id
      // final user = Voter.voters[int.parse(event.userId)];
      final isarService = IsarService();
      final election = await isarService.getElectionByInvitationId(event.id);
      if (election != null) {
        final choices = await isarService.getChoicesFor(election.invitationId);
        final status = getElectionStatus(election.startTime, election.endTime);
        emit(ElectionOverviewLoaded(
            election: election,
            status: status,
            id: event.id,
            choices: choices));
      } else {
        // Handle the case when the election is not found in the Isar database.
        print('election not found :(');
      }
    });
    on<RefreshElectionOverview>((event, emit) async {
      final user = Voter.voters[int.parse(event.userId)];
      final isarService = IsarService();
      final election = await isarService.getElectionByInvitationId(event.id);
      if (election != null) {
        final choices = await isarService.getChoicesFor(election.invitationId);
        final status = getElectionStatus(election.startTime, election.endTime);
        emit(ElectionOverviewLoaded(
            election: election,
            status: status,
            id: event.id,
            choices: choices));
      } else {
        // Handle the case when the election is not found in the Isar database.
        print('election not found :(');
      }
    });

    //   on<LoadElectionOverview>((event, emit) async {
    //     // await Future<void>.delayed(const Duration(seconds: 2));
    //     // Fetch the election data from the Isar database
    //     final election = await IsarService().getElectionByInvitationId(event.id);

    //     // Check if the election data was fetched successfully
    //     if (election != null) {
    //       // Emit a new state with the fetched election data
    //       emit(ElectionOverviewLoaded(
    //           election: election,
    //           status: getElectionStatus(election.startTime, election.endTime),
    //           id: event.id));
    //     } else {
    //       // Emit an error state if the election data could not be fetched
    //       // emit(ElectionOverviewError());
    //     }

    //   final user = Voter.voters[int.parse(event.userId)];

    //   if (state is ElectionOverviewLoaded) {
    //     final state = this.state as ElectionOverviewLoaded;

    //     if (state.id != event.id) {
    //       int id = int.parse(event.id);
    //       Election election = Election.elections[id];
    //       ElectionStatusEnum status = user.joinedElections[election]!;
    //       emit(ElectionOverviewLoaded(
    //           election: election, status: status, id: event.id));
    //     } else {
    //       emit(ElectionOverviewLoaded(
    //           election: state.election, status: state.status, id: event.id));
    //     }
    //   } else {
    //     int id = int.parse(event.id);
    //     Election election = Election.elections[id];
    //     ElectionStatusEnum status = user.joinedElections[election]!;
    //     emit(ElectionOverviewLoaded(
    //         election: election, status: status, id: event.id));
    //   }
    // });
    on<ChangeElectionOverview>((event, emit) async {
      // final state = this.state as ElectionOverviewLoaded;
      emit(ElectionOverviewLoaded(
          election: event.election,
          choices:
              await IsarService().getChoicesFor(event.election.invitationId),
          status: event.status,
          id: event.election.id.toString()));
    });
    // on<RefreshElectionOverview>((event, emit) {
    //   final user = Voter.voters[int.parse(event.userId)];
    //   int id = int.parse(event.id);
    //   Election election = Election.elections[id];
    //   ElectionStatusEnum status = user.joinedElections[election]!;
    //   emit(ElectionOverviewLoaded(
    //       election: election, status: status, id: event.id));
    // });
  }
}

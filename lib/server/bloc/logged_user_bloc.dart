import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:ecclesia_ui/data/models/voter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/isar_services.dart';

part 'logged_user_event.dart';
part 'logged_user_state.dart';

class LoggedUserBloc extends Bloc<LoggedUserEvent, LoggedUserState> {
  LoggedUserBloc() : super(LoggedUserInitial()) {
    on<LoginLoggedUserEvent>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 4));

      final Voter user =
          Voter.voters[int.parse(event.userId)]; // User can be changed here
      emit(LoggedUserLoaded(user: user));
    });
    on<ConfirmVoteLoggedUserEvent>((event, emit) {
      if (state is LoggedUserLoaded) {
        final state = this.state as LoggedUserLoaded;
        final Voter user = state.user;
        final Election election = Election.elections[int.parse(event.id)];

        user.votedChoices[election] = event.choice;
        emit(LoggedUserLoaded(user: user));
      }
    });
    on<JoinElectionLoggedUserEvent>((event, emit) async {
      if (state is LoggedUserLoaded) {
        final state = this.state as LoggedUserLoaded;
        state.user.joinedElections[Election.elections[int.parse(event.id)]] =
            ElectionStatusEnum.voteOpen;
        emit(LoggedUserLoaded(user: state.user));

        await Future<void>.delayed(const Duration(seconds: 10));
        state.user.joinedElections[Election.elections[int.parse(event.id)]] =
            ElectionStatusEnum.voteNotOpen;
        emit(LoggedUserLoaded(user: state.user));

        await Future<void>.delayed(const Duration(seconds: 10));
        state.user.joinedElections[Election.elections[int.parse(event.id)]] =
            ElectionStatusEnum.voteOpen;
        emit(LoggedUserLoaded(user: state.user));
      }
    });
    on<JoinOrganizationLoggedUserEvent>((event, emit) {
      if (state is LoggedUserLoaded) {
        final state = this.state as LoggedUserLoaded;
        state.user.joinedOrganizations[event.organizationIdentifier] =
            Organization.organizations[int.parse(event.organizationIdentifier)];
        emit(LoggedUserLoaded(user: state.user));
      }
    });
    on<LoadJoinedOrganizationsEvent>((event, emit) async {
      final isarService = IsarService();
      final organizations = await isarService.getAllOrganizations();
      if (organizations != null) {
        emit(OrganizationsLoaded(organizations: organizations));
      } else {
        // Handle the case when the organizations are no found in the Isar database.
        print('organizations could not be loaded');
      }
    });
  }
}

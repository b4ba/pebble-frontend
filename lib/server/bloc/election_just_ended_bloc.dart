import 'package:bloc/bloc.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:ecclesia_ui/data/models/voter_model.dart';
import 'package:equatable/equatable.dart';

part 'election_just_ended_event.dart';
part 'election_just_ended_state.dart';

class ElectionJustEndedBloc extends Bloc<ElectionJustEndedEvent, ElectionJustEndedState> {
  ElectionJustEndedBloc() : super(ElectionJustEndedInitial()) {
    on<LoadElectionJustEnded>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 2));
      ElectionStatusEnum status = Voter.voters[1].joinedElections[event.elections[0]]!;
      emit(ElectionJustEndedLoaded(election: event.elections[0], status: status));
    });
  }
}

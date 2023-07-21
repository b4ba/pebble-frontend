// election_detail_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ElectionDetailEvent {}

// States
abstract class ElectionDetailState {}

class InitialElectionDetailState extends ElectionDetailState {}

// Bloc
class ElectionDetailBloc
    extends Bloc<ElectionDetailEvent, ElectionDetailState> {
  ElectionDetailBloc() : super(InitialElectionDetailState());

  @override
  Stream<ElectionDetailState> mapEventToState(
      ElectionDetailEvent event) async* {
    // Implement event-to-state mapping if needed
  }
}

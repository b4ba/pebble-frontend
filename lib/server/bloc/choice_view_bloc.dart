import 'package:bloc/bloc.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';

part 'choice_view_event.dart';
part 'choice_view_state.dart';

class ChoiceViewBloc extends Bloc<ChoiceViewEvent, ChoiceViewState> {
  ChoiceViewBloc() : super(ChoiceViewInitial()) {
    on<LoadChoiceView>((event, emit) {
      final int electionId = int.parse(event.electionId);
      final int choiceId = int.parse(event.choiceId);
      final Choice choice = Election.elections[electionId].choices[choiceId];

      emit(ChoiceViewLoaded(choice: choice));
    });
  }
}

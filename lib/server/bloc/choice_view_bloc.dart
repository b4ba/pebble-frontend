import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/services/isar_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choice_view_event.dart';
part 'choice_view_state.dart';

class ChoiceViewBloc extends Bloc<ChoiceViewEvent, ChoiceViewState> {
  ChoiceViewBloc() : super(ChoiceViewInitial()) {
    on<LoadChoiceView>((event, emit) async {
      final allChoices = await IsarService().getChoicesFor(event.electionId);
      final electionChoices =
          allChoices.where((choice) => choice.invitationId == event.electionId);
      final choice =
          electionChoices.firstWhere((choice) => choice.title == event.title);
      emit(ChoiceViewLoaded(choice: choice));
    });
  }
}

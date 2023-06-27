import 'package:bloc/bloc.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';

part 'picked_choice_event.dart';
part 'picked_choice_state.dart';

class PickedChoiceBloc extends Bloc<PickedChoiceEvent, PickedChoiceState> {
  PickedChoiceBloc() : super(PickedChoiceInitial()) {
    on<ChoosePickedChoice>((event, emit) {
      emit(PickedChoiceLoaded(choice: event.choice));
    });
  }
}

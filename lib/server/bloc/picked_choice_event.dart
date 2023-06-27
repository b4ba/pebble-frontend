part of 'picked_choice_bloc.dart';

abstract class PickedChoiceEvent {
  const PickedChoiceEvent();
}

class ChoosePickedChoice extends PickedChoiceEvent {
  final Choice choice;

  const ChoosePickedChoice({required this.choice});
}

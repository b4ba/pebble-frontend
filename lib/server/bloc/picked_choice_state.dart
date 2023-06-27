part of 'picked_choice_bloc.dart';

abstract class PickedChoiceState {
  const PickedChoiceState();
}

class PickedChoiceInitial extends PickedChoiceState {}

class PickedChoiceLoaded extends PickedChoiceState {
  final Choice choice;

  const PickedChoiceLoaded({required this.choice});
}

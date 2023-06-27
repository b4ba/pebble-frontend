part of 'choice_view_bloc.dart';

abstract class ChoiceViewState {
  const ChoiceViewState();
}

class ChoiceViewInitial extends ChoiceViewState {}

class ChoiceViewLoaded extends ChoiceViewState {
  final Choice choice;

  const ChoiceViewLoaded({required this.choice});
}

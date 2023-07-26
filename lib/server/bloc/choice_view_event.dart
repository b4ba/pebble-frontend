part of 'choice_view_bloc.dart';

abstract class ChoiceViewEvent {
  const ChoiceViewEvent();
}

class LoadChoiceView extends ChoiceViewEvent {
  final String title;
  final String electionId;
  final String userId;

  const LoadChoiceView(
      {required this.title, required this.electionId, required this.userId});
}

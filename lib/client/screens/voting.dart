import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_container.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/client/widgets/custom_radio_list_tile.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:ecclesia_ui/server/bloc/election_overview_bloc.dart';
import 'package:ecclesia_ui/server/bloc/joined_elections_bloc.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:ecclesia_ui/server/bloc/picked_choice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Screen for the voting process

class Voting extends StatefulWidget {
  final String id;
  final String userId;
  const Voting({Key? key, required this.id, required this.userId}) : super(key: key);

  @override
  State<Voting> createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  bool hasChosen = false;
  String _chosenOptions = "";
  Choice selectedChoice = Choice.noVote;

  void changeSelection(value, choice) {
    setState(() {
      _chosenOptions = value;
      selectedChoice = choice;
    });

    context.read<PickedChoiceBloc>().add(ChoosePickedChoice(choice: choice));
  }

  void chooseSelection() {
    if (_chosenOptions != "") {
      setState(() {
        hasChosen = true;
      });
    }
  }

  void removeSelection() {
    setState(() {
      hasChosen = false;
      _chosenOptions = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<ElectionOverviewBloc>(context),
        ),
        BlocProvider.value(
          value: BlocProvider.of<PickedChoiceBloc>(context),
        ),
        BlocProvider.value(
          value: BlocProvider.of<JoinedElectionsBloc>(context),
        ),
        BlocProvider.value(
          value: BlocProvider.of<LoggedUserBloc>(context),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 248, 250),
        appBar: const CustomAppBar(
          back: true,
          disableBackGuard: false,
          disableMenu: true,
        ),
        endDrawer: const CustomDrawer(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: hasChosen ? true : false,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
                  builder: (context, state) {
                    if (state is ElectionOverviewLoaded) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<ElectionOverviewBloc>().add(ChangeElectionOverview(election: state.election, status: ElectionStatusEnum.castingBallot));
                          context.read<JoinedElectionsBloc>().add(UpdateStatusJoinedElection(election: state.election, status: ElectionStatusEnum.voted));
                          context.read<LoggedUserBloc>().add(ConfirmVoteLoggedUserEvent(choice: selectedChoice, id: widget.id));

                          context.go("/election-detail/${widget.id}/${widget.userId}/voting/voting-casted");
                          debugPrint('Confirm ballot! with id ${widget.id}');
                        },
                        child: const Text('I cast my vote!'),
                      );
                    } else {
                      return const Text("Something is wrong");
                    }
                  },
                ),
              ),
              _chosenOptions == ""
                  ? const DisabledButton()
                  : ElevatedButton(
                      onPressed: hasChosen ? removeSelection : chooseSelection,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(hasChosen ? Colors.black : Colors.blue),
                      ),
                      child: Text(hasChosen ? 'No, I change my mind' : 'I choose this'),
                    ),
            ],
          ),
        ),
        body: Center(
          child: CustomContainer(
            child: hasChosen
                ? const VoteConfirmation()
                : VotingPicker(
                    chosenOption: _chosenOptions,
                    changeSelection: changeSelection,
                  ),
          ),
        ),
      ),
    );
  }
}

class DisabledButton extends StatelessWidget {
  const DisabledButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey),
      ),
      child: const Text(
        'I choose this',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

// Prompt to ask the user if the selected choice is correct before submitting
class VoteConfirmation extends StatelessWidget {
  const VoteConfirmation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: Text('You chose:')),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: BlocBuilder<PickedChoiceBloc, PickedChoiceState>(
              builder: (context, state) {
                if (state is PickedChoiceInitial) {
                  return const CircularProgressIndicator(color: Colors.blue);
                } else if (state is PickedChoiceLoaded) {
                  return Text(
                    state.choice.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  );
                } else {
                  return const Text("There is something wrong!");
                }
              },
            ),
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'Once you cast your vote, this action is ',
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: 'irreversible',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: '. You can go back and '),
              TextSpan(
                text: 'change',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: ' your choice '),
              TextSpan(
                text: 'now',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: '.'),
            ],
          ),
        ),
      ],
    );
  }
}

class VotingPicker extends StatelessWidget {
  final String chosenOption;
  final Function changeSelection;

  const VotingPicker({
    required this.chosenOption,
    required this.changeSelection,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
      builder: (context, state) {
        if (state is ElectionOverviewInitial) {
          return const CircularProgressIndicator(color: Colors.blue);
        } else if (state is ElectionOverviewLoaded) {
          return Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(children: [
                  const Text('Select your choice to vote for:'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    state.election.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: state.election.choices.length,
                    itemBuilder: (_, index) {
                      Choice choice = state.election.choices[index];
                      return CustomRadioListTile(
                        choice: choice,
                        value: choice.id,
                        groupValue: chosenOption,
                        onChanged: (value, choice) {
                          // debugPrint(value);
                          changeSelection(value, choice);
                        },
                        leading: Icons.close,
                        title: Text(
                          choice.title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      );
                    }),
              ),
            ],
          );
        } else {
          return const Text('Something is wrong');
        }
      },
    );
  }
}

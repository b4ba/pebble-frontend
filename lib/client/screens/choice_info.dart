import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/server/bloc/choice_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screen to present more details of a choice/candidate in an election/voting

class ChoiceInfo extends StatelessWidget {
  final String choiceId;
  final String id;
  final String userId;
  const ChoiceInfo({Key? key, required this.choiceId, required this.id, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ChoiceViewBloc>(context)..add(LoadChoiceView(choiceId: choiceId, electionId: id, userId: userId)),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 248, 250),
        appBar: const CustomAppBar(back: true, disableBackGuard: true, disableMenu: false),
        endDrawer: const CustomDrawer(),
        body: Center(
          child: BlocBuilder<ChoiceViewBloc, ChoiceViewState>(
            builder: (context, state) {
              if (state is ChoiceViewInitial) {
                return const CircularProgressIndicator(color: Colors.blue);
              } else if (state is ChoiceViewLoaded) {
                return InfoContainer(choice: state.choice);
              } else {
                return const Text('There is something wrong');
              }
            },
          ),
        ),
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final Choice choice;
  const InfoContainer({
    required this.choice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 211, 211, 211).withOpacity(0.5), //color of shadow
              spreadRadius: 3, //spread radius
              blurRadius: 7, // blur radius
              offset: const Offset(0, 6)),
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name of the choice
            Text(choice.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 15,
            ),
            // Description of the choide
            Text(
              choice.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}

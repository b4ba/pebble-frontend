import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Screen to prompt user whether their intended organization/election
// to be joined is correct.

class JoinConfirmation extends StatelessWidget {
  final bool isElection;

  const JoinConfirmation({Key? key, required this.isElection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<LoggedUserBloc>(context),
      child: Scaffold(
        appBar: const CustomAppBar(back: true, disableBackGuard: true, disableMenu: false),
        endDrawer: const CustomDrawer(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: This is hard-coded
                  if (isElection) {
                    context.read<LoggedUserBloc>().add(const JoinElectionLoggedUserEvent(id: '4'));
                    context.go('/register-election/confirmation/confirmed');
                  } else {
                    context.read<LoggedUserBloc>().add(const JoinOrganizationLoggedUserEvent(organizationId: '3'));
                    context.go('/register-organization/confirmation/confirmed');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text(
                  'Yes, I want to join!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: const Text(
                  'No, I change my mind',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(255, 211, 211, 211).withOpacity(0.5), //color of shadow
                  spreadRadius: 3, //spread radius
                  blurRadius: 7, // blur radius
                  offset: const Offset(0, 6)),
            ]),
            child: isElection ? const JoinElectionConfirmation() : const JoinOrganizationConfirmation(),
          ),
        ),
      ),
    );
  }
}

// Prompt message to confirm from the user of intended election
// to join
class JoinElectionConfirmation extends StatelessWidget {
  const JoinElectionConfirmation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Text(
          'You are joining the election:',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Edinburgh Baking Society',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Club social',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Are you sure?',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Prompt message to confirm from the user of intended organization
// to join
class JoinOrganizationConfirmation extends StatelessWidget {
  const JoinOrganizationConfirmation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Text(
          'You are joining the organization:',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Edinburgh University Students\' Union (EUSU)',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Are you sure?',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

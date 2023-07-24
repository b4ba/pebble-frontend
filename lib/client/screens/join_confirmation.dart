import 'dart:convert';

import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:ecclesia_ui/services/isar_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Screen to prompt user whether their intended organization/election
// to be joined is correct.

class JoinConfirmation extends StatelessWidget {
  final bool isElection;
  final String inputCode;

  const JoinConfirmation(
      {Key? key, required this.isElection, required this.inputCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IsarService isarService = IsarService();

    return BlocProvider.value(
      value: BlocProvider.of<LoggedUserBloc>(context),
      child: Scaffold(
        appBar: const CustomAppBar(
            back: true, disableBackGuard: true, disableMenu: false),
        endDrawer: const CustomDrawer(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (isElection) {
                    final response = await http.get(Uri.parse(
                        'http://localhost:8080/api/election/info/$inputCode'));
                    final data = jsonDecode(response.body);

                    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
                    List<Choice> choices = data['choices']
                        .map<Choice>((choice) => Choice(
                              title: choice.toString(),
                              description: '$choice description',
                              numberOfVote: 0,
                            ))
                        .toList();

                    final elec = Election(
                        title: data['title'],
                        description: data['description'],
                        organization: 'organization',
                        startTime: format.parse((data['castStart'])),
                        endTime: format.parse((data['tallyStart'])));

                    isarService.addElection(elec);
                    // context
                    //     .read<LoggedUserBloc>()
                    //     .add(const JoinElectionLoggedUserEvent(id: '4'));
                    context.go('/register-election/confirmation/confirmed');
                  } else {
                    print('hi');
                    // context.read<LoggedUserBloc>().add(
                    //     const JoinOrganizationLoggedUserEvent(
                    //         organizationId: '3'));
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
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromARGB(255, 211, 211, 211)
                          .withOpacity(0.5), //color of shadow
                      spreadRadius: 3, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 6)),
                ]),
            child: isElection
                ? JoinElectionConfirmation(
                    inputCode: inputCode,
                  )
                : const JoinOrganizationConfirmation(),
          ),
        ),
      ),
    );
  }
}

// Prompt message to confirm from the user of intended election
// to join
class JoinElectionConfirmation extends StatelessWidget {
  final String inputCode;

  const JoinElectionConfirmation({super.key, required this.inputCode});

  Future<String?> _getElectionToJoin() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/election/info/$inputCode'));
    // final data = jsonDecode(response.body);
    return response.body;
    // DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    // List<Choice> choices = data['choices']
    //     .map<Choice>((choice) => Choice(
    //           title: choice.toString(),
    //           description: '$choice description',
    //           numberOfVote: 0,
    //         ))
    //     .toList();

    // final elec = Election(
    //     title: data['title'],
    //     description: data['description'],
    //     organization: 'organization',
    //     startTime: format.parse((data['castStart'])),
    //     endTime: format.parse((data['tallyStart'])));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getElectionToJoin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error fetching data');
        } else {
          final electionJson = snapshot.data;

          if (electionJson != null) {
            // Convert the JSON string back to Election object
            Election storedElection =
                Election.fromJson(jsonDecode(electionJson));

            // Use the stored Election object as needed
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'You are joining the election:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  storedElection.organization.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  storedElection.title.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 25),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            // Return your widget tree when no election data is available
            return const NoDataWidget();
          }
        }
      },
    );
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No data available',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
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
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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

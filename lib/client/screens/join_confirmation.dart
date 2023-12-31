import 'dart:convert';

import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
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
  final String electionId;

  const JoinConfirmation(
      {Key? key, required this.isElection, required this.electionId})
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
                        'http://localhost:8080/api/election/join/$electionId'));
                    if (response.statusCode == 200) {
                      final elecInfoResponse = await http.get(Uri.parse(
                          'http://localhost:8080/api/election/info/$electionId'));
                      //fetch election data & add election to db
                      final data = jsonDecode(elecInfoResponse.body);

                      DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

                      final elec = Election(
                          title: data['title'],
                          description: data['description'],
                          organization: 'organization',
                          startTime: format.parse((data['castStart'])),
                          endTime: format.parse((data['tallyStart'])),
                          invitationId: electionId);

                      List<Choice> choices = data['choices']
                          .map<Choice>((choice) => Choice(
                                title: choice.toString(),
                                description: '$choice description',
                                numberOfVote: 0,
                                invitationId: elec.invitationId,
                              ))
                          .toList();
                      isarService.addElection(elec);
                      for (var choice in choices) {
                        isarService.addChoice(choice);
                      }
                      context.go(
                          '/register-election/confirmed/${elec.invitationId}');
                    } else {
                      print('ERROR JOINING ELECTION');
                      context.go('/');
                      return;
                    }
                  } else {
                    const storage = FlutterSecureStorage();
                    final publicKey = await storage.read(key: 'publicKey');
                    final jsonData = jsonEncode({'pk': publicKey});

                    final org = await isarService
                        .getOrganizationByIdentifier(electionId);
                    if (org != null) {
                      try {
                        final response = await http.post(
                          Uri.parse(org.url),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonData,
                        );
                        if (response.statusCode == 200) {
                          context.go(
                              '/register-organization/confirmed/${org.identifier}');
                        } else if (response.statusCode == 400) {
                          if (response.body ==
                              'Public key has already been added') {
                            context.go('/joined-organization');
                          } else {
                            context.go('/no-data');
                          }
                        } else {
                          print('ERROR JOINING ORGANIZATION');
                          context.go('/no-data');
                        }
                      } catch (e) {
                        // Exception occurred during the request, handle the error here if needed
                        context.go('/');
                        print('Error: $e');
                      }
                    } else {
                      print('Error joining organization: org not found in db');
                      context.go('/');
                      return;
                    }
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
                  IsarService().deleteOrganization(electionId);
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
                    electionId: electionId,
                  )
                : JoinOrganizationConfirmation(id: electionId),
          ),
        ),
      ),
    );
  }
}

// Prompt message to confirm from the user of intended election
// to join
class JoinElectionConfirmation extends StatelessWidget {
  final String electionId;

  const JoinElectionConfirmation({super.key, required this.electionId});

  Future<Election> _getElectionToJoin() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/election/info/$electionId'));
    final electionData = jsonDecode(response.body);

    if (electionData != null) {
      DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

      final elec = Election(
        title: electionData['title'],
        description: electionData['description'],
        organization: 'organization',
        startTime: format.parse((electionData['castStart'])),
        endTime: format.parse((electionData['tallyStart'])),
        invitationId: electionId,
      );

      return elec;
    }
    print('data is null');
    return Election(
        title: 'title',
        description: 'description',
        organization: 'organization',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        invitationId: electionId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Election?>(
        future: _getElectionToJoin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('Error fetching data');
          } else {
            if (snapshot.data != null) {
              final election = snapshot.data;

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
                    election!.organization.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    election.title.toString(),
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
              return const NoDataWidget();
            }
          }
        });
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
  final String id;

  const JoinOrganizationConfirmation({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Organization?>(
        future: IsarService().getOrganizationByIdentifier(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            if (snapshot.data != null) {
              final election = snapshot.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Attempting to register you to the organization',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    election!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 25),
                  ),
                  const Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else {
              return const NoDataWidget();
            }
          }
        });
  }
}

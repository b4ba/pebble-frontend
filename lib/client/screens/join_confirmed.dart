import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_circular_progress.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/isar_services.dart';

// Screen to show the status of the user's registeration to an
// organization/election

class JoinConfirmed extends StatefulWidget {
  final bool isElection;
  final String identifier;
  const JoinConfirmed(
      {Key? key, required this.isElection, required this.identifier})
      : super(key: key);

  @override
  State<JoinConfirmed> createState() => _JoinConfirmedState();
}

class _JoinConfirmedState extends State<JoinConfirmed> {
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          back: false, disableBackGuard: true, disableMenu: false),
      endDrawer: const CustomDrawer(),
      bottomNavigationBar: !hasLoaded
          ? null
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: const Text('Go back home'),
                  ),
                ],
              ),
            ),
      body: Center(
        child: !hasLoaded
            ? CustomCircularProgress(
                description: widget.isElection
                    ? "Joining the election"
                    : "Joining the organization")
            : Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 20.0),
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
                child: widget.isElection
                    ? JoinElectionPending(invitationId: widget.identifier)
                    : JoinOrganizationConfirmed(
                        organizationIdentifier: widget.identifier),
              ),
      ),
    );
  }
}

// Custom widget to show message on confirmation of joining
// an organization
class JoinOrganizationConfirmed extends StatelessWidget {
  final String organizationIdentifier;

  const JoinOrganizationConfirmed({
    super.key,
    required this.organizationIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    IsarService isarService = IsarService();
    return FutureBuilder<Organization?>(
        future: isarService.getOrganizationByIdentifier(organizationIdentifier),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            final org = snapshot.data;
            if (org != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your current status on joining',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    org.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: const Text('Successful!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You are now eligible to join election(s) by this organization.',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else {
              return const Column(children: [
                Text('Error retrieving joined organization data'),
                Text('Sorry'),
              ]);
            }
          }
        });
  }
}

// Custom widget to show message on confirmation of joining
// an election
class JoinElectionPending extends StatelessWidget {
  final String invitationId;
  const JoinElectionPending({super.key, required this.invitationId});

  @override
  Widget build(BuildContext context) {
    IsarService isarService = IsarService();
    return FutureBuilder<Election?>(
        future: isarService.getElectionByInvitationId(invitationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            final electionJson = snapshot.data;
            if (electionJson != null) {
              Election storedElection = electionJson;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.av_timer_rounded,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your current status on joining the election:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    storedElection.organization.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    storedElection.title.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: const Text('Registering your details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(height: 10),
                  //DO WE WANT?
                  // const Text(
                  //   'We will send you an email to notify if you have been successfully registered',
                  //   textAlign: TextAlign.center,
                  // ),
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

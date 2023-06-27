import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_circular_progress.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screen to show the status of the user's registeration to an
// organization/election
// DEV NOTE: At the moment it is hard-coded

class JoinConfirmed extends StatefulWidget {
  final bool isElection;
  const JoinConfirmed({Key? key, required this.isElection}) : super(key: key);

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
      appBar: const CustomAppBar(back: false, disableBackGuard: true, disableMenu: false),
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
                      // debugPrint("Going to election detail with id ");
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
            ? CustomCircularProgress(description: widget.isElection ? "Joining the election" : "Joining the organization")
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), boxShadow: [
                  BoxShadow(
                      color: const Color.fromARGB(255, 211, 211, 211).withOpacity(0.5), //color of shadow
                      spreadRadius: 3, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 6)),
                ]),
                child: widget.isElection ? const JoinElectionPending() : const JoinOrganizationConfirmed(),
              ),
      ),
    );
  }
}

// Custom widget to show message on confirmation of joining
// an organization
class JoinOrganizationConfirmed extends StatelessWidget {
  const JoinOrganizationConfirmed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        // TODO: This is hard-coded
        const Text(
          'Edinburgh University Students\' Association (EUSA)',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
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
  }
}

// Custom widget to show message on confirmation of joining
// an election
class JoinElectionPending extends StatelessWidget {
  const JoinElectionPending({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        const Text(
          'Edinburgh Baking Society',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        const Text(
          'Club Social',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
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
        const Text(
          'We will send you an email to notify if you have been successfully registered',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

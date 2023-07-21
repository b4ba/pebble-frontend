import 'package:ecclesia_ui/client/widgets/custom_circular_progress.dart';
import 'package:ecclesia_ui/server/bloc/election_join_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinElectionPending extends StatelessWidget {
  final String invitationKey;

  JoinElectionPending({required this.invitationKey});

  void _joinElection(BuildContext context) {
    final bloc = BlocProvider.of<ElectionJoinBloc>(context);
    bloc.add(JoinElectionEvent(invitationKey));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ElectionJoinBloc, ElectionJoinState>(
      builder: (context, state) {
        if (state is ElectionJoinInitial) {
          _joinElection(context); // Start the join process
          return const CustomCircularProgress(
            description: "Joining the election",
          );
        } else if (state is ElectionJoinLoading) {
          return const CustomCircularProgress(
            description: "Joining the election",
          );
        } else if (state is ElectionJoinSuccess) {
          // Handle join success
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.av_timer_rounded,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 10),
              Text(
                'Your current status on joining the election:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text('hi'
                  // Display relevant information about the joined election
                  // For example, election title, organization, etc.
                  ),
              // Add other UI components as needed
            ],
          );
        } else if (state is ElectionJoinError) {
          // Handle join error
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 10),
              const Text(
                'Failed to join the election.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Go Back'),
              ),
            ],
          );
        } else {
          return Container(); // Default widget if none of the states match
        }
      },
    );
  }
}

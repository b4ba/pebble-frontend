import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/client/widgets/election_card.dart';
import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:ecclesia_ui/data/models/voter_model.dart';
import 'package:ecclesia_ui/server/bloc/election_just_ended_bloc.dart';
import 'package:ecclesia_ui/server/bloc/joined_elections_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This screen is the home screen or can be known as 'Joined election list'
// screen which is meant to list current active joined election(s).

class JoinedElectionList extends StatelessWidget {
  final Voter user;

  const JoinedElectionList({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<JoinedElectionsBloc>(context)..add(LoadJoinedElection(user: user)),
        ),
        BlocProvider.value(
          value: BlocProvider.of<ElectionJustEndedBloc>(context)..add(LoadElectionJustEnded(elections: Election.elections)),
        ),
      ],
      child: WillPopScope(
        onWillPop: null,
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 246, 248, 250),
            appBar: const CustomAppBar(back: false, disableBackGuard: false, disableMenu: false),
            endDrawer: const CustomDrawer(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SearchBar(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Just ended:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    BlocBuilder<ElectionJustEndedBloc, ElectionJustEndedState>(
                      builder: (context, state) {
                        if (state is ElectionJustEndedInitial) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        } else if (state is ElectionJustEndedLoaded) {
                          return ElectionCard(id: state.election.id, electionTitle: state.election.title, electionDescription: state.election.description, electionOrganization: state.election.organization, status: state.status, userId: user.id);
                        } else {
                          return const Text('Something is wrong');
                        }
                      },
                    ),
                  ]),
                ),
                Expanded(
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Active joined election(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    BlocBuilder<JoinedElectionsBloc, JoinedElectionsState>(
                      builder: (context, state) {
                        if (state is JoinedElectionsInitial) {
                          return const CircularProgressIndicator(
                            color: Colors.blue,
                          );
                        } else if (state is JoinedElectionsLoaded) {
                          return Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: state.elections.length,
                              itemBuilder: (_, index) {
                                Election key = state.elections.keys.elementAt(index);

                                if (state.elections[key] == ElectionStatusEnum.voteClosed) {
                                  return Container();
                                }

                                return ElectionCard(
                                  id: key.id,
                                  electionTitle: key.title,
                                  electionDescription: key.description,
                                  electionOrganization: key.organization,
                                  status: state.elections[key]!,
                                  userId: user.id,
                                );
                              },
                            ),
                          );
                        } else {
                          return const Text('Something is wrong');
                        }
                      },
                    ),
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}

// Widget to search election
// DEV NOTE: Not implemented yet
class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: const TextField(
            decoration: InputDecoration(
          labelText: 'Type here to search',
          suffixIcon: Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(width: 0, color: Colors.white),
          ),
          fillColor: Color.fromARGB(255, 217, 217, 217),
          filled: true,
          suffixIconColor: Color.fromARGB(255, 255, 255, 255),
          labelStyle: TextStyle(color: Colors.black),
        )),
      ),
    );
  }
}

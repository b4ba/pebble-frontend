import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/client/widgets/election_card.dart';
import 'package:ecclesia_ui/data/models/voter_model.dart';
import 'package:ecclesia_ui/services/get_election_status.dart';
import 'package:ecclesia_ui/services/isar_services.dart';
import 'package:flutter/material.dart';

// The 'Joined election list' screen functions as the app's home screen
// It lists the user's currently active and expired joined elections.

class JoinedElectionList extends StatefulWidget {
  final Voter user;

  const JoinedElectionList({super.key, required this.user});
  @override
  _JoinedElectionListState createState() => _JoinedElectionListState();
}

class _JoinedElectionListState extends State<JoinedElectionList> {
  late List<Election> allElections;
  late List<Election> activeElections;
  late List<Election> endedElections;

  @override
  void initState() {
    super.initState();
    _fetchElections();
  }

  _fetchElections() async {
    IsarService isarService = IsarService();
    allElections = await isarService.getAllElections();
    activeElections = allElections
        .where((election) =>
            getElectionStatus(election.startTime, election.endTime) !=
            ElectionStatusEnum.voteClosed)
        .toList();
    endedElections = allElections
        .where((election) =>
            getElectionStatus(election.startTime, election.endTime) ==
            ElectionStatusEnum.voteClosed)
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: null,
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 246, 248, 250),
            appBar: const CustomAppBar(
                back: false, disableBackGuard: false, disableMenu: false),
            endDrawer: const CustomDrawer(),
            body: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Joined Elections'),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Active Elections'),
                      Tab(text: 'Ended Elections'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _buildElectionList(activeElections),
                    _buildElectionList(endedElections),
                  ],
                ),
              ),
            )));
  }

  Widget _buildElectionList(List<Election> elections) {
    return ListView.builder(
        itemCount: elections.length,
        itemBuilder: (context, index) {
          final election = elections[index];
          return ElectionCard(
            electionDescription: election.description,
            electionOrganization: election.organization,
            electionTitle: election.title,
            id: election.invitationId,
            status: getElectionStatus(election.startTime, election.endTime),
            userId: '1',
          );
        }
        // ... other attributes and widgets ...
        );
  }
}
// class JoinedElectionList extends StatelessWidget {
//   final Voter user;

//   const JoinedElectionList({
//     Key? key,
//     required this.user,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     IsarService isarService = IsarService();

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(
//           value: BlocProvider.of<JoinedElectionsBloc>(context)
//             ..add(LoadJoinedElection(user: user)),
//         ),
//         BlocProvider.value(
//           value: BlocProvider.of<ElectionJustEndedBloc>(context)
//             ..add(LoadElectionJustEnded(elections: Election.elections)),
//         ),
//       ],
//       child: WillPopScope(
//         onWillPop: null,
//         child: Scaffold(
//             backgroundColor: const Color.fromARGB(255, 246, 248, 250),
//             appBar: const CustomAppBar(
//                 back: false, disableBackGuard: false, disableMenu: false),
//             endDrawer: const CustomDrawer(),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 9.0),
//                   child: Center(
//                       child: Text(
//                     'Ended elections:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                   )),
//                 ),
//                 // SearchBar(),

//                 BlocBuilder<ElectionJustEndedBloc, ElectionJustEndedState>(
//                   builder: (context, state) {
//                     if (state is ElectionJustEndedInitial) {
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.blue,
//                         ),
//                       );
//                     } else if (state is ElectionJustEndedLoaded) {
//                       // Filter elections based on the status
//                       return FutureBuilder(
//                           future: isarService.getAllElections(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const CircularProgressIndicator();
//                             } else if (snapshot.hasError) {
//                               return const Text(
//                                   'Error fetching election data from database');
//                             } else {
//                               final elections = snapshot.data;
//                               if (elections != null) {
//                                 if (elections.isNotEmpty) {
//                                   final justEndedElections = elections
//                                       .where((election) =>
//                                           getElectionStatus(election.startTime,
//                                               election.endTime) ==
//                                           ElectionStatusEnum.voteClosed)
//                                       .toList();
//                                   if (justEndedElections.isEmpty) {
//                                     return const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 14.0),
//                                         child: Center(
//                                             child: Text(
//                                           'You haven\'t joined any expired elections',
//                                         )));
//                                   } else {
//                                     return Expanded(
//                                         child: ListView.builder(
//                                             itemCount:
//                                                 justEndedElections.length,
//                                             itemBuilder: (context, index) {
//                                               return ElectionCard(
//                                                 electionDescription:
//                                                     justEndedElections[index]
//                                                         .description,
//                                                 electionOrganization:
//                                                     justEndedElections[index]
//                                                         .organization,
//                                                 electionTitle:
//                                                     justEndedElections[index]
//                                                         .title,
//                                                 id: justEndedElections[index]
//                                                     .invitationId,
//                                                 status: getElectionStatus(
//                                                     justEndedElections[index]
//                                                         .startTime,
//                                                     justEndedElections[index]
//                                                         .endTime),
//                                                 userId: '1',
//                                               );
//                                             }));
//                                   }
//                                 } else {
//                                   return const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 14.0),
//                                       child: Center(
//                                           child: Text(
//                                         'You haven\'t joined any expired elections',
//                                       )));
//                                 }
//                               } else {
//                                 // If there are no just ended elections, display a message
//                                 return const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 14.0),
//                                     child: Center(
//                                         child: Text(
//                                       'You haven\'t joined any expired elections',
//                                     )));
//                               }
//                             }
//                           });
//                     } else {
//                       return const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 14.0),
//                           child: Center(
//                               child: Text(
//                                   'Something went wrong fetching your expired election data')));
//                     }
//                   },
//                 ),
//                 Expanded(
//                   child: Column(children: [
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 5.0),
//                       child: Text(
//                         'Active joined election(s):',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     BlocBuilder<JoinedElectionsBloc, JoinedElectionsState>(
//                         builder: (context, state) {
//                       if (state is JoinedElectionsInitial) {
//                         return const CircularProgressIndicator(
//                           color: Colors.blue,
//                         );
//                       } else if (state is JoinedElectionsLoaded) {
//                         return FutureBuilder(
//                             future: isarService.getAllElections(),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const CircularProgressIndicator();
//                               } else if (snapshot.hasError) {
//                                 return const Text('Error fetching data');
//                               } else {
//                                 final elections = snapshot.data;
//                                 if (elections != null) {
//                                   if (elections.isNotEmpty) {
//                                     final activeElections = elections
//                                         .where((election) =>
//                                             getElectionStatus(
//                                                 election.startTime,
//                                                 election.endTime) !=
//                                             ElectionStatusEnum.voteClosed)
//                                         .toList();
//                                     if (activeElections.isEmpty) {
//                                       return const Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 14.0),
//                                           child: Center(
//                                               child: Text(
//                                                   'You haven\'t joined any elections yet')));
//                                     } else {
//                                       return Expanded(
//                                           child: ListView.builder(
//                                               itemCount: activeElections.length,
//                                               itemBuilder: (context, index) {
//                                                 return ElectionCard(
//                                                   electionDescription:
//                                                       activeElections[index]
//                                                           .description,
//                                                   electionOrganization:
//                                                       activeElections[index]
//                                                           .organization,
//                                                   electionTitle:
//                                                       activeElections[index]
//                                                           .title,
//                                                   id: activeElections[index]
//                                                       .invitationId,
//                                                   status: getElectionStatus(
//                                                       activeElections[index]
//                                                           .startTime,
//                                                       activeElections[index]
//                                                           .endTime),
//                                                   userId: '1',
//                                                 );
//                                               }));
//                                     }
//                                   } else {
//                                     return const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 14.0),
//                                         child: Center(
//                                             child: Text(
//                                                 'You haven\'t joined any elections yet')));
//                                   }
//                                 } else {
//                                   // If there are no just ended elections, display a message
//                                   return const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 14.0),
//                                       child: Center(
//                                           child: Text(
//                                               'You haven\'t joined any elections yet')));
//                                 }
//                               }
//                             });
//                       } else {
//                         return const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 14.0),
//                             child: Center(
//                                 child: Text(
//                                     'Something went wrong fetching your active election data')));
//                       }
//                     })
//                   ]),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }

class JustEndedElectionTab extends StatelessWidget {
  final Voter user;

  const JustEndedElectionTab({required this.user});

  @override
  Widget build(BuildContext context) {
    // Your existing content for just ended elections
    // ... BlocBuilder for ElectionJustEndedBloc ...
    // ... Return widgets for the just ended elections ...
    return Text('yo');
  }
}

class ActiveJoinedElectionTab extends StatelessWidget {
  final Voter user;

  const ActiveJoinedElectionTab({required this.user});

  @override
  Widget build(BuildContext context) {
    // Your existing content for active joined elections
    // ... BlocBuilder for JoinedElectionsBloc ...
    // ... Return widgets for the active joined elections ...
    return Text('ye');
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

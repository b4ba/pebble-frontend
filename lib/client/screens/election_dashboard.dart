import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_container.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/client/widgets/status_tag.dart';
import 'package:ecclesia_ui/client/widgets/status_tag_description.dart';
import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:ecclesia_ui/server/bloc/election_overview_bloc.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Screen for an election dashboard that presents the details about
// the election in terms of the name, start and end time, choices, and etc.

class ElectionDashboard extends StatelessWidget {
  final String id;
  final String userId;

  const ElectionDashboard({Key? key, required this.id, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ElectionOverviewBloc>(context)..add(LoadElectionOverview(id: id, userId: userId)),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 246, 248, 250),
          appBar: const CustomAppBar(
            back: true,
            disableBackGuard: true,
            disableMenu: false,
          ),
          endDrawer: const CustomDrawer(),
          bottomNavigationBar: BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
            builder: (context, state) {
              if (state is ElectionOverviewInitial) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Start voting'),
                  ),
                );
              } else if (state is ElectionOverviewLoaded) {
                goVote() {
                  context.go('/election-detail/$id/$userId/voting');
                }

                goSeeResult() {
                  context.go('/election-detail/$id/$userId/result');
                }

                if (state.status == ElectionStatusEnum.voteOpen || state.status == ElectionStatusEnum.voteEnding) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: goVote,
                      child: const Text('Start voting'),
                    ),
                  );
                } else if (state.status == ElectionStatusEnum.voted) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(onPressed: null, child: Text('See result')),
                  );
                } else if (state.status == ElectionStatusEnum.voteClosed) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(onPressed: goSeeResult, child: const Text('See result')),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(onPressed: null, child: Text('Start voting')),
                  );
                }
              } else {
                return const Text("Something is wrong =(");
              }
            },
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 2), (() {
                context.read<ElectionOverviewBloc>().add(RefreshElectionOverview(id: id, userId: userId));
              }));
            },
            child: ListView(
              children: [
                BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
                  builder: (context, state) {
                    if (state is ElectionOverviewInitial) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (state is ElectionOverviewLoaded) {
                      return ElectionStatus(
                        title: state.election.title,
                        description: state.election.description,
                        organization: state.election.organization,
                        status: state.status,
                        startTime: state.election.startTime,
                        endTime: state.election.endTime,
                        choices: state.election.choices,
                      );
                    } else {
                      return const Text('Something is wrong');
                    }
                  },
                ),
                BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
                  builder: (context, state) {
                    if (state is ElectionOverviewInitial) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (state is ElectionOverviewLoaded) {
                      return ElectionDescription(
                        description: state.election.description,
                      );
                    } else {
                      return const Text('Something is wrong');
                    }
                  },
                ),
                VotingOptions(id: id, userId: userId),
                BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
                  builder: (context, state) {
                    if (state is ElectionOverviewInitial) {
                      return const CircularProgressIndicator(color: Colors.blue);
                    } else if (state is ElectionOverviewLoaded) {
                      bool castedStatus = state.status == ElectionStatusEnum.voted || state.status == ElectionStatusEnum.voteClosed;
                      return castedStatus ? VoteCasted(id: id, userId: userId) : const SizedBox();
                    } else {
                      return const Text('Something is wrong');
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}

class ElectionDescription extends StatelessWidget {
  final String description;
  const ElectionDescription({
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Election description',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

class VoteCasted extends StatelessWidget {
  final String userId;
  final String id;

  const VoteCasted({
    Key? key,
    required this.id,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Text(
              'You voted for:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          BlocBuilder<LoggedUserBloc, LoggedUserState>(
            builder: (context, state) {
              if (state is LoggedUserLoaded) {
                final Election election = Election.elections[int.parse(id)];
                return VoteChoiceRow(choice: state.user.votedChoices[election], id: id, userId: userId);
              } else {
                return const Text('There is something wrong');
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: const Text(
              'Transaction ID:',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                decoration: InputDecoration(
              labelText: 'xxxxxxxxxxxxxxxxxxxxxxx',
              suffixIcon: IconButton(
                  onPressed: () {
                    debugPrint('Not copied transaction id');
                  },
                  icon: const Icon(Icons.copy_rounded)),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(width: 0, color: Colors.white),
              ),
              fillColor: const Color.fromARGB(255, 217, 217, 217),
              filled: true,
              suffixIconColor: const Color.fromARGB(255, 255, 255, 255),
              labelStyle: const TextStyle(color: Colors.black),
            )),
          ),
        ],
      ),
    );
  }
}

class VotingOptions extends StatelessWidget {
  final String id;
  final String userId;

  const VotingOptions({
    Key? key,
    required this.id,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Text(
              'Voting options',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          BlocBuilder<ElectionOverviewBloc, ElectionOverviewState>(
            builder: (context, state) {
              if (state is ElectionOverviewInitial) {
                return const CircularProgressIndicator(color: Colors.blue);
              } else if (state is ElectionOverviewLoaded) {
                Iterable<VoteChoiceRow> rows = state.election.choices.map(
                  (choice) => VoteChoiceRow(choice: choice, id: id, userId: userId),
                );
                return Column(children: rows.toList(growable: false));
                // return Column(children: const [
                //   VoteChoiceRow(title: 'James Cameron'),
                //   VoteChoiceRow(title: 'Susan Matthew'),
                //   VoteChoiceRow(title: 'Yanning Li'),
                // ]);
              } else {
                return const Text('Something is wrong');
              }
            },
          )
        ],
      ),
    );
  }
}

class VoteChoiceRow extends StatelessWidget {
  final Choice? choice;
  final String id;
  final String userId;

  const VoteChoiceRow({
    required this.choice,
    required this.id,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: const BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(
        width: 0.7,
        color: Colors.black,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(choice!.title),
          IconButton(
              onPressed: () {
                context.go('/election-detail/$id/$userId/info/${choice!.id}');
                debugPrint('Open info about a choice');
              },
              icon: const Icon(Icons.info))
        ],
      ),
    );
  }
}

class ElectionStatus extends StatelessWidget {
  final String title;
  final String description;
  final String organization;
  final ElectionStatusEnum status;
  final DateTime startTime;
  final DateTime endTime;
  final List<Choice> choices;

  const ElectionStatus({
    Key? key,
    required this.title,
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.choices,
    required this.organization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            organization,
            style: const TextStyle(fontSize: 12),
          ),
          SizedBox(
            width: 300,
            child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusTag(status: status),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ElectionTime(startTime: startTime, endTime: endTime, status: status),
          StatusTagDescription(status: status),
        ],
      ),
    );
  }
}

class ElectionTime extends StatelessWidget {
  const ElectionTime({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.status,
  }) : super(key: key);

  final DateTime startTime;
  final DateTime endTime;
  final ElectionStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final bool preparing = ElectionStatusEnum.registeringDetails == status || ElectionStatusEnum.registeringDetails == status || ElectionStatusEnum.voteNotOpen == status;
    final bool open = ElectionStatusEnum.voteOpen == status || ElectionStatusEnum.voteEnding == status;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.calendar_month),
        preparing
            ? Text(
                '  Voting starts on ${DateFormat.yMd().format(startTime)}',
                style: const TextStyle(fontSize: 12),
              )
            : open
                ? Text(
                    '  Voting ends on ${DateFormat.yMd().format(endTime)}',
                    style: const TextStyle(fontSize: 12),
                  )
                : Text(
                    '  Voting ended on ${DateFormat.yMd().format(endTime)}',
                    style: const TextStyle(fontSize: 12),
                  ),
      ],
    );
  }
}

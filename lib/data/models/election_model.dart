import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'election_model.g.dart';

// Class model of an election
@Collection(inheritance: false)
@Name('Election')
class Election extends Equatable {
  final Id id = Isar.autoIncrement;
  final String title;
  final String description;
  final String organization;
  final DateTime startTime;
  final DateTime endTime;
  // @ignore
  final choices = IsarLinks<Choice>();
  // final List<Choice> choices;

  Election({
    required this.title,
    required this.description,
    required this.organization,
    required this.startTime,
    required this.endTime,
    // required this.choices
  });

  @override
  @ignore
  List<Object?> get props => [id, title];

  // Dummy data for election
  static List<Election> elections = [
    Election(
      title: 'Treasurer 22/23',
      description:
          'An election for the next treasurer is taking place to determine who will manage financial operations, create budgets, oversee accounts, and ensure compliance. The treasurer will report to the board and members, and will be responsible for financial stability and decision making that supports the organization\'s goals. Candidates will campaign and present qualifications, members will vote to determine the winner.',
      organization: 'Edinburgh University Sports Union (EUSU)',
      startTime: DateTime.parse("2022-02-23"),
      endTime: DateTime.parse("2022-03-23"),
      // choices: Choice.personChoice,
    ),
    Election(
      title: 'Best food (April)',
      description:
          'Voters will vote for their favorite dish from a selection of options. They will be presented to the voters and they will have to decide which one they like the most for the month of April.',
      organization: 'Edinburgh Baking Society',
      startTime: DateTime.parse("2022-04-10"),
      endTime: DateTime.parse("2022-04-23"),
      // choices: Choice.foodChoice,
    ),
    Election(
      title: 'Social Meetup for the first time in a while (Dec)',
      description:
          'It has been a while since we hangout as a club. Come and vote for the place where we can hangout and catch-up!',
      organization: 'Informatics 19/23',
      startTime: DateTime.parse("2022-04-15"),
      endTime: DateTime.parse("2022-04-25"),
      // choices: Choice.personChoice,
    ),
    Election(
      title: 'New pet name for the club?',
      description:
          'A member of the club found a cute stray dog and was thinking of making it the club\'s pet. What should we name it?',
      organization: 'Informatics 19/23',
      startTime: DateTime.parse("2022-04-15"),
      endTime: DateTime.parse("2022-04-25"),
      // choices: Choice.personChoice,
    ),
    Election(
      title: 'Club socials',
      description:
          'It\'s our monthly socials again! What should we do for this month of February?',
      organization: 'Edinburgh Baking Society',
      startTime: DateTime.parse("2023-02-15"),
      endTime: DateTime.parse("2023-02-25"),
      // choices: Choice.pubChoice,
    )
  ];

  factory Election.fromJson(Map<String, dynamic> json) {
    List<dynamic> choicesJson = json['choices'];
    List<Choice> choices =
        choicesJson.map((choice) => Choice.fromJson(choice)).toList();

    return Election(
      title: json['title'],
      description: json['description'],
      organization: json['organization'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      // choices: choices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'organization': organization,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      // 'choices': choices.map((choice) => choice.toJson()).toList(),
    };
  }
}

// Constants to represent the phase of an election
enum ElectionStatusEnum {
  voteNotOpen,
  voteOpen,
  voteEnding,
  voted,
  voteClosed,
}

class ElectionCardModel {
  final String statusTitle;
  final Color color;
  final String statusDesc;
  final String subtitle;
  final IconData icon;

  ElectionCardModel({
    required this.statusTitle,
    required this.statusDesc,
    required this.color,
    required this.subtitle,
    required this.icon,
  });
}

final Map<ElectionStatusEnum, ElectionCardModel> electionCardOptions = {
  ElectionStatusEnum.voteNotOpen: ElectionCardModel(
      statusTitle: 'Not open yet',
      color: Colors.orange,
      statusDesc: "Election not ready yet",
      subtitle: "Wait for the election to open.",
      icon: Icons.error),
  ElectionStatusEnum.voteOpen: ElectionCardModel(
      statusTitle: 'Open to vote',
      color: Colors.green,
      statusDesc: "You can start voting now",
      subtitle:
          "Start voting by clicking the blue button at the bottom of the screen.",
      icon: Icons.dangerous_rounded),
  ElectionStatusEnum.voteEnding: ElectionCardModel(
      statusTitle: 'Ending in 5 hours',
      color: Colors.red,
      statusDesc: "Vote before the election ends",
      subtitle:
          "Start voting by clicking the blue button at the bottom of the page.",
      icon: Icons.pending_actions_rounded),
  ElectionStatusEnum.voteClosed: ElectionCardModel(
      statusTitle: 'Voting closed',
      color: Colors.black,
      statusDesc: "Voting period has ended",
      subtitle: "Thank you for joining.",
      icon: Icons.door_front_door_outlined),
  ElectionStatusEnum.voted: ElectionCardModel(
      statusTitle: 'You have voted',
      color: Colors.blue,
      statusDesc: "You have voted",
      subtitle: "Wait for the voting period to end to see the result.",
      icon: Icons.check_circle),
};

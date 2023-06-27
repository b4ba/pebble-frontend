import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:equatable/equatable.dart';

// Class model of an election
class Election extends Equatable {
  final String id;
  final String title;
  final String description;
  final String organization;
  final DateTime startTime;
  final DateTime endTime;
  final List<Choice> choices;

  const Election({required this.id, required this.title, required this.description, required this.organization, required this.startTime, required this.endTime, required this.choices});

  @override
  List<Object?> get props => [id, title];

  // Dummy data for election
  static List<Election> elections = [
    Election(
      id: '0',
      title: 'Treasurer 22/23',
      description:
          'An election for the next treasurer is taking place to determine who will manage financial operations, create budgets, oversee accounts, and ensure compliance. The treasurer will report to the board and members, and will be responsible for financial stability and decision making that supports the organization\'s goals. Candidates will campaign and present qualifications, members will vote to determine the winner.',
      organization: 'Edinburgh University Sports Union (EUSU)',
      startTime: DateTime.parse("2022-02-23"),
      endTime: DateTime.parse("2022-03-23"),
      choices: Choice.personChoice,
    ),
    Election(
      id: '1',
      title: 'Best food (April)',
      description: 'Voters will vote for their favorite dish from a selection of options. They will be presented to the voters and they will have to decide which one they like the most for the month of April.',
      organization: 'Edinburgh Baking Society',
      startTime: DateTime.parse("2022-04-10"),
      endTime: DateTime.parse("2022-04-23"),
      choices: Choice.foodChoice,
    ),
    Election(
      id: '2',
      title: 'Social Meetup for the first time in a while (Dec)',
      description: 'It has been a while since we hangout as a club. Come and vote for the place where we can hangout and catch-up!',
      organization: 'Informatics 19/23',
      startTime: DateTime.parse("2022-04-15"),
      endTime: DateTime.parse("2022-04-25"),
      choices: Choice.personChoice,
    ),
    Election(
      id: '3',
      title: 'New pet name for the club?',
      description: 'A member of the club found a cute stray dog and was thinking of making it the club\'s pet. What should we name it?',
      organization: 'Informatics 19/23',
      startTime: DateTime.parse("2022-04-15"),
      endTime: DateTime.parse("2022-04-25"),
      choices: Choice.personChoice,
    ),
    Election(
      id: '4',
      title: 'Club socials',
      description: 'It\'s our monthly socials again! What should we do for this month of February?',
      organization: 'Edinburgh Baking Society',
      startTime: DateTime.parse("2023-02-15"),
      endTime: DateTime.parse("2023-02-25"),
      choices: Choice.pubChoice,
    )
  ];
}

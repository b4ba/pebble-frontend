import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';

// Class model for result of election
class ElectionResult {
  final Election election;
  final Map<Choice, int> voteCounts;
  final Choice winner;

  const ElectionResult({required this.election, required this.voteCounts, required this.winner});

  // Dummy data for result of an election, in Map format
  static Map<Election, ElectionResult> results = {
    Election.elections[0]: ElectionResult(
      election: Election.elections[0],
      voteCounts: {
        Choice.personChoice[0]: 20,
        Choice.personChoice[1]: 23,
        Choice.personChoice[2]: 39,
      },
      winner: Choice.personChoice[2],
    ),
    Election.elections[1]: ElectionResult(
      election: Election.elections[1],
      voteCounts: {
        Choice.foodChoice[0]: 10,
        Choice.foodChoice[1]: 7,
        Choice.foodChoice[2]: 5,
      },
      winner: Choice.foodChoice[0],
    ),
  };

  // Dummy data for result of an election, in List format
  static List<ElectionResult> resultsIndex = [
    ElectionResult(
      election: Election.elections[0],
      voteCounts: {
        Choice.personChoice[0]: 20,
        Choice.personChoice[1]: 23,
        Choice.personChoice[2]: 39,
      },
      winner: Choice.personChoice[2],
    ),
    ElectionResult(
      election: Election.elections[1],
      voteCounts: {
        Choice.foodChoice[0]: 10,
        Choice.foodChoice[1]: 7,
        Choice.foodChoice[2]: 5,
      },
      winner: Choice.foodChoice[0],
    ),
  ];

  static ElectionResult noResult = ElectionResult(election: Election.elections[0], voteCounts: {Choice.personChoice[0]: 0}, winner: Choice.noVote);
}

import '../data/models/election_model.dart';

// The getElectiontatus helper function takes the start and end time of an election and returns the correct status enum
ElectionStatusEnum getElectionStatus(DateTime startTime, DateTime endTime) {
  DateTime currentDate = DateTime.now();
  if (currentDate.isBefore(startTime)) {
    return ElectionStatusEnum.voteNotOpen;
  } else if (currentDate.isAfter(endTime)) {
    return ElectionStatusEnum.voteClosed;
  } else if (currentDate.isBefore(endTime) &&
      currentDate.isAfter(endTime.subtract(const Duration(hours: 5)))) {
    return ElectionStatusEnum.voteEnding;
  } else {
    return ElectionStatusEnum.voteOpen;
  }
}

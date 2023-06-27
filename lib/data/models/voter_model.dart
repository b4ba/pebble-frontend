import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:equatable/equatable.dart';

// Class model of a voter
class Voter extends Equatable {
  final String id;
  final String name;
  final String publicKey;
  final Map<Election, ElectionStatusEnum> joinedElections;
  final Map<Election, Choice> votedChoices;
  final Map<String, Organization> joinedOrganizations;

  const Voter({
    required this.id,
    required this.name,
    required this.publicKey,
    required this.joinedElections,
    required this.votedChoices,
    required this.joinedOrganizations,
  });

  @override
  List<Object?> get props => [id, publicKey];

  //Dummy data for voter data
  static List<Voter> voters = [
    Voter(
      id: '0',
      name: 'Jackie Chan',
      publicKey: 'hwfi32932jf0',
      joinedOrganizations: {
        '0': Organization.organizations[0],
        '1': Organization.organizations[1],
        '2': Organization.organizations[2],
      },
      joinedElections: {
        Election.elections[0]: ElectionStatusEnum.voteNotOpen,
        Election.elections[1]: ElectionStatusEnum.voteOpen,
        Election.elections[3]: ElectionStatusEnum.voted,
      },
      votedChoices: {
        Election.elections[0]: Choice.noVote,
        Election.elections[1]: Choice.noVote,
        Election.elections[3]: Choice.noVote,
      },
    ),
    Voter(
      id: '1',
      name: 'Harry Kane',
      publicKey: 'hwfig2932jf0',
      joinedOrganizations: {
        '0': Organization.organizations[0],
        '1': Organization.organizations[1],
        '2': Organization.organizations[2],
      },
      joinedElections: {
        Election.elections[0]: ElectionStatusEnum.voteClosed,
        Election.elections[1]: ElectionStatusEnum.voteEnding,
        Election.elections[2]: ElectionStatusEnum.registeringDetails,
      },
      votedChoices: {
        Election.elections[0]: Choice.personChoice[0],
        Election.elections[1]: Choice.noVote,
        Election.elections[3]: Choice.noVote,
      },
    ),
  ];
}

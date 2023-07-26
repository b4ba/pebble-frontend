import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

// To represent the choice in a voting process
part 'choice_model.g.dart';

@Collection(inheritance: false)
class Choice extends Equatable {
  final Id id = Isar.autoIncrement;
  final String title;
  final String description;
  final int numberOfVote;
  final String invitationId;
  @Backlink(to: 'choices')
  final election = IsarLinks<Election>();

  Choice({
    required this.title,
    required this.description,
    required this.numberOfVote,
    required this.invitationId,
  });

  @override
  List<Id> get props => [id];

  static List<Choice> personChoice = [
    Choice(
        title: 'James Cameron',
        description:
            'A university student who is currently pursuing his degree in a field of his interest. He is known to be a hardworking and dedicated student who is committed to his studies. He is actively involved in various extracurricular activities and is often seen as a leader among his peers. He is also known to be a well-rounded individual, with a keen interest in both academics and sports. He is an ambitious student with a clear vision of his future career aspirations. He is respected by his peers and professors alike for his strong work ethic and dedication to his studies, and he is expected to excel in his chosen field after graduation.',
        numberOfVote: 0,
        invitationId: '1'),
    Choice(
        title: 'Susan Matthew',
        description:
            'Dedicated and diligent student. She is currently pursuing her degree in a field of her interest and is known to be a hardworking and focused individual. She is also known to be an active participant in various extracurricular activities and is well-respected by her peers for her strong leadership skills and her ability to work well in a team. She is an ambitious student with a clear vision of her future career aspirations. She is known to be a well-rounded individual with a keen interest in both academics and community service. She is highly motivated and is expected to excel in her chosen field after graduation.',
        numberOfVote: 0,
        invitationId: '1'),
    Choice(
        title: 'Yanning Li',
        description:
            'Yanning Li is a business university student who is known for his strong analytical skills and his commitment to his studies. He is currently pursuing a degree in business and is known to be a diligent and hardworking student. He is also known to be an active participant in various extracurricular activities and is respected by his peers for his strong work ethic and his ability to work well in a team. He is an ambitious student with a clear vision of his future career aspirations in business field. He is known to be a well-rounded individual with a keen interest in both academics and business practices.',
        numberOfVote: 0,
        invitationId: '1'),
  ];

  static List<Choice> foodChoice = [
    Choice(
        title: 'Pizza',
        description: 'Good old italian dish.',
        numberOfVote: 0,
        invitationId: '1'),
    Choice(
        title: 'Fish and chips',
        description: 'Originated from the Brits.',
        numberOfVote: 0,
        invitationId: '1'),
    Choice(
        title: 'Tikka Masala',
        description: 'An indian dish, but actually from the UK.',
        numberOfVote: 0,
        invitationId: '1'),
  ];

  static List<Choice> pubChoice = [
    Choice(
        title: 'Pear tree',
        description: 'Pretty close to George Square',
        numberOfVote: 0,
        invitationId: '1'),
    Choice(
        title: '32 Below',
        description: 'Just in front of Bing Tea.',
        numberOfVote: 0,
        invitationId: '1'),
    Choice(
        title: 'Southsider',
        description: 'Beside Farmfood in Nicholson street.',
        numberOfVote: 0,
        invitationId: '1'),
  ];

  static Choice noVote = Choice(
      title: "No vote", description: "", numberOfVote: 0, invitationId: '1');

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'numberOfVote': numberOfVote,
      'invitationId': invitationId,
    };
  }

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      title: json['title'],
      description: json['description'],
      numberOfVote: json['numberOfVote'],
      invitationId: json['invitationId'],
    );
  }
}

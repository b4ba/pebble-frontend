import 'package:equatable/equatable.dart';

// To represent the choice in a voting process

class Choice extends Equatable {
  final String id;
  final String title;
  final String description;
  final int numberOfVote;

  const Choice({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfVote,
  });

  @override
  List<Object?> get props => [id];

  static List<Choice> personChoice = [
    const Choice(
        id: '0',
        title: 'James Cameron',
        description:
            'A university student who is currently pursuing his degree in a field of his interest. He is known to be a hardworking and dedicated student who is committed to his studies. He is actively involved in various extracurricular activities and is often seen as a leader among his peers. He is also known to be a well-rounded individual, with a keen interest in both academics and sports. He is an ambitious student with a clear vision of his future career aspirations. He is respected by his peers and professors alike for his strong work ethic and dedication to his studies, and he is expected to excel in his chosen field after graduation.',
        numberOfVote: 0),
    const Choice(
        id: '1',
        title: 'Susan Matthew',
        description:
            'Dedicated and diligent student. She is currently pursuing her degree in a field of her interest and is known to be a hardworking and focused individual. She is also known to be an active participant in various extracurricular activities and is well-respected by her peers for her strong leadership skills and her ability to work well in a team. She is an ambitious student with a clear vision of her future career aspirations. She is known to be a well-rounded individual with a keen interest in both academics and community service. She is highly motivated and is expected to excel in her chosen field after graduation.',
        numberOfVote: 0),
    const Choice(
        id: '2',
        title: 'Yanning Li',
        description:
            'Yanning Li is a business university student who is known for his strong analytical skills and his commitment to his studies. He is currently pursuing a degree in business and is known to be a diligent and hardworking student. He is also known to be an active participant in various extracurricular activities and is respected by his peers for his strong work ethic and his ability to work well in a team. He is an ambitious student with a clear vision of his future career aspirations in business field. He is known to be a well-rounded individual with a keen interest in both academics and business practices.',
        numberOfVote: 0),
  ];

  static List<Choice> foodChoice = [
    const Choice(id: '0', title: 'Pizza', description: 'Good old italian dish.', numberOfVote: 0),
    const Choice(id: '1', title: 'Fish and chips', description: 'Originated from the Brits.', numberOfVote: 0),
    const Choice(id: '2', title: 'Tikka Masala', description: 'An indian dish, but actually from the UK.', numberOfVote: 0),
  ];

  static List<Choice> pubChoice = [
    const Choice(id: '0', title: 'Pear tree', description: 'Pretty close to George Square', numberOfVote: 0),
    const Choice(id: '1', title: '32 Below', description: 'Just in front of Bing Tea.', numberOfVote: 0),
    const Choice(id: '2', title: 'Southsider', description: 'Beside Farmfood in Nicholson street.', numberOfVote: 0),
  ];

  static Choice noVote = const Choice(id: 'NULL', title: "No vote", description: "", numberOfVote: 0);
}

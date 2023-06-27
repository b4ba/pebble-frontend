import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:flutter/material.dart';

// Custom widget for the small status tag that can be found at the top-right
// corner of an election_card.dart widget

class StatusTag extends StatelessWidget {
  const StatusTag({
    Key? key,
    required this.status,
  }) : super(key: key);

  final ElectionStatusEnum status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: electionCardOptions[status]!.color,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Text(
        electionCardOptions[status]!.statusTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }
}

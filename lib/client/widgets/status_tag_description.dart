import 'package:ecclesia_ui/data/models/election_status_model.dart';
import 'package:flutter/material.dart';

// Widget that presents the details of the election from title,
// description, important dates, and current status of the election. Can be
// seen used in election_dashboard.dart where it can be seen at the top part
// of the screen.

class StatusTagDescription extends StatelessWidget {
  // Data render will be based on the passed 'status' argument/
  // To change the details of the render items, refer 'electionCardOptions'
  // in ../data/models/election_status_model.dart
  final ElectionStatusEnum status;

  const StatusTagDescription({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            electionCardOptions[status]!.icon,
            size: 80,
            color: electionCardOptions[status]!.color,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(electionCardOptions[status]!.statusDesc,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
                Text(
                  electionCardOptions[status]!.subtitle,
                  softWrap: true,
                  // overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

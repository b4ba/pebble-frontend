import 'package:flutter/material.dart';

// Custom circular progress indicator which can pass
// custom message

class CustomCircularProgress extends StatelessWidget {
  final String description;
  const CustomCircularProgress({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        )
      ],
    );
  }
}

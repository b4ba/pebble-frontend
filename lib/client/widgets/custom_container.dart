import 'package:flutter/material.dart';

// Card widget for the election card that used to give brief information
// for the voter

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), boxShadow: [
        BoxShadow(
            color: const Color.fromARGB(255, 211, 211, 211).withOpacity(0.5), //color of shadow
            spreadRadius: 3, //spread radius
            blurRadius: 7, // blur radius
            offset: const Offset(0, 6)),
      ]),
      child: child,
    );
  }
}

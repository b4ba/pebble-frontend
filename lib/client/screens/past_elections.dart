import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

// Screen to list out past joined elections.
// Not included in the demo project

class PastElections extends StatelessWidget {
  const PastElections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(back: true, disableBackGuard: true, disableMenu: false),
        endDrawer: CustomDrawer(),
        body: Center(
          child: Text('This is past elections page!'),
        ));
  }
}

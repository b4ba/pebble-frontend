import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Appbar of the app
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final bool back;
  final bool disableMenu;
  final bool disableBackGuard;

  const CustomAppBar({
    required this.back,
    required this.disableMenu,
    required this.disableBackGuard,
    Key? key,
  })  : preferredSize = const Size.fromHeight(80.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ecclesia UI',
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      toolbarHeight: 100,
      leadingWidth: 100,
      shadowColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
      automaticallyImplyLeading: false,
      // Edit here for the back button on the left side of the appbar
      leading: back
          ? InkWell(
              onTap: () => confirmBackPressed(disableBackGuard, context),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      centerTitle: true,
      // Edit here for the menu button on the right side of the appbar
      actions: [
        disableMenu ? Container() : const Sidebar(),
      ],
    );
  }

  // A popup modal to avoid user from accidently going back one screen
  void confirmBackPressed(bool disableBackGuard, BuildContext context) {
    if (disableBackGuard == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Changes will not be saved.'),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      context.pop();
    }
  }
}

// Menu button when clicked will open a sidebar
// To customize sidebar items, see ./custom_drawer.dart
class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
        ),
        child: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

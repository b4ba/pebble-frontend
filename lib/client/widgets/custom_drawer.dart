import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Widget for sidebar. Use ListTile to add new item in the sidebar menu.

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Go back home'),
            onTap: () {
              context.go('/');
              Scaffold.of(context).closeEndDrawer();
            },
          ),
          ListTile(
            title: const Text('Register to an organization'),
            onTap: () {
              context.go('/register-organization');
              Scaffold.of(context).closeEndDrawer();
            },
          ),
          ListTile(
            title: const Text('Register to an election'),
            onTap: () {
              context.go('/register-election');
              Scaffold.of(context).closeEndDrawer();
            },
          ),
          ListTile(
            title: const Text('View joined organization(s)'),
            onTap: () {
              context.go('/joined-organization');
              Scaffold.of(context).closeEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}

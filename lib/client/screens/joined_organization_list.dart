import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This screen is to list out the current joined organizations.

class JoinedOrganizationList extends StatelessWidget {
  const JoinedOrganizationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 248, 250),
      appBar: const CustomAppBar(back: true, disableBackGuard: true, disableMenu: false),
      endDrawer: const CustomDrawer(),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: Text(
            'Joined organization(s):',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: BlocBuilder<LoggedUserBloc, LoggedUserState>(
            builder: (context, state) {
              if (state is LoggedUserInitial) {
                return const CircularProgressIndicator();
              } else if (state is LoggedUserLoaded) {
                return ListView.builder(
                  itemCount: state.user.joinedOrganizations.length,
                  itemBuilder: ((context, index) {
                    Organization organization = state.user.joinedOrganizations.entries.elementAt(index).value;
                    return OrganizationCard(icon: organization.icon, title: organization.name, description: organization.description);
                  }),
                );
              } else {
                return const Text('Something is wrong');
              }
            },
          ),
        ),
      ]),
    );
  }
}

class OrganizationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OrganizationCard({
    required this.icon,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.14), //color of shadow
              spreadRadius: 0, //spread radius
              blurRadius: 10, // blur radius
              offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}

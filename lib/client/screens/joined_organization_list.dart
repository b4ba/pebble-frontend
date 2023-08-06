import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:ecclesia_ui/services/isar_services.dart';
import 'package:flutter/material.dart';

// This screen is to list out the current joined organizations.

class JoinedOrganizationList extends StatefulWidget {
  const JoinedOrganizationList({Key? key}) : super(key: key);
  @override
  _JoinedOrganizationListState createState() => _JoinedOrganizationListState();
}

class _JoinedOrganizationListState extends State<JoinedOrganizationList> {
  late Future<List<Organization>> organizations;

  @override
  void initState() {
    super.initState();
    organizations = IsarService().getAllOrganizations();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 248, 250),
      appBar: const CustomAppBar(
          back: true, disableBackGuard: true, disableMenu: false),
      endDrawer: const CustomDrawer(),
      body: Center(
          child: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: Text(
            'Joined organization(s):',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Organization>>(
            future: organizations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Handle error
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // No organizations found
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('No Organizations'),
                      content: const Text(
                          'There are currently no organizations for which the user has registered for.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                });
                return const Text('No Organizations Found'); // Placeholder text
              } else {
                // Display the organizations
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final organization = snapshot.data![index];
                    return OrganizationCard(
                        icon: Icons.business,
                        title: organization.name,
                        description: organization.description);
                  },
                );
              }
            },
          ),
        ),
      ])),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: const Color.fromARGB(255, 246, 248, 250),
//     appBar: const CustomAppBar(
//         back: true, disableBackGuard: true, disableMenu: false),
//     endDrawer: const CustomDrawer(),
//     body: Center(
//         child: Column(children: [
//       const Padding(
//         padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
//         child: Text(
//           'Joined organization(s):',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//       ),
//       Expanded(
//         child: BlocBuilder<LoggedUserBloc, LoggedUserState>(
//           builder: (context, state) {
//             if (state is LoggedUserInitial) {
//               return const CircularProgressIndicator();
//             } else if (state is OrganizationsLoaded) {
//               return ListView.builder(
//                 itemCount: state.organizations.length,
//                 itemBuilder: ((context, index) {
//                   Organization organization =
//                       state.organizations.elementAt(index);
//                   return OrganizationCard(
//                       icon: Icons.business,
//                       title: organization.name,
//                       description: organization.description);
//                 }),
//               );
//             } else {
//               return const Text('Something is wrong');
//             }
//           },
//         ),
//       ),
//     ])),
//   );
// }

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
              color: const Color.fromARGB(255, 0, 0, 0)
                  .withOpacity(0.14), //color of shadow
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

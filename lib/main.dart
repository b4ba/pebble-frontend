import 'package:ecclesia_ui/client/config/app_router.dart';
import 'package:ecclesia_ui/server/bloc/choice_view_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_just_ended_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_overview_bloc.dart';
import 'package:ecclesia_ui/server/bloc/joined_elections_bloc.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:ecclesia_ui/server/bloc/picked_choice_bloc.dart';
import 'package:ecclesia_ui/services/app_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  //DO WE WANT: debugging error prints?
  //not wanted on frontend, shouldn't rly technically be there here but its also not done so theres a case to be made for either idk
  WidgetsFlutterBinding.ensureInitialized();
  checkAndFetchKeys().then((_) {
    runApp(MultiBlocProvider(providers: [
      BlocProvider<JoinedElectionsBloc>(
        create: (context) => JoinedElectionsBloc(),
      ),
      BlocProvider<ElectionOverviewBloc>(
        create: (context) => ElectionOverviewBloc(),
      ),
      BlocProvider<ElectionJustEndedBloc>(
        create: (context) => ElectionJustEndedBloc(),
      ),
      BlocProvider<PickedChoiceBloc>(
        create: (context) => PickedChoiceBloc(),
      ),
      BlocProvider<LoggedUserBloc>(
        create: (context) => LoggedUserBloc(),
      ),
      BlocProvider<ChoiceViewBloc>(
        create: (context) => ChoiceViewBloc(),
      ),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pebble Voting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      routerConfig: appRouter,
    );
  }
}

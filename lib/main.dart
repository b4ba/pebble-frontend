import 'package:ecclesia_ui/client/config/app_router.dart';
import 'package:ecclesia_ui/server/bloc/choice_view_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_detail_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_join_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_just_ended_bloc.dart';
import 'package:ecclesia_ui/server/bloc/election_overview_bloc.dart';
import 'package:ecclesia_ui/server/bloc/joined_elections_bloc.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:ecclesia_ui/server/bloc/picked_choice_bloc.dart';
import 'package:ecclesia_ui/services/app_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  checkAndFetchKeys().then((_) {
    runApp(MultiBlocProvider(providers: [
      BlocProvider<ElectionBloc>(create: (context) => ElectionBloc()),
      BlocProvider<ElectionDetailBloc>(
          create: (context) => ElectionDetailBloc()),
      BlocProvider<ElectionJoinBloc>(create: (context) => ElectionJoinBloc()),
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
      title: 'E-cclesia UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      routerConfig: appRouter,
      // home: const Home()
    );
  }
}

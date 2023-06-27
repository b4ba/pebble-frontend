import 'package:ecclesia_ui/client/screens/choice_info.dart';
import 'package:ecclesia_ui/client/screens/joined_election_list.dart';
import 'package:ecclesia_ui/client/screens/election_dashboard.dart';
import 'package:ecclesia_ui/client/screens/joined_organization_list.dart';
import 'package:ecclesia_ui/client/screens/past_elections.dart';
import 'package:ecclesia_ui/client/screens/join_camera.dart';
import 'package:ecclesia_ui/client/screens/join_confirmation.dart';
import 'package:ecclesia_ui/client/screens/join_confirmed.dart';
import 'package:ecclesia_ui/client/screens/join_method.dart';
import 'package:ecclesia_ui/client/screens/result.dart';
import 'package:ecclesia_ui/client/screens/voting.dart';
import 'package:ecclesia_ui/client/screens/voting_casted.dart';
import 'package:ecclesia_ui/client/screens/welcome.dart';
import 'package:ecclesia_ui/server/bloc/logged_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter = GoRouter(
  routes: <GoRoute>[
    // Joined Election List Screen
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider.value(
        value: BlocProvider.of<LoggedUserBloc>(context)..add(const LoginLoggedUserEvent(userId: "1")),
        child: BlocBuilder<LoggedUserBloc, LoggedUserState>(
          builder: (context, state) {
            if (state is LoggedUserLoaded) {
              return JoinedElectionList(user: state.user);
              // return const Welcome();
            } else {
              return const Welcome();
            }
          },
        ),
      ),
      routes: <GoRoute>[
        // Past Elections
        GoRoute(
          path: 'past-elections',
          builder: (context, state) => const PastElections(),
          // pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(context: context, state: state, child: const PastElections()),
          // builder: (BuildContext context, GoRouterState state) {
          //   return const PastElections();
          // },
        ),
        // Election Detail
        GoRoute(
          path: 'election-detail/:electionId/:userId',
          builder: (BuildContext context, GoRouterState state) {
            return ElectionDashboard(id: state.params['electionId']!, userId: state.params['userId']!);
          },
          // pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(context: context, state: state, child: ElectionDashboard(id: state.params['electionId']!, userId: state.params['userId']!)),
          routes: <GoRoute>[
            // Voting
            GoRoute(
                path: 'voting',
                builder: (BuildContext context, GoRouterState state) {
                  return Voting(id: state.params['electionId']!, userId: state.params['userId']!);
                },
                routes: [
                  GoRoute(
                    path: 'voting-casted',
                    builder: (BuildContext context, GoRouterState state) {
                      return VotingCasted(id: state.params['electionId']!, userId: state.params['userId']!);
                    },
                  )
                ]),
            // Result
            GoRoute(
              path: 'result',
              builder: (BuildContext context, GoRouterState state) {
                return Result(id: state.params['electionId']!, userId: state.params['userId']!);
              },
            ),
            // Choice info
            GoRoute(
                path: 'info/:choiceId',
                builder: (BuildContext context, GoRouterState state) {
                  return ChoiceInfo(id: state.params['electionId']!, userId: state.params['userId']!, choiceId: state.params['choiceId']!);
                })
          ],
        ),
        // Register to an organization
        GoRoute(
          path: 'register-organization',
          builder: (BuildContext context, GoRouterState state) {
            return const JoinMethod(isElection: false);
          },
          routes: [
            GoRoute(
                path: 'confirmation',
                builder: (BuildContext context, GoRouterState state) {
                  return const JoinConfirmation(
                    isElection: false,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'confirmed',
                    builder: (BuildContext context, GoRouterState state) {
                      return const JoinConfirmed(
                        isElection: false,
                      );
                    },
                  ),
                ]),
            GoRoute(
              path: 'camera',
              builder: (BuildContext context, GoRouterState state) {
                return const JoinCamera(isElection: false);
              },
            ),
          ],
        ),
        // Register to an election
        GoRoute(
          path: 'register-election',
          builder: (BuildContext context, GoRouterState state) {
            return const JoinMethod(isElection: true);
          },
          routes: [
            GoRoute(
                path: 'confirmation',
                builder: (BuildContext context, GoRouterState state) {
                  return const JoinConfirmation(isElection: true);
                },
                routes: [
                  GoRoute(
                    path: 'confirmed',
                    builder: (BuildContext context, GoRouterState state) {
                      return const JoinConfirmed(isElection: true);
                    },
                  ),
                ]),
            GoRoute(
              path: 'camera',
              builder: (BuildContext context, GoRouterState state) {
                return const JoinCamera(
                  isElection: true,
                );
              },
            ),
          ],
        ),
        // View joined organizations
        GoRoute(
          path: 'joined-organization',
          builder: (BuildContext context, GoRouterState state) {
            return const JoinedOrganizationList();
          },
          routes: [
            GoRoute(
              path: 'view/:organizationId',
              builder: (BuildContext context, GoRouterState state) {
                return const JoinedOrganizationList();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> animationHelperFunction(context, state, page) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: page(),
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      return SlideTransition(
        position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
        child: child,
      );
    },
  );
}

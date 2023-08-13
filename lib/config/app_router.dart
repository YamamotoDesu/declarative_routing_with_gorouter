import 'dart:async';

import 'package:declarative_routing_with_gorouter/screens/category_screen.dart';
import 'package:declarative_routing_with_gorouter/screens/login_screen.dart';
import 'package:declarative_routing_with_gorouter/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../cubit/login_cubit.dart';

class AppRouter {
  final LoginCubit loginCubit;
  AppRouter(this.loginCubit);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const CategoryScreen();
        },
        routes: [
          GoRoute(
            path: 'product_list/:category',
            name: 'product_list',
            builder: (BuildContext context, GoRouterState state) {
              return ProductListScreen(
                category: state.pathParameters['category']!,
                asc: state.queryParameters['sort']! == 'asc',
                quantity: int.parse(state.queryParameters['filter'] ?? "0"),
              );
            },
          ),
        ],
      ),
      // GoRoute(
      //   path: '/product_list',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const ProductListScreen();
      //   },
      // ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Check if the user is logged in
      final bool loggedIn = loginCubit.state.status == AuthStatus.authenticated;
      // Check if the user is logging in.
      final bool loggingIn = state.path == '/login';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }
      if (loggedIn) {
        return '/';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(loginCubit.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

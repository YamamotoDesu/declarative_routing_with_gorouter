# [declarative_routing_with_gorouter
](https://youtu.be/5nQQv_nbFqY)
## 📦️ package
```yaml
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  go_router: ^9.1.1
  equatable: ^2.0.5
  flutter_bloc: ^8.1.3
```


## 🔧　Configure App router
lib/config/app_router.dart
```dart
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

```

lib/main.dart
```dart
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Builder(builder: (context) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: AppRouter(context.read<LoginCubit>()).router,
          //home: const CategoryScreen(),
        );
      }),
```

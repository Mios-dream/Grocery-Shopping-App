import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../screen/cart_screen.dart';
import '../screen/category_screen.dart';
import '../screen/home_screen.dart';
import '../screen/intro_screen.dart';
import '../screen/login_screen.dart';
import '../screen/order_detail_screen.dart';
import '../screen/order_screen.dart';
import '../screen/register_screen.dart';
import '../screen/scan_screen.dart';
import '../screen/search_screen.dart';
import '../screen/user_screen.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        name: 'intro',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroScreen();
        },
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        name: 'scan',
        path: '/scan',
        builder: (BuildContext context, GoRouterState state) {
          return const ScanScreen();
        },
      ),
      GoRoute(
          name: 'order',
          path: '/order',
          builder: (BuildContext context, GoRouterState state) {
            return const OrderScreen();
          },
          routes: [
            GoRoute(
              name: 'order-detail',
              path: 'orders/:orderID',
              builder: (BuildContext context, GoRouterState state) {
                return const OrderDetailScreen();
              },
            ),
          ]),
      GoRoute(
        name: 'cart',
        path: '/cart',
        builder: (BuildContext context, GoRouterState state) {
          return const CartScreen();
        },
      ),
      GoRoute(
        name: 'category',
        path: '/category/:categoryID',
        builder: (BuildContext context, GoRouterState state) {
          return CategoryScreen(
            categoryID: state.pathParameters['categoryID']!,
          );
        },
      ),
      GoRoute(
        name: 'search',
        path: '/search',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return child.animate().fadeIn(
                    duration: const Duration(milliseconds: 400),
                    begin: 0.0,
                  );
            },
            child: const SearchScreen(),
          );
        },
      ),
      GoRoute(
        name: 'user',
        path: '/user',
        builder: (BuildContext context, GoRouterState state) {
          return const UserScreen();
        },
      ),
    ],
  );
}

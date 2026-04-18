import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/analytics.dart';
import '../screens/budget_input.dart';
import '../screens/budget_tables.dart';

final GoRouter MainRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const BudgetInputPage();
      },
    ),
    GoRoute(
      path: '/tables',
      builder: (BuildContext context, GoRouterState state) {
        return const BudgetTablesPage();
      },
    ),
    GoRoute(
      path: '/analytics',
      builder: (BuildContext context, GoRouterState state) {
        return const AnalyticsPage();
      },
    ),
  ],
);

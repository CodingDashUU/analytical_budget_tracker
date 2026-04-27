// Copyright (C) 2026 CodingDashUU
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

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

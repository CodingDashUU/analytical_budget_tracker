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

import 'package:signals_flutter/signals_flutter.dart';

import '../models/budget_item.dart';

class BudgetInfo {
  FlutterSignal<String> name = signal("");
  FlutterSignal<String> currency = signal("");
  FlutterSignal<String> incomeName = signal("");
  FlutterSignal<String> expenseName = signal("");
  FlutterSignal<DateTime> budgetDate = signal(DateTime.now());

  late FlutterComputed<bool> incomeNameNotEmpty = computed(() => incomeName.value.isNotEmpty);
  late FlutterComputed<bool> expenseNameNotEmpty = computed(() => expenseName.value.isNotEmpty);

  FlutterSignal<List<BudgetItem>> incomeItems = signal([]);
  FlutterSignal<List<BudgetItem>> expenseItems = signal([]);
}

final budgetInfo = BudgetInfo();
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
import 'package:signals/signals.dart';

import '../models/budget_item.dart';
import 'budget_info.dart';

class AnalysisModel {
  double get incomeAvg => budgetInfo.incomeItems.value.isNotEmpty ? (budgetInfo.incomeItems.value.map((e) => e.amount).fold(0.0, (a, b) => a + b) / budgetInfo.incomeItems.value.length) : 0;
  double get expenseAvg => budgetInfo.expenseItems.value.isNotEmpty ? (budgetInfo.expenseItems.value.map((e) => e.amount).fold(0.0, (a, b) => a + b) / budgetInfo.expenseItems.value.length) : 0;

  BudgetItem get lowestIncome => budgetInfo.incomeItems.value.isEmpty ? BudgetItem("None", 0.0) : budgetInfo.incomeItems.value.reduce((a, b) => a.amount < b.amount ? a : b);
  BudgetItem get lowestExpense => budgetInfo.expenseItems.value.isEmpty ? BudgetItem("None", 0.0) : budgetInfo.expenseItems.value.reduce((a, b) => a.amount < b.amount ? a : b);

  BudgetItem get highestIncome => budgetInfo.incomeItems.value.isEmpty ? BudgetItem("None", 0.0) : budgetInfo.incomeItems.value.reduce((a, b) => a.amount > b.amount ? a : b);
  BudgetItem get highestExpense => budgetInfo.expenseItems.value.isEmpty ? BudgetItem("None", 0.0) : budgetInfo.expenseItems.value.reduce((a, b) => a.amount > b.amount ? a : b);

  Computed<double> totalIncome = computed(() => budgetInfo.incomeItems.value
      .map((e) => e.amount)
      .fold(0.0, (a, b) => a + b));
  Computed<double> totalExpenses = computed(() => budgetInfo.expenseItems.value
      .map((e) => e.amount)
      .fold(0.0, (a, b) => a + b));

  double get verdict => totalIncome.value - totalExpenses.value;
  String get verdictText => switch(verdict) {
    < 0 => "LOSS",
    0 => "BREAK-EVEN",
    >0 => "SURPLUS",
    _ => "ERROR",
  };
  Color get verdictColor => switch(verdict) {
    < 0 => Colors.red,
    0 => Colors.orange,
  >0 => Colors.green,
  _ => Colors.black,
  };
}

final analysisModel = AnalysisModel();
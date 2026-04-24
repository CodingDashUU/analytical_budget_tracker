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
    0 => "BREAKTHROUGH",
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
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

import '../state/budget_info.dart';
import 'budget_item.dart';

enum BudgetType {
  income("Income", Colors.greenAccent),
  expense("Expense", Colors.redAccent);

  final String representation;
  final Color representationColor;

  // Constructor remains const, but we removed the 'items' field
  const BudgetType(this.representation, this.representationColor);

  // Use a getter to fetch the dynamic data
  Signal<List<BudgetItem>> get items {
    switch (this) {
      case BudgetType.income:
        return budgetInfo.incomeItems;
      case BudgetType.expense:
        return budgetInfo.expenseItems; // Assuming expenseItems exists
    }
  }
}
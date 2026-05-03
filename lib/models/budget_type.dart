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

import '../state/budget_info.dart';
import 'budget_item.dart';

enum BudgetType {
  income("Income", Colors.greenAccent),
  expense("Expense", Colors.redAccent);

  final String representation;
  final Color representationColor;

  const BudgetType(this.representation, this.representationColor);

  Signal<List<BudgetItem>> get items {
    switch (this) {
      case BudgetType.income:
        return budgetInfo.incomeItems;
      case BudgetType.expense:
        return budgetInfo.expenseItems;
    }
  }
}
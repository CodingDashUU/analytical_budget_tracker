import 'package:flutter/material.dart';

enum BudgetType {
  income("Income", Colors.greenAccent),
  expense("Expense", Colors.redAccent);
  final String representation;
  final Color representationColor;
  const BudgetType(this.representation, this.representationColor);
}
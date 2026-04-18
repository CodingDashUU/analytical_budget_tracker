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
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

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../models/budget_item.dart';

class BudgetInfo {
  FlutterSignal<String> name = signal("");
  FlutterSignal<String> currency = signal("");
  FlutterSignal<String> incomeName = signal("");
  FlutterSignal<String> expenseName = signal("");
  FlutterSignal<double> incomeValue = signal(1.0);
  FlutterSignal<double> expenseValue = signal(1.0);
  FlutterSignal<DateTime> budgetDate = signal(DateTime.now());

  late FlutterComputed<bool> incomeNameNotEmpty = computed(() => incomeName.value.isNotEmpty);
  late FlutterComputed<bool> expenseNameNotEmpty = computed(() => expenseName.value.isNotEmpty);

  FlutterSignal<List<BudgetItem>> incomeItems = signal([]);
  FlutterSignal<List<BudgetItem>> expenseItems = signal([]);

  BudgetInfo();

  Map<String, dynamic> toMap() {
    return {
      "name": name.value,
      "currency": currency.value,
      "incomeName": incomeName.value,
      "expenseName": expenseName.value,
      "incomeValue": incomeValue.value,
      "expenseValue": expenseValue.value,
      "budgetDate": budgetDate.value,
      "incomeItems": Uint8List.fromList(utf8.encode(jsonEncode(incomeItems))),
      "expenseItems": Uint8List.fromList(utf8.encode(jsonEncode(expenseItems)))
    };
  }

  BudgetInfo.fromMap(Map<dynamic, dynamic> map, Box box)
      :
        name = signal((map["name"] ?? "").toString()),
        currency = signal((map["currency"] ?? "").toString()),
        incomeName = signal((map["incomeName"] ?? "").toString()),
        expenseName = signal((map["expenseName"] ?? "").toString()),
        incomeValue = signal(
            (double.tryParse(map["incomeValue"].toString()) ?? 0.0).clamp(
                1.0, 1000000000)),
        expenseValue = signal(
            (double.tryParse(map["expenseValue"].toString()) ?? 0.0).clamp(
                1.0, 1000000000)),
        budgetDate = signal(
            ((map["budgetDate"] ?? DateTime.now()) as DateTime)),
        incomeItems = signal(
            (jsonDecode(map["incomeItems"] ?? "[]") as List<dynamic>)
                .mapIndexed((i, e) => BudgetItem.fromJson(e, i + 1))
                .toList()),
        expenseItems = signal(
            (jsonDecode(map["expenseItems"] ?? "[]") as List<dynamic>)
                .mapIndexed((i, e) => BudgetItem.fromJson(e, i + 1))
                .toList()) {
    effect(() {
      box.put('name', name.value);
      box.put('currency', currency.value);
      box.put('incomeName', incomeName.value);
      box.put('expenseName', expenseName.value);
      box.put('incomeValue', incomeValue.value);
      box.put('expenseValue', expenseValue.value);
      box.put('budgetDate', budgetDate.value);
      box.put('incomeItems', jsonEncode(incomeItems.value));
      box.put('expenseItems', jsonEncode(expenseItems.value));
    });
  }

}

BudgetInfo budgetInfo = BudgetInfo();
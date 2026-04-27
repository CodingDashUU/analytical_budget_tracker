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

import '../models/budget_type.dart';
import '../models/months.dart';
import '../state/budget_info.dart';
import '../widgets/budget_list.dart';
import '../widgets/budget_table.dart';
import '../widgets/drawer.dart';

class BudgetTablesPage extends StatefulWidget {
  const BudgetTablesPage({super.key});
  @override
  State<BudgetTablesPage> createState() => _BudgetTablesPageState();
}

class _BudgetTablesPageState extends State<BudgetTablesPage> {
  bool isListModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = constraints.maxWidth > 600;
        return Scaffold(
          appBar: AppBar(title: const Text("Budget Tables")),
          drawer: AppDrawer(),
          floatingActionButton: isLarge ? FloatingActionButton(
            onPressed: () => setState(() {
                    isListModeEnabled = !isListModeEnabled;
                  }),
            child: Icon(isListModeEnabled ? Icons.table_chart : Icons.list),
          ) : null,
          body: isLarge && !isListModeEnabled
                ? DesktopLayout()
                : MobileLayout(),
          );
      },
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: ListView(

      children: [
        Text(
          "Budget for ${budgetInfo.name.value.isNotEmpty ? budgetInfo.name.value : 'You'} of ${months[budgetInfo.budgetDate.value.month]} ${budgetInfo.budgetDate.value.year}",
          style: TextStyle(fontSize: 25),
          textAlign: .center,
        ),
        BudgetList(
          budgetType: BudgetType.income,
          onDelete: (item) => budgetInfo.incomeItems.value.remove(item)
        ),
        SizedBox(height: 30),
        BudgetList(
          budgetType: BudgetType.expense,
            onDelete: (item) => budgetInfo.expenseItems.value.remove(item)
        ),
        SizedBox(height: 30),
      ],
    ));
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Budget for ${budgetInfo.name.value.isNotEmpty ? budgetInfo.name.value : 'You'} of ${months[budgetInfo.budgetDate.value.month]} ${budgetInfo.budgetDate.value.year}",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 10),
          BudgetTable(
            type: BudgetType.income,
            itemTableLabel: 'Income Source',
            amountTableLabel: 'Amount',
            headerColor: Colors.green,
          ),
          SizedBox(height: 30),
          BudgetTable(
            type: BudgetType.expense,
            itemTableLabel: 'Expense Item',
            amountTableLabel: 'Cost',
            headerColor: Colors.red,
          ),
          SizedBox(height: 30),
        ],
      ),
    ));
  }
}
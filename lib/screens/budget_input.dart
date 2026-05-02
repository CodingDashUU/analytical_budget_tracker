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

import 'package:budget_tracker/widgets/advanced_spinbox.dart';
import 'package:budget_tracker/widgets/advanced_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:signals/signals_flutter.dart';

import '../models/budget_item.dart';
import '../state/budget_info.dart';
import '../widgets/drawer.dart';

class BudgetInputPage extends StatefulWidget {
  const BudgetInputPage({super.key});

  @override
  State<BudgetInputPage> createState() => _BudgetInputPageState();
}

class _BudgetInputPageState extends State<BudgetInputPage> {
  final nameController = TextEditingController(text: budgetInfo.name.value);
  final currencyController = TextEditingController(
    text: budgetInfo.currency.value,
  );
  final incomeNameController = TextEditingController(
    text: budgetInfo.incomeName.value,
  );
  final expenseNameController = TextEditingController(
    text: budgetInfo.expenseName.value,
  );

  void addIncomeItem() {
    budgetInfo.incomeItems.value.add(
      BudgetItem(budgetInfo.incomeName.value, budgetInfo.incomeValue.value),
    );
    budgetInfo.incomeName.value = "";
    budgetInfo.incomeValue.value = 1.0;
    incomeNameController.clear();
  }

  void addExpenseItem() {
    budgetInfo.expenseItems.value.add(
      BudgetItem(budgetInfo.expenseName.value, budgetInfo.expenseValue.value),
    );
    budgetInfo.expenseName.value = "";
    budgetInfo.expenseValue.value = 1.0;
    expenseNameController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    currencyController.dispose();
    incomeNameController.dispose();
    expenseNameController.dispose();
    super.dispose();
  }

  Widget _buildIncomeTextFieldsGrid() {
    return MasonryGridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AdvancedTextField(
                    controller: incomeNameController,
                    value: budgetInfo.incomeName,
                    labelText: "Income Name",
                    hintText: "Salary, Advertisements",
                    prefixIcon: Icons.arrow_circle_up_outlined,
                    regexPattern: r"^[a-zA-Z ]+",
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AdvancedSpinbox(
                    labelText: "Income Amount",
                    currency: budgetInfo.currency.value,
                    amountSignal: budgetInfo.incomeValue,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  List<Widget> _buildIncomeTextField() {
    return [
      AdvancedTextField(
        controller: incomeNameController,
        value: budgetInfo.incomeName,
        labelText: "Income Name",
        hintText: "Salary, Advertisements",
        prefixIcon: Icons.arrow_circle_up_outlined,
        regexPattern: r"^[a-zA-Z ]+",
      ),
      AdvancedSpinbox(
        labelText: "Income Amount",
        currency: budgetInfo.currency.value,
        amountSignal: budgetInfo.incomeValue,
      ),
    ];
  }

  Widget _buildExpenseTextFieldsGrid() {
    return MasonryGridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AdvancedTextField(
                    controller: expenseNameController,
                    value: budgetInfo.expenseName,
                    labelText: "Expense Name",
                    hintText: "Mortgage, Rent, Groceries",
                    prefixIcon: Icons.arrow_circle_down_outlined,
                    regexPattern: r"^[a-zA-Z ]+",
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AdvancedSpinbox(
                    labelText: "Expense Amount",
                    currency: budgetInfo.currency.value,
                    amountSignal: budgetInfo.expenseValue,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  List<Widget> _buildExpenseTextField() {
    return [
      AdvancedTextField(
        controller: expenseNameController,
        value: budgetInfo.expenseName,
        labelText: "Expense Name",
        hintText: "Mortgage, Rent, Groceries",
        prefixIcon: Icons.arrow_circle_down_outlined,
        regexPattern: r"^[a-zA-Z ]+",
      ),
      AdvancedSpinbox(
        labelText: "Expense Amount",
        currency: budgetInfo.currency.value,
        amountSignal: budgetInfo.expenseValue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Input")),
      drawer: AppDrawer(),
        body: LayoutBuilder(
            builder: (context, constraints) {
              final isLarge = constraints.maxWidth > 600;
              return Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Watch(
            (context) => Column(
              mainAxisAlignment: .center,
              children: [
                AdvancedTextField(
                  controller: nameController,
                  value: budgetInfo.name,
                  labelText: "Enter a name",
                  hintText:
                      "John, Frank Jefferson, The Bali Family, The Mia Company",
                  helperText: "first, full, family, company or fake name",
                  prefixIcon: Icons.person,
                  regexPattern: r"^[a-zA-Z'&-:, ]+",
                  maxLength: 30,
                ),
                SizedBox(height: 5),
                AdvancedTextField(
                  controller: currencyController,
                  value: budgetInfo.currency,
                  labelText: "Enter your currency",
                  hintText: r"$, USD",
                  helperText: "symbol or full initials",
                  prefixIcon: Icons.attach_money,
                  maxLength: 3,
                  regexPattern: r"^[^ \d]+",
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Select the month and year of your budget",
                      style: const TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 100,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.monthYear,
                        onDateTimeChanged: (DateTime value) =>
                            budgetInfo.budgetDate.value = value,
                        initialDateTime: budgetInfo.budgetDate.value,
                      ),
                    ),
                  ],
                ),
                Divider(),
                if (isLarge)
                  _buildIncomeTextFieldsGrid()
                else
                  ..._buildIncomeTextField(),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: budgetInfo.incomeName.value.isNotEmpty
                      ? () {
                    if (budgetInfo.incomeItems.value
                        .map((i) => i.name)
                        .contains(budgetInfo.incomeName.value)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: ${budgetInfo.incomeName
                                .value} already exists as an income source',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Success: ${budgetInfo.incomeName
                              .value} successfully added',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                    addIncomeItem();
                  }
                      : null,
                  child: Text("Add Income Item", textAlign: .center),
                ),
                SizedBox(height: 20),
                if (isLarge)
                  _buildExpenseTextFieldsGrid()
                else
                  ..._buildExpenseTextField(),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: budgetInfo.expenseName.value.isNotEmpty
                      ? () {
                    if (budgetInfo.expenseItems.value
                        .map((i) => i.name)
                        .contains(budgetInfo.expenseName.value)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: ${budgetInfo.expenseName
                                .value} already exists as an expense',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Success: ${budgetInfo.expenseName
                              .value} successfully added',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                    addExpenseItem();
                  }
                      : null,
                  child: Text("Add Expense Item", textAlign: .center),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
              );
            }
        ));
  }
}

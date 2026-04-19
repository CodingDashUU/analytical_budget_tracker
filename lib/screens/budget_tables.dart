import 'package:flutter/material.dart';

import '../models/budget_type.dart';
import '../models/months.dart';
import '../state/analysis_model.dart';
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
          items: budgetInfo.incomeItems.value,
          budgetType: BudgetType.income,
          onDelete: (item) => budgetInfo.incomeItems.value.remove(item)
        ),
        IncomeTotalTile(),
        SizedBox(height: 30),
        BudgetList(
          items: budgetInfo.expenseItems.value,
          budgetType: BudgetType.expense,
            onDelete: (item) => budgetInfo.expenseItems.value.remove(item)
        ),
        ExpenseTotalTile(),
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
            items: budgetInfo.incomeItems.value,
            itemTableLabel: 'Income Source',
            amountTableLabel: 'Amount',
            headerColor: Colors.green,
          ),
          SizedBox(height: 30),
          BudgetTable(
            items: budgetInfo.expenseItems.value,
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

class IncomeTotalTile extends StatefulWidget {
  const IncomeTotalTile({super.key});

  @override
  State<StatefulWidget> createState() => _IncomeTotalTileState();
}

class _IncomeTotalTileState extends State<IncomeTotalTile> {
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.arrow_upward, color: Colors.lightGreenAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Income", // Or item.category
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              "${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.totalIncome}",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: BudgetType.income.representationColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
class ExpenseTotalTile extends StatefulWidget {
  const ExpenseTotalTile({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseTotalTileState();
}

class _ExpenseTotalTileState extends State<ExpenseTotalTile> {
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.redAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Expense", // Or item.category
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              "${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.totalExpenses}",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: BudgetType.expense.representationColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
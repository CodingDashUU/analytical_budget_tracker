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
import 'package:budget_tracker/state/analysis_model.dart';
import 'package:budget_tracker/state/budget_info.dart';
import 'package:budget_tracker/widgets/verdict_card.dart';
import 'package:flutter/material.dart';
import '../models/months.dart';
import '../widgets/donut_chart.dart';
import '../widgets/drawer.dart';
import '../widgets/stat_card.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int touchedIndex = -1;
  static const int MAX_WIDTH = 1200;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLarge = constraints.maxWidth > MAX_WIDTH;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: constraints.maxWidth, // 1 per row on mobile
                    child: Text(
                      "Budget Analysis for ${budgetInfo.name.value.isNotEmpty ? budgetInfo.name.value : 'You'} of ${months[budgetInfo.budgetDate.value.month]} ${budgetInfo.budgetDate.value.year}",
                      textAlign: .center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight(500),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: isLarge
                        ? (constraints.maxWidth / 3) -
                              16 // 3 per row on large
                        : constraints.maxWidth, // 1 per row on mobile
                    child: Column(
                      children: [
                        Text(
                          "Income Distribution",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(900),
                          ),
                        ),
                        if (budgetInfo.incomeItems.value.isNotEmpty)
                          DonutChart(
                            data: budgetInfo.incomeItems.value
                                .map((e) => MapEntry(e.name, e.amount))
                                .toList(),
                          )
                        else
                          Text("No Income Source yet"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isLarge
                        ? (constraints.maxWidth / 3) -
                              16 // 3 per row on large
                        : constraints.maxWidth, // 1 per row on mobile
                    child: Column(
                      children: [
                        Text(
                          "Expense Distribution",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(900),
                          ),
                        ),
                        if (budgetInfo.expenseItems.value.isNotEmpty)
                          DonutChart(
                            data: budgetInfo.expenseItems.value
                                .map((e) => MapEntry(e.name, e.amount))
                                .toList(),
                          )
                        else
                          Text("No Expense Item yet"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isLarge
                        ? (constraints.maxWidth / 3) -
                              16 // 3 per row on large
                        : constraints.maxWidth, // 1 per row on mobile
                    child: Column(
                      children: [
                        Text(
                          "Income and Expense Distribution",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(900),
                          ),
                        ),
                        DonutChart(
                          colors: [Colors.green, Colors.red],
                          data: [
                            MapEntry(
                              "Income Total",
                              budgetInfo.incomeItems.value
                                  .map((e) => e.amount)
                                  .fold(0, (a, b) => a + b),
                            ),
                            MapEntry(
                              "Expense Total",
                              budgetInfo.expenseItems.value
                                  .map((e) => e.amount)
                                  .fold(0, (a, b) => a + b),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isLarge
                        ? (constraints.maxWidth / 3) -
                              16 // 3 per row on large
                        : constraints.maxWidth, // 1 per row on mobile
                    child: Column(
                      children: [
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth,
                          child: Text(
                            "Income",
                            textAlign: .center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth,
                          child: StatCard(
                            title: "Average Income Earnings",
                            value:
                                "${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.incomeAvg.toStringAsFixed(2)}",
                            icon: Icon(Icons.linear_scale, color: Colors.green),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth,
                          child: StatCard(
                            title: "Lowest Income Source Earnings",
                            value:
                                "${analysisModel.lowestIncome.name}\n${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.lowestIncome.amount.toStringAsFixed(2)}",
                            icon: Icon(
                              Icons.arrow_circle_down,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth,
                          child: StatCard(
                            title: "Highest Income Source Earnings",
                            value:
                                "${analysisModel.highestIncome.name}\n${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.highestIncome.amount.toStringAsFixed(2)}",
                            icon: Icon(
                              Icons.arrow_circle_up,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isLarge
                        ? (constraints.maxWidth / 3) -
                              16 // 3 per row on large
                        : constraints.maxWidth, // 1 per row on mobile
                    child: Column(
                      children: [
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth, // 1 per row on mobile
                          child: Text(
                            "Expenses",
                            textAlign: .center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth, // 1 per row on mobile
                          child: StatCard(
                            title: "Average Expense Cost",
                            value:
                                "${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.expenseAvg.toStringAsFixed(2)}",
                            icon: Icon(Icons.linear_scale, color: Colors.red),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth, // 1 per row on mobile
                          child: StatCard(
                            title: "Lowest Expense Cost",
                            value:
                                "${analysisModel.lowestExpense.name}\n${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.lowestExpense.amount.toStringAsFixed(2)}",
                            icon: Icon(
                              Icons.arrow_circle_down,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) -
                                    16 // 3 per row on large
                              : constraints.maxWidth, // 1 per row on mobile
                          child: StatCard(
                            title: "Highest Expense Cost",
                            value:
                                "${analysisModel.highestExpense.name}\n${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.highestExpense.amount.toStringAsFixed(2)}",
                            icon: Icon(
                              Icons.arrow_circle_up,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isLarge
                        ? (constraints.maxWidth / 3) - 16
                        : constraints.maxWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) - 16
                              : constraints.maxWidth,
                          child: Text(
                            "Verdict",
                            textAlign: .center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: isLarge
                              ? (constraints.maxWidth / 3) - 16
                              : constraints.maxWidth,
                          child: VerdictCard(isLarge: isLarge),
                        ),
                        SizedBox(
                            height: 50
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../models/budget_item.dart';
import '../models/budget_type.dart';
import '../state/analysis_model.dart';
import '../state/budget_info.dart';

class BudgetList extends StatefulWidget {
  final BudgetType budgetType;
  final Function(BudgetItem)? onDelete;
  final Function(BudgetItem)? onTap;

  const BudgetList({
    super.key,
    this.onDelete,
    this.onTap, required this.budgetType,
  });
  @override
  State<StatefulWidget> createState() => _BudgetListState();

}
class _BudgetListState extends State<BudgetList> {

  String _format(double amount) {
    return '${budgetInfo.currency.isNotEmpty ? "${budgetInfo.currency} " : ""}${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.budgetType.items.isEmpty) return _EmptyState(budgetType: widget.budgetType,);

    return Watch((context) => Column(
      children: [
        ...widget.budgetType.items.value.mapIndexed(
              (index, item) =>
                  Dismissible(
                    key: Key(widget.budgetType.items.value[index].name),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) => setState(() => widget.budgetType.items.removeAt(index)),
                    background: _buildSwipeBackground(),
                    child: _BudgetCard(
                        item: item,
                        formattedAmount: _format(item.amount),
                        onTap: () => widget.onTap?.call(item),
                        budgetType: widget.budgetType
                    ),
                  )
      ),
        BudgetTotalTile(budgetType: widget.budgetType,)
      ]
    ));
  }

  Widget _buildSwipeBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline, color: Colors.redAccent),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetItem item;
  final String formattedAmount;
  final VoidCallback? onTap;
  final BudgetType budgetType;

  const _BudgetCard({
    required this.item,
    required this.formattedAmount,
    required this.budgetType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildCategoryIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      budgetType.representation, // Or item.category
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formattedAmount,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: budgetType.representationColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (budgetType.representationColor).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        budgetType.representation == BudgetType.expense.representation ? Icons.arrow_downward : Icons.arrow_upward,
        size: 20,
        color: budgetType.representationColor,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final BudgetType budgetType;
  const _EmptyState({required this.budgetType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Add an ${budgetType.representation} to see it here.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetTotalTile extends StatelessWidget {
  final BudgetType budgetType;
  const BudgetTotalTile({super.key, required this.budgetType});

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
            Icon(budgetType == BudgetType.income ? Icons.arrow_upward : Icons.arrow_downward,
                color: budgetType == BudgetType.income ? Colors.lightGreenAccent : Colors.redAccent),
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
                    budgetType.representation, // Or item.category
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Watch(
                (context) =>
            Text(
              "${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${budgetType.items.value.map((e) => e.amount)
                  .fold(0.0, (a, b) => a + b).toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: budgetType.representationColor,
            ))),
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
  Widget build(BuildContext context) => Watch((context) => Container(
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
                "${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.totalExpenses.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: BudgetType.expense.representationColor,
                )),
          ],
        ),
      ),
    ),
  ));
}
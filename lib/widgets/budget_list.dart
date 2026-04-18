import 'package:flutter/material.dart';
import '../models/budget_item.dart';
import '../models/budget_type.dart';
import '../state/budget_info.dart';

class BudgetList extends StatefulWidget {
  final List<BudgetItem> items;
  final BudgetType budgetType;
  final Function(BudgetItem)? onDelete;
  final Function(BudgetItem)? onTap;

  const BudgetList({
    super.key,
    required this.items,
    this.onDelete,
    this.onTap, required this.budgetType,
  });
  @override
  State<StatefulWidget> createState() => _BudgetListState();

}
class _BudgetListState extends State<BudgetList> {

  String _format(double amount) {
    return '${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return _EmptyState(budgetType: widget.budgetType,);

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(), // Better feel on both OSs
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return  Dismissible(
            key: Key(widget.items[index].name),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) => setState(() => widget.items.removeAt(index)),
            background: _buildSwipeBackground(),
            child: _BudgetCard(
              item: item,
              formattedAmount: _format(item.amount),
              onTap: () => widget.onTap?.call(item),
              budgetType: widget.budgetType
            ),
          );
        },
      ),
    );
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
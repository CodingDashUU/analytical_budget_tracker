class BudgetItem {
  final String name;
  final double amount;

  const BudgetItem(this.name, this.amount);

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
  };
}
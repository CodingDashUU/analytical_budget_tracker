class BudgetItem {
  final String name;
  final double amount;

  const BudgetItem(this.name, this.amount);

  BudgetItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        amount = (json['amount'] as num).toDouble();

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
  };
}
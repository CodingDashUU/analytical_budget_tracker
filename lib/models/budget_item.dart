

class BudgetItem {
  final String name;
  final double amount;

  const BudgetItem(this.name, this.amount);

  BudgetItem.fromJson(Map<String, dynamic> json, int index)
      : name = (json['name'].toString()
      .replaceAllMapped(RegExp(r"[^a-zA-Z- ]"), (m) => ""))
      .isNotEmpty && (json['name'] as Object?) != null ? json['name']
      .toString()
      .replaceAll(RegExp(r"[^a-zA-Z- ]"), "") : "Item $index",
        amount = (double.tryParse(json['amount'].toString()) ?? 0.0).clamp(
            1.0, 1000000000.0);

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
  };
}
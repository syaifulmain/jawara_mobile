class IncomeRequestModel {
  final String name;
  final String incomeType;
  final String date;
  final num amount;

  IncomeRequestModel({
    required this.name,
    required this.incomeType,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'income_type': incomeType,
      'date': date,
      'amount': amount,
    };
  }
}

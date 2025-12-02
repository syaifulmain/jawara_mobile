class IncomeListModel {
  final int id;
  final String name;
  final String incomeType;
  final String date;
  final num amount; // UBAH DARI STRING → NUM
  final String? dateVerification;
  final dynamic verification;

  IncomeListModel({
    required this.id,
    required this.name,
    required this.incomeType,
    required this.date,
    required this.amount,
    this.dateVerification,
    this.verification,
  });

  factory IncomeListModel.fromJson(Map<String, dynamic> json) {
    return IncomeListModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      incomeType: json['income_type'] ?? '',
      date: json['date'] ?? '',
      amount: num.tryParse(json['amount'].toString()) ?? 0, // FIX DI SINI
      dateVerification: json['date_verification'],
      verification: json['verification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'income_type': incomeType,
      'date': date,
      'amount': amount,
      'date_verification': dateVerification,
      'verification': verification,
    };
  }
}

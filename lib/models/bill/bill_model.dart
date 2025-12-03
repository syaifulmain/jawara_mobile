import '../../enums/bill_status.dart';
import '../../enums/income_type.dart';

class BillModel {
  final int? id;
  final String code;
  final int? familyId;
  final int? incomeCategoryId;
  final DateTime period;
  final double amount;
  final BillStatus status;
  final String? paymentProof;
  final DateTime? paidAt;
  final int? verifiedBy;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final int? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relationship data
  final String? familyName;
  final String? familyAddress;
  final String? categoryName;
  final IncomeType? categoryType;
  final String? verifiedByName;

  BillModel({
    this.id,
    required this.code,
    this.familyId,
    this.incomeCategoryId,
    required this.period,
    required this.amount,
    required this.status,
    this.paymentProof,
    this.paidAt,
    this.verifiedBy,
    this.verifiedAt,
    this.rejectionReason,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    // Relationship data
    this.familyName,
    this.familyAddress,
    this.categoryName,
    this.categoryType,
    this.verifiedByName,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely extract ID from various formats
    int? extractId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          return null;
        }
      }
      if (value is Map<String, dynamic> && value.containsKey('id')) {
        final id = value['id'];
        if (id is int) return id;
        if (id is String) {
          try {
            return int.parse(id);
          } catch (e) {
            return null;
          }
        }
      }
      return null;
    }

    return BillModel(
      id: json['id'] as int?,
      code: json['code'] as String? ?? '',
      familyId: extractId(json['family_id']) ?? extractId(json['family']),
      incomeCategoryId: extractId(json['income_category_id']) ?? extractId(json['income_category']),
      period: json['period'] != null ? DateTime.parse(json['period'] as String) : DateTime.now(),
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      status: BillStatus.fromString(json['status'] as String? ?? 'unpaid'),
      paymentProof: json['payment_proof'] as String?,
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      verifiedBy: extractId(json['verified_by']),
      verifiedAt: json['verified_at'] != null ? DateTime.parse(json['verified_at'] as String) : null,
      rejectionReason: json['rejection_reason'] as String?,
      createdBy: extractId(json['created_by']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
      // Handle relationship data
      familyName: _extractFamilyName(json),
      familyAddress: _extractFamilyAddress(json),
      categoryName: _extractCategoryName(json),
      categoryType: _extractCategoryType(json),
      verifiedByName: _extractVerifiedByName(json),
    );
  }

  static String? _extractFamilyName(Map<String, dynamic> json) {
    if (json['family'] is Map<String, dynamic>) {
      return json['family']['name'] as String?;
    }
    return json['family_name'] as String?;
  }

  static String? _extractFamilyAddress(Map<String, dynamic> json) {
    if (json['family'] is Map<String, dynamic>) {
      final family = json['family'] as Map<String, dynamic>;
      if (family['address'] is Map<String, dynamic>) {
        return family['address']['address'] as String?;
      }
    }
    return json['family_address'] as String?;
  }

  static String? _extractCategoryName(Map<String, dynamic> json) {
    if (json['income_category'] is Map<String, dynamic>) {
      return json['income_category']['name'] as String?;
    }
    return json['category_name'] as String?;
  }

  static IncomeType? _extractCategoryType(Map<String, dynamic> json) {
    if (json['income_category'] is Map<String, dynamic>) {
      final typeStr = json['income_category']['type'] as String?;
      return typeStr != null ? IncomeType.fromString(typeStr) : null;
    }
    final typeStr = json['category_type'] as String?;
    return typeStr != null ? IncomeType.fromString(typeStr) : null;
  }

  static String? _extractVerifiedByName(Map<String, dynamic> json) {
    if (json['verified_by_user'] is Map<String, dynamic>) {
      return json['verified_by_user']['name'] as String?;
    }
    return json['verified_by_name'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'family_id': familyId,
      'income_category_id': incomeCategoryId,
      'period': period.toIso8601String().split('T')[0], // Format as date only (YYYY-MM-DD)
      'amount': amount,
      'status': status.value,
      'payment_proof': paymentProof,
      'paid_at': paidAt?.toIso8601String(),
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BillModel copyWith({
    int? id,
    String? code,
    int? familyId,
    int? incomeCategoryId,
    DateTime? period,
    double? amount,
    BillStatus? status,
    String? paymentProof,
    DateTime? paidAt,
    int? verifiedBy,
    DateTime? verifiedAt,
    String? rejectionReason,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? familyName,
    String? familyAddress,
    String? categoryName,
    IncomeType? categoryType,
    String? verifiedByName,
  }) {
    return BillModel(
      id: id ?? this.id,
      code: code ?? this.code,
      familyId: familyId ?? this.familyId,
      incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
      period: period ?? this.period,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentProof: paymentProof ?? this.paymentProof,
      paidAt: paidAt ?? this.paidAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      familyName: familyName ?? this.familyName,
      familyAddress: familyAddress ?? this.familyAddress,
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      verifiedByName: verifiedByName ?? this.verifiedByName,
    );
  }

  /// Helper method to get display name for family
  String get familyDisplayName {
    return familyName ?? (familyId != null ? 'Family ID: $familyId' : 'Unknown Family');
  }

  /// Helper method to get display name for category
  String get categoryDisplayName {
    return categoryName ?? (incomeCategoryId != null ? 'Category ID: $incomeCategoryId' : 'Unknown Category');
  }

  /// Helper method to get formatted amount
  String get formattedAmount {
    return 'Rp ${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  /// Helper method to get formatted period (e.g., "Januari 2024", "Februari 2024")
  String get formattedPeriod {
    const monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${monthNames[period.month - 1]} ${period.year}';
  }

  /// Helper method to get short formatted period (e.g., "Jan 2024", "Feb 2024")
  String get shortFormattedPeriod {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${monthNames[period.month - 1]} ${period.year}';
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../enums/bill_status.dart';
import '../models/bill/bill_model.dart';
import 'api_exception.dart';

class BillService {
  // Get all bills with pagination
  Future<Map<String, dynamic>> getBills(
    String token, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.bills}?page=$page&per_page=$perPage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Bills API Response: ${response.statusCode}');
      print('Bills API Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Handle different response structures
        List<dynamic> billsJson;
        if (data.containsKey('data')) {
          billsJson = data['data'] as List<dynamic>;
        } else {
          // Assume the response is directly a list
          billsJson = data as List<dynamic>? ?? [];
        }
        
        final bills = billsJson
            .map((json) => BillModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Check if backend supports server-side pagination
        final hasServerPagination = data.containsKey('current_page') && 
                                     data.containsKey('last_page');
        
        // Return data with pagination info
        return {
          'bills': bills,
          'current_page': data['current_page'] ?? page,
          'last_page': data['last_page'] ?? 1,
          'total': data['total'] ?? bills.length,
          'has_more': hasServerPagination 
              ? (data['current_page'] ?? page) < (data['last_page'] ?? 1)
              : false,
          'use_client_pagination': !hasServerPagination,
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get bills',
        );
      }
    } catch (e) {
      print('Error in getBills: $e');
      throw ApiException('Failed to get bills: $e');
    }
  }

  // Get bill by ID
  Future<BillModel> getBillById(String token, String billId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.bills}/$billId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Bill By ID Response: ${response.statusCode}');
      print('Get Bill By ID Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Handle different response structures
        Map<String, dynamic> billJson;
        if (data.containsKey('data')) {
          billJson = data['data'] as Map<String, dynamic>;
        } else {
          billJson = data;
        }
        
        return BillModel.fromJson(billJson);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get bill',
        );
      }
    } catch (e) {
      print('Error in getBillById: $e');
      throw ApiException('Failed to get bill: $e');
    }
  }

  // Search bills
  Future<List<BillModel>> searchBills(String token, String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.bills}/search?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Search Bills Response: ${response.statusCode}');
      print('Search Bills Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Handle different response structures
        List<dynamic> billsJson;
        if (data.containsKey('data')) {
          billsJson = data['data'] as List<dynamic>;
        } else {
          // Assume the response is directly a list
          billsJson = data as List<dynamic>? ?? [];
        }
        
        return billsJson
            .map((json) => BillModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to search bills',
        );
      }
    } catch (e) {
      print('Error in searchBills: $e');
      throw ApiException('Failed to search bills: $e');
    }
  }

  // Filter bills by status
  Future<List<BillModel>> getBillsByStatus(String token, BillStatus status) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.bills}?status=${status.value}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Filter Bills Response: ${response.statusCode}');
      print('Filter Bills Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Handle different response structures
        List<dynamic> billsJson;
        if (data.containsKey('data')) {
          billsJson = data['data'] as List<dynamic>;
        } else {
          // Assume the response is directly a list
          billsJson = data as List<dynamic>? ?? [];
        }
        
        return billsJson
            .map((json) => BillModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get bills by status',
        );
      }
    } catch (e) {
      print('Error in getBillsByStatus: $e');
      throw ApiException('Failed to get bills by status: $e');
    }
  }

  // Filter bills by period
  Future<List<BillModel>> getBillsByPeriod(String token, String period) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.bills}?period=$period'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> billsJson = data['data'];
        return billsJson
            .map((json) => BillModel.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get bills by period',
        );
      }
    } catch (e) {
      throw ApiException('Failed to get bills by period: $e');
    }
  }

  // Filter bills by status and period
  Future<List<BillModel>> getBillsByStatusAndPeriod(
    String token,
    BillStatus? status,
    String? period,
  ) async {
    try {
      String queryParams = '';
      List<String> params = [];
      
      if (status != null) {
        params.add('status=${status.value}');
      }
      
      if (period != null && period.isNotEmpty) {
        params.add('period=$period');
      }
      
      if (params.isNotEmpty) {
        queryParams = '?${params.join('&')}';
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.bills}$queryParams'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> billsJson = data['data'];
        return billsJson
            .map((json) => BillModel.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get filtered bills',
        );
      }
    } catch (e) {
      throw ApiException('Failed to get filtered bills: $e');
    }
  }

  // Update bill status (for verification)
  Future<bool> updateBillStatus(
    String token,
    String billId,
    BillStatus status, {
    String? notes,
  }) async {
    try {
      // This method is deprecated, use markAsPaid or verifyPayment instead
      print('Warning: updateBillStatus is deprecated. Use markAsPaid or verifyPayment instead.');
      
      final response = await http.put(
        Uri.parse('${ApiConstants.bills}/$billId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status.value,
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to update bill status',
        );
      }
    } catch (e) {
      throw ApiException('Failed to update bill status: $e');
    }
  }

  // Mark bill as paid (based on backend route: PATCH /bills/{id}/mark-paid)
  Future<bool> markAsPaid(
    String token,
    String billId, {
    String? notes,
  }) async {
    try {
      final url = '${ApiConstants.bills}/$billId/mark-paid';
      final body = {
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      print('Mark As Paid URL: $url');
      print('Mark As Paid Body: ${jsonEncode(body)}');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('Mark As Paid Response Status: ${response.statusCode}');
      print('Mark As Paid Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw ApiException(
            errorData['message'] ?? 'Failed to mark bill as paid',
          );
        } catch (e) {
          throw ApiException(
            'Server error (${response.statusCode}): Failed to mark bill as paid',
          );
        }
      }
    } catch (e) {
      print('Mark As Paid Error: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to mark bill as paid: $e');
    }
  }

  // Mark bills as overdue (based on backend route: POST /bills/mark-overdue)
  Future<bool> markAsOverdue(String token) async {
    try {
      final url = '${ApiConstants.bills}/mark-overdue';

      print('Mark As Overdue URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Mark As Overdue Response Status: ${response.statusCode}');
      print('Mark As Overdue Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw ApiException(
            errorData['message'] ?? 'Failed to mark bills as overdue',
          );
        } catch (e) {
          throw ApiException(
            'Server error (${response.statusCode}): Failed to mark bills as overdue',
          );
        }
      }
    } catch (e) {
      print('Mark As Overdue Error: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to mark bills as overdue: $e');
    }
  }

  // Approve payment (based on backend: PATCH /bills/{id}/approve-payment)
  Future<bool> approvePayment(String token, String billId) async {
    try {
      final url = '${ApiConstants.bills}/$billId/approve-payment';

      print('Approve Payment URL: $url');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Approve Payment Response Status: ${response.statusCode}');
      print('Approve Payment Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw ApiException(
            errorData['message'] ?? 'Failed to approve payment',
          );
        } catch (e) {
          throw ApiException(
            'Server error (${response.statusCode}): Failed to approve payment',
          );
        }
      }
    } catch (e) {
      print('Approve Payment Error: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to approve payment: $e');
    }
  }

  // Reject payment (based on backend: PATCH /bills/{id}/reject-payment)
  Future<bool> rejectPayment(
    String token,
    String billId,
    String rejectionReason,
  ) async {
    try {
      final url = '${ApiConstants.bills}/$billId/reject-payment';
      final body = {
        'rejection_reason': rejectionReason,
      };

      print('Reject Payment URL: $url');
      print('Reject Payment Body: ${jsonEncode(body)}');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('Reject Payment Response Status: ${response.statusCode}');
      print('Reject Payment Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw ApiException(
            errorData['message'] ?? 'Failed to reject payment',
          );
        } catch (e) {
          throw ApiException(
            'Server error (${response.statusCode}): Failed to reject payment',
          );
        }
      }
    } catch (e) {
      print('Reject Payment Error: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to reject payment: $e');
    }
  }

  // Legacy method for backward compatibility (deprecated)
  @deprecated
  Future<bool> verifyPayment(
    String token,
    String billId,
    bool approved, {
    String? notes,
  }) async {
    if (approved) {
      return approvePayment(token, billId);
    } else {
      return rejectPayment(token, billId, notes ?? 'Ditolak');
    }
  }

  // Delete bill
  Future<bool> deleteBill(String token, String billId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.bills}/$billId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to delete bill',
        );
      }
    } catch (e) {
      throw ApiException('Failed to delete bill: $e');
    }
  }
}
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
    int? familyId,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String>[];
      queryParams.add('page=$page');
      queryParams.add('per_page=$perPage');
      if (familyId != null) {
        queryParams.add('family_id=$familyId');
      }
      
      final url = '${ApiConstants.bills}?${queryParams.join('&')}';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

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
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

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
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to reject payment: $e');
    }
  }

  // Upload payment proof (for users/warga)
  Future<bool> uploadPaymentProof(
    String token,
    String billId,
    String imagePath,
  ) async {
    try {
      final url = '${ApiConstants.bills}/$billId/upload-payment';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      
      // Add image file - try both possible field names
      request.files.add(
        await http.MultipartFile.fromPath('payment_proof', imagePath),
      );
      
      // Add _method field for Laravel PATCH simulation
      request.fields['_method'] = 'PATCH';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw ApiException(
            errorData['message'] ?? 'Failed to upload payment proof',
          );
        } catch (e) {
          throw ApiException(
            'Server error (${response.statusCode}): Failed to upload payment proof',
          );
        }
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to upload payment proof: $e');
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

  // Create bills for all families (bulk create)
  // POST /bills/generate with income_category_id and periode
  Future<Map<String, dynamic>> createBillsForAllFamilies(
    String token, {
    required int incomeCategoryId,
    required String periode, // Format: YYYY-MM (contoh: 2025-12)
  }) async {
    try {
      final body = {
        'income_category_id': incomeCategoryId,
        'periode': periode,
      };

      print('DEBUG: Generate Bills Request');
      print('URL: ${ApiConstants.bills}/generate');
      print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('${ApiConstants.bills}/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('DEBUG: Response Status: ${response.statusCode}');
      print('DEBUG: Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        String errorMessage = 'Failed to create bills';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
          
          // If there's additional error details
          if (errorData['errors'] != null) {
            errorMessage += '\nDetails: ${errorData['errors']}';
          }
        } catch (e) {
          errorMessage = 'Server error (${response.statusCode}): ${response.body}';
        }
        throw ApiException(errorMessage);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to create bills: $e');
    }
  }
}
import 'package:flutter/material.dart';
import '../enums/bill_status.dart';
import '../models/bill/bill_model.dart';
import '../services/bill_service.dart';
import '../services/api_exception.dart';

class BillProvider with ChangeNotifier {
  final BillService _billService = BillService();

  List<BillModel> _bills = [];
  List<BillModel> _allBills = []; // Cache untuk client-side pagination
  BillModel? _selectedBill;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  
  // Pagination state
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMore = true;
  final int _perPage = 15;
  bool _useClientPagination = false;

  List<BillModel> get bills => _bills;
  BillModel? get selectedBill => _selectedBill;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  // Fetch all bills (reset pagination)
  Future<void> fetchBills(String token) async {
    _setLoading(true);
    _clearError();
    _currentPage = 1;

    try {
      final result = await _billService.getBills(token, page: 1, perPage: _perPage);
      final allBills = result['bills'] as List<BillModel>;
      _useClientPagination = result['use_client_pagination'] as bool? ?? false;
      
      if (_useClientPagination) {
        // Client-side pagination: cache all data, show first page
        _allBills = allBills;
        _bills = _allBills.take(_perPage).toList();
        _currentPage = 1;
        _lastPage = (_allBills.length / _perPage).ceil();
        _hasMore = _allBills.length > _perPage;
      } else {
        // Server-side pagination
        _bills = allBills;
        _currentPage = result['current_page'] as int;
        _lastPage = result['last_page'] as int;
        _hasMore = result['has_more'] as bool;
      }
      
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load more bills (infinite scroll)
  Future<void> loadMoreBills(String token) async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      if (_useClientPagination) {
        // Client-side pagination: slice cached data
        await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading
        
        final nextPage = _currentPage + 1;
        final startIndex = _currentPage * _perPage;
        final endIndex = startIndex + _perPage;
        
        final newBills = _allBills.skip(startIndex).take(_perPage).toList();
        _bills.addAll(newBills);
        _currentPage = nextPage;
        _hasMore = endIndex < _allBills.length;
      } else {
        // Server-side pagination: fetch from API
        final nextPage = _currentPage + 1;
        final result = await _billService.getBills(token, page: nextPage, perPage: _perPage);
        
        final newBills = result['bills'] as List<BillModel>;
        _bills.addAll(newBills);
        _currentPage = result['current_page'] as int;
        _lastPage = result['last_page'] as int;
        _hasMore = result['has_more'] as bool;
      }
      
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Fetch bill by ID
  Future<void> fetchBillById(String token, String billId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedBill = await _billService.getBillById(token, billId);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search bills
  Future<void> searchBills(String token, String query) async {
    _setLoading(true);
    _clearError();

    try {
      _bills = await _billService.searchBills(token, query);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Filter bills by status
  Future<void> fetchBillsByStatus(String token, BillStatus status) async {
    _setLoading(true);
    _clearError();

    try {
      _bills = await _billService.getBillsByStatus(token, status);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Filter bills by period
  Future<void> fetchBillsByPeriod(String token, String period) async {
    _setLoading(true);
    _clearError();

    try {
      _bills = await _billService.getBillsByPeriod(token, period);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Filter bills by status and period
  Future<void> fetchBillsByStatusAndPeriod(
    String token,
    BillStatus? status,
    String? period,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      _bills = await _billService.getBillsByStatusAndPeriod(
        token,
        status,
        period,
      );
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update bill status
  Future<bool> updateBillStatus(
    String token,
    String billId,
    BillStatus status, {
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _billService.updateBillStatus(
        token,
        billId,
        status,
        notes: notes,
      );

      if (success) {
        // Update local data
        final index = _bills.indexWhere((bill) => bill.id.toString() == billId);
        if (index != -1) {
          _bills[index] = _bills[index].copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
        }

        // Update selected bill if it matches
        if (_selectedBill?.id.toString() == billId) {
          _selectedBill = _selectedBill!.copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
        }

        notifyListeners();
      }

      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Approve payment
  Future<bool> approvePayment(
    String token,
    String billId,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _billService.approvePayment(token, billId);

      if (success) {
        // Update local data
        final index = _bills.indexWhere((bill) => bill.id.toString() == billId);
        if (index != -1) {
          _bills[index] = _bills[index].copyWith(
            status: BillStatus.paid,
            verifiedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        // Update selected bill if it matches
        if (_selectedBill?.id.toString() == billId) {
          _selectedBill = _selectedBill!.copyWith(
            status: BillStatus.paid,
            verifiedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        notifyListeners();
      }

      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reject payment
  Future<bool> rejectPayment(
    String token,
    String billId,
    String rejectionReason,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _billService.rejectPayment(
        token,
        billId,
        rejectionReason,
      );

      if (success) {
        // Update local data
        final index = _bills.indexWhere((bill) => bill.id.toString() == billId);
        if (index != -1) {
          _bills[index] = _bills[index].copyWith(
            status: BillStatus.rejected,
            verifiedAt: DateTime.now(),
            rejectionReason: rejectionReason,
            updatedAt: DateTime.now(),
          );
        }

        // Update selected bill if it matches
        if (_selectedBill?.id.toString() == billId) {
          _selectedBill = _selectedBill!.copyWith(
            status: BillStatus.rejected,
            verifiedAt: DateTime.now(),
            rejectionReason: rejectionReason,
            updatedAt: DateTime.now(),
          );
        }

        notifyListeners();
      }

      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Legacy method for backward compatibility
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
    _setLoading(true);
    _clearError();

    try {
      final success = await _billService.deleteBill(token, billId);

      if (success) {
        _bills.removeWhere((bill) => bill.id.toString() == billId);
        if (_selectedBill?.id.toString() == billId) {
          _selectedBill = null;
        }
        notifyListeners();
      }

      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear filter and reload all bills
  void clearFilter() {
    _clearError();
    notifyListeners();
  }

  // Clear selected bill
  void clearSelectedBill() {
    _selectedBill = null;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../enums/bill_status.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/bill_provider.dart';
import '../../../models/bill/bill_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/info_banner.dart';

class BillsListScreen extends StatefulWidget {
  const BillsListScreen({Key? key}) : super(key: key);

  @override
  State<BillsListScreen> createState() => _BillsListScreenState();
}

class _BillsListScreenState extends State<BillsListScreen> {
  BillStatus? _selectedStatus;
  String? _selectedPeriod;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBills();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final authProvider = context.read<AuthProvider>();
      final billProvider = context.read<BillProvider>();
      
      if (authProvider.token != null && 
          billProvider.hasMore && 
          !billProvider.isLoadingMore &&
          _selectedStatus == null && 
          _selectedPeriod == null &&
          _searchController.text.isEmpty) {
        billProvider.loadMoreBills(authProvider.token!);
      }
    }
  }

  void _loadBills() {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      billProvider.fetchBills(authProvider.token!);
    }
  }

  void _applyFilters() {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      if (_selectedStatus == null && _selectedPeriod == null) {
        billProvider.clearFilter();
        billProvider.fetchBills(authProvider.token!);
      } else {
        billProvider.fetchBillsByStatusAndPeriod(
          authProvider.token!,
          _selectedStatus,
          _selectedPeriod,
        );
      }
    }
  }

  void _searchBills(String query) {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        _applyFilters();
      } else {
        billProvider.searchBills(authProvider.token!, query);
      }
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(
        selectedStatus: _selectedStatus,
        selectedPeriod: _selectedPeriod,
        onApply: (status, period) {
          setState(() {
            _selectedStatus = status;
            _selectedPeriod = period;
          });
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = _selectedStatus != null || _selectedPeriod != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tagihan')),
      body: Column(
        children: [
          // Info Header
          const InfoBanner(
            message: 'Daftar semua tagihan yang telah dibuat. Data dimuat 15 per halaman - scroll ke bawah untuk memuat lebih banyak. Klik pada tagihan untuk melihat detail dan melakukan verifikasi pembayaran.',
          ),
          
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _searchController,
                  hintText: 'Cari berdasarkan kode tagihan, nama keluarga...',
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchBills('');
                          },
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: _searchBills,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  onPressed: _showFilterBottomSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.filter_list),
                      const SizedBox(width: 8),
                      Text(
                        hasActiveFilter ? 'Filter Aktif' : 'Filter Tagihan',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Consumer<BillProvider>(
              builder: (context, billProvider, child) {
                if (billProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (billProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${billProvider.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadBills,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (billProvider.bills.isEmpty) {
                  return const Center(child: Text('Tidak ada tagihan'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadBills(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: billProvider.bills.length + (billProvider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Loading indicator di akhir list
                      if (index == billProvider.bills.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: billProvider.isLoadingMore
                                ? const CircularProgressIndicator()
                                : const SizedBox(),
                          ),
                        );
                      }
                      
                      final bill = billProvider.bills[index];
                      return _BillCard(bill: bill, index: index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final BillStatus? selectedStatus;
  final String? selectedPeriod;
  final Function(BillStatus?, String?) onApply;

  const _FilterBottomSheet({
    required this.selectedStatus,
    required this.selectedPeriod,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  BillStatus? _tempStatus;
  String? _tempPeriod;

  @override
  void initState() {
    super.initState();
    _tempStatus = widget.selectedStatus;
    _tempPeriod = widget.selectedPeriod;
  }

  void _reset() {
    widget.onApply(null, null);
    Navigator.pop(context);
  }

  void _apply() {
    widget.onApply(_tempStatus, _tempPeriod);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Tagihan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown<BillStatus>(
                  labelText: 'Status',
                  hintText: 'Semua Status',
                  items: BillStatus.values.map((status) {
                    return DropdownMenuEntry(
                      value: status,
                      label: status.label,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      _tempStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  labelText: 'Periode',
                  hintText: 'Contoh: 2025-12',
                  onChanged: (value) {
                    _tempPeriod = value.isEmpty ? null : value;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Footer Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    onPressed: _apply,
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final BillModel bill;
  final int index;

  const _BillCard({required this.bill, required this.index});

  Color _getStatusColor(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return Colors.green;
      case BillStatus.unpaid:
        return Colors.grey;
      case BillStatus.pending:
        return Colors.orange;
      case BillStatus.overdue:
        return Colors.red;
      case BillStatus.rejected:
        return Colors.red.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (bill.id != null) {
            context.pushNamed(
              'bill_detail',
              pathParameters: {'id': bill.id.toString()},
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Index number
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.familyDisplayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (bill.familyAddress != null)
                          Text(
                            bill.familyAddress!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  CustomChip(
                    label: bill.status.label,
                    backgroundColor: _getStatusColor(bill.status).withOpacity(0.1),
                    textColor: _getStatusColor(bill.status),
                  ),
                ],
              ),
              
              const Divider(height: 16),
              
              // Bill details
              _buildDetailRow(Icons.code, 'Kode Tagihan', bill.code),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.category, 'Iuran', bill.categoryDisplayName),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.calendar_today, 'Periode', bill.formattedPeriod),
              
              const SizedBox(height: 12),
              
              // Amount
              Row(
                children: [
                  const Icon(Icons.monetization_on, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    bill.formattedAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (bill.id != null) {
                      context.pushNamed(
                        'bill_detail',
                        pathParameters: {'id': bill.id.toString()},
                      );
                    }
                  },
                  child: const Text('Lihat Detail'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
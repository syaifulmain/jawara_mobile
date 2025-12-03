import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../enums/bill_status.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/bill_provider.dart';
import '../../../providers/resident_provider.dart';
import '../../../models/bill/bill_model.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/info_banner.dart';

class MyBillsScreen extends StatefulWidget {
  const MyBillsScreen({Key? key}) : super(key: key);

  @override
  State<MyBillsScreen> createState() => _MyBillsScreenState();
}

class _MyBillsScreenState extends State<MyBillsScreen> {
  BillStatus? _selectedStatus;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _familyId;
  bool _hasFamily = true;
  bool _isCheckingFamily = true; // Loading state untuk cek family

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserFamilyAndBills();
    });
  }

  Future<void> _loadUserFamilyAndBills() async {
    final authProvider = context.read<AuthProvider>();
    final residentProvider = context.read<ResidentProvider>();
    final billProvider = context.read<BillProvider>();
    
    if (authProvider.token == null || authProvider.currentUser == null) {
      setState(() {
        _isCheckingFamily = false;
      });
      return;
    }

    // Clear previous bills cache before loading new user's data
    billProvider.clearBillsCache();

    // Get user's resident data to fetch family_id
    final resident = await residentProvider.fetchResidentByUserId(
      authProvider.token!,
      authProvider.currentUser!.id,
    );

    setState(() {
      if (resident != null && resident.familyId != null) {
        _familyId = resident.familyId;
        _hasFamily = true;
      } else {
        _familyId = null;
        _hasFamily = false;
      }
      _isCheckingFamily = false; // Selesai cek family
    });

    // Load bills with family filter
    if (_hasFamily) {
      _loadBills();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final authProvider = context.read<AuthProvider>();
      final billProvider = context.read<BillProvider>();
      
      if (authProvider.token != null && 
          billProvider.hasMore && 
          !billProvider.isLoadingMore &&
          _selectedStatus == null &&
          _searchController.text.isEmpty) {
        billProvider.loadMoreBills(authProvider.token!, familyId: _familyId);
      }
    }
  }

  void _loadBills() {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      billProvider.fetchBills(authProvider.token!, familyId: _familyId);
    }
  }

  void _applyFilter() {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      if (_selectedStatus == null) {
        billProvider.clearFilter();
        billProvider.fetchBills(authProvider.token!);
      } else {
        billProvider.fetchBillsByStatus(authProvider.token!, _selectedStatus!);
      }
    }
  }

  void _searchBills(String query) {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        _applyFilter();
      } else {
        billProvider.searchBills(authProvider.token!, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tagihan Saya')),
      body: Column(
        children: [
          const InfoBanner(
            message: 'Daftar tagihan iuran Anda. Belum bayar? Upload bukti pembayaran. Ditolak? Upload ulang dengan bukti yang benar.',
          ),
          
          // Show loading while checking family
          if (_isCheckingFamily)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          // Show message if user has no family
          else if (!_hasFamily)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.family_restroom, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Anda belum terdaftar di keluarga mana pun',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan hubungi RT/RW untuk mendaftarkan diri Anda',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Search
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _searchController,
                    hintText: 'Cari tagihan...',
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
                  
                  // Status Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua', null),
                        const SizedBox(width: 8),
                        _buildFilterChip('Belum Bayar', BillStatus.unpaid),
                        const SizedBox(width: 8),
                        _buildFilterChip('Menunggu', BillStatus.pending),
                        const SizedBox(width: 8),
                        _buildFilterChip('Lunas', BillStatus.paid),
                        const SizedBox(width: 8),
                        _buildFilterChip('Ditolak', BillStatus.rejected),
                        const SizedBox(width: 8),
                        _buildFilterChip('Terlambat', BillStatus.overdue),
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
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada tagihan',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadBills(),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: billProvider.bills.length + (billProvider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
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
                        return _BillCard(bill: bill);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, BillStatus? status) {
    final isSelected = _selectedStatus == status;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
        _applyFilter();
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade700,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _BillCard extends StatelessWidget {
  final BillModel bill;

  const _BillCard({required this.bill});

  Color _getStatusColor(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return Colors.green;
      case BillStatus.unpaid:
        return Colors.grey;
      case BillStatus.overdue:
        return Colors.yellow.shade700;
      case BillStatus.pending:
        return Colors.orange;
      case BillStatus.rejected:
        return Colors.red.shade900;
    }
  }

  IconData _getStatusIcon(BillStatus status) {
    switch (status) {
      case BillStatus.paid:
        return Icons.check_circle;
      case BillStatus.unpaid:
        return Icons.pending_actions;
      case BillStatus.pending:
        return Icons.hourglass_empty;
      case BillStatus.overdue:
        return Icons.warning;
      case BillStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getActionLabel(BillStatus status) {
    switch (status) {
      case BillStatus.unpaid:
      case BillStatus.overdue:
        return 'Bayar Sekarang';
      case BillStatus.pending:
        return 'Lihat Status';
      case BillStatus.rejected:
        return 'Upload Ulang';
      case BillStatus.paid:
        return 'Lihat Detail';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(bill.status);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (bill.id != null) {
            context.pushNamed(
              'my_bill_detail',
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
                  Icon(
                    _getStatusIcon(bill.status),
                    color: statusColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.categoryDisplayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Periode: ${bill.formattedPeriod}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomChip(
                    label: bill.status.label,
                    backgroundColor: statusColor.withOpacity(0.1),
                    textColor: statusColor,
                  ),
                ],
              ),
              
              const Divider(height: 24),
              
              // Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nominal',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    bill.formattedAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Rejection reason if rejected
              if (bill.status == BillStatus.rejected && bill.rejectionReason != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alasan Penolakan:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              bill.rejectionReason!,
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (bill.id != null) {
                      context.pushNamed(
                        'my_bill_detail',
                        pathParameters: {'id': bill.id.toString()},
                      );
                    }
                  },
                  icon: Icon(
                    bill.status == BillStatus.paid 
                        ? Icons.visibility 
                        : Icons.upload_file,
                  ),
                  label: Text(_getActionLabel(bill.status)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bill.status == BillStatus.paid 
                        ? Colors.blue 
                        : statusColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

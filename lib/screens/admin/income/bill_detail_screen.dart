import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../enums/bill_status.dart';
import '../../../models/bill/bill_model.dart';
import '../../../providers/bill_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class BillDetailScreen extends StatefulWidget {
  final String billId;

  const BillDetailScreen({Key? key, required this.billId}) : super(key: key);

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _notesController = TextEditingController();
  BillModel? _bill;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBill();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadBill() {
    final billProvider = context.read<BillProvider>();
    try {
      _bill = billProvider.bills.firstWhere(
        (b) => b.id.toString() == widget.billId,
      );

      if (_bill != null) {
        _notesController.text = _bill!.rejectionReason ?? '';
      }
    } catch (e) {
      _fetchBillFromServer();
    }
  }

  void _fetchBillFromServer() async {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      await billProvider.fetchBillById(authProvider.token!, widget.billId);
      _bill = billProvider.selectedBill;

      if (_bill != null) {
        setState(() {
          _notesController.text = _bill!.rejectionReason ?? '';
        });
      }
    }
  }

  Future<void> _approveBill() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setujui Pembayaran'),
        content: const Text('Apakah Anda yakin ingin menyetujui pembayaran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Setujui'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final billProvider = Provider.of<BillProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not logged in')),
      );
      return;
    }
    
    final success = await billProvider.approvePayment(token, widget.billId);
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran telah disetujui'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              billProvider.errorMessage ?? 'Gagal menyetujui pembayaran',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectBill() async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon masukkan alasan penolakan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pembayaran'),
        content: const Text('Apakah Anda yakin ingin menolak pembayaran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final billProvider = Provider.of<BillProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not logged in')),
      );
      return;
    }

    final success = await billProvider.rejectPayment(
      token,
      widget.billId,
      _notesController.text,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran telah ditolak'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              billProvider.errorMessage ?? 'Gagal menolak pembayaran',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primaryColor,
        ),
        elevation: 0,
        title: Text(
          'Verifikasi Pembayaran Iuran',
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryColor,
          tabs: const [
            Tab(text: 'Detail'),
            Tab(text: 'Riwayat Pembayaran'),
          ],
        ),
      ),
      body: Consumer<BillProvider>(
        builder: (context, provider, _) {
          final bill = _bill ?? provider.selectedBill;
          
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bill == null) {
            return const Center(child: Text('Tagihan tidak ditemukan'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildDetailTab(bill, provider),
              _buildHistoryTab(bill),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailTab(BillModel bill, BillProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(Rem.rem1_5),
      child: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bill Information
                _buildDetailSection(
                  'Informasi Tagihan',
                  [
                    _buildDetailRow('Kode Tagihan', bill.code),
                    _buildDetailRow('Nama Iuran', bill.categoryDisplayName),
                    _buildDetailRow('Kategori', bill.categoryType?.label ?? '-'),
                    _buildDetailRow('Periode', bill.formattedPeriod),
                    _buildDetailRow('Nominal', bill.formattedAmount),
                    _buildDetailRow(
                      'Status',
                      bill.status.label,
                      statusColor: _getStatusColor(bill.status),
                    ),
                  ],
                ),

                const SizedBox(height: Rem.rem1_5),

                // Family Information
                _buildDetailSection(
                  'Informasi Keluarga',
                  [
                    _buildDetailRow('Nama KK', bill.familyDisplayName),
                    _buildDetailRow('Alamat', bill.familyAddress ?? '-'),
                  ],
                ),

                const SizedBox(height: Rem.rem1_5),

                // Payment Information - Show when payment proof exists or status is not unpaid
                if (bill.status != BillStatus.unpaid || bill.paymentProof != null) ...[
                  _buildDetailSection(
                    'Informasi Pembayaran',
                    [
                      _buildDetailRow(
                        'Tanggal Bayar',
                        bill.paidAt != null
                            ? DateFormat('dd MMMM yyyy, HH:mm').format(bill.paidAt!)
                            : 'Belum tersedia',
                      ),
                      _buildDetailRow('Bukti Pembayaran', bill.paymentProof ?? 'Belum tersedia'),
                      if (bill.verifiedAt != null)
                        _buildDetailRow(
                          'Diverifikasi',
                          DateFormat('dd MMMM yyyy, HH:mm').format(bill.verifiedAt!),
                        ),
                      if (bill.verifiedByName != null)
                        _buildDetailRow('Diverifikasi oleh', bill.verifiedByName!),
                      if (bill.status == BillStatus.rejected && bill.rejectionReason != null)
                        _buildDetailRow(
                          'Alasan Penolakan',
                          bill.rejectionReason!,
                        ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem1_5),
                ],

                // Rejection Reason Input - Only show for pending status
                if (bill.status == BillStatus.pending) ...[
                  Text(
                    'Alasan Penolakan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Rem.rem0_75),
                  CustomTextFormField(
                    controller: _notesController,
                    labelText: 'Alasan Penolakan (opsional untuk approve)',
                    hintText: 'Wajib diisi jika menolak pembayaran...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: Rem.rem1_5),
                ],

                // Show rejection reason for rejected bills (read-only)
                if (bill.status == BillStatus.rejected && bill.rejectionReason != null) ...[
                  Text(
                    'Alasan Penolakan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: Rem.rem0_75),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Rem.rem1),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(Rem.rem0_5),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      bill.rejectionReason!,
                      style: GoogleFonts.poppins(
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: Rem.rem1_5),
                ],

                // Action Buttons - Only show when status is pending (waiting for verification)
                if (bill.status == BillStatus.pending)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: provider.isLoading ? null : _approveBill,
                          child: provider.isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Memproses...'),
                                  ],
                                )
                              : const Text('Setujui'),
                        ),
                      ),
                      const SizedBox(width: Rem.rem1),
                      Expanded(
                        child: CustomButton(
                          onPressed: provider.isLoading ? null : _rejectBill,
                          isOutlined: true,
                          child: const Text(
                            'Tolak',
                            style: 
                            TextStyle(color: Colors.red)
                            ,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab(BillModel bill) {
    return Padding(
      padding: const EdgeInsets.all(Rem.rem1_5),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Rem.rem1_5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: Rem.rem1),
              
              // Create timeline items based on bill status
              _buildHistoryItem(
                tanggal: DateFormat('dd/MM/yyyy HH:mm').format(bill.createdAt),
                aksi: 'Tagihan dibuat',
                status: 'Dibuat',
                color: Colors.blue,
              ),
              
              if (bill.paidAt != null)
                _buildHistoryItem(
                  tanggal: DateFormat('dd/MM/yyyy HH:mm').format(bill.paidAt!),
                  aksi: 'Pembayaran dilakukan',
                  status: 'Dibayar',
                  color: Colors.orange,
                ),
              
              if (bill.verifiedAt != null)
                _buildHistoryItem(
                  tanggal: DateFormat('dd/MM/yyyy HH:mm').format(bill.verifiedAt!),
                  aksi: bill.status == BillStatus.paid ? 'Pembayaran disetujui' : 'Pembayaran ditolak',
                  status: bill.status == BillStatus.paid ? 'Disetujui' : 'Ditolak',
                  color: bill.status == BillStatus.paid ? Colors.green : Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: Rem.rem0_75),
        Container(
          padding: const EdgeInsets.all(Rem.rem1),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(Rem.rem0_5),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: statusColor ?? Colors.black87,
                fontWeight: statusColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String tanggal,
    required String aksi,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(Rem.rem0_75),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Rem.rem0_5),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: Rem.rem0_75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aksi,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  tanggal,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
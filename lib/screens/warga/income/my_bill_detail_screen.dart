import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../enums/bill_status.dart';
import '../../../models/bill/bill_model.dart';
import '../../../models/transfer_channel/transfer_channel_list_model.dart';
import '../../../providers/bill_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/transfer_channel_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_image_display.dart';

class MyBillDetailScreen extends StatefulWidget {
  final String billId;

  const MyBillDetailScreen({Key? key, required this.billId}) : super(key: key);

  @override
  State<MyBillDetailScreen> createState() => _MyBillDetailScreenState();
}

class _MyBillDetailScreenState extends State<MyBillDetailScreen> {
  BillModel? _bill;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadBill();
    _loadTransferChannels();
  }

  void _loadTransferChannels() async {
    final authProvider = context.read<AuthProvider>();
    final channelProvider = context.read<TransferChannelProvider>();

    if (authProvider.token != null) {
      await channelProvider.fetchTransferChannels(authProvider.token!);
    }
  }

  void _loadBill() {
    final billProvider = context.read<BillProvider>();
    try {
      _bill = billProvider.bills.firstWhere(
        (b) => b.id.toString() == widget.billId,
      );
    } catch (e) {
      _fetchBillFromServer();
    }
  }

  void _fetchBillFromServer() async {
    final authProvider = context.read<AuthProvider>();
    final billProvider = context.read<BillProvider>();

    if (authProvider.token != null) {
      await billProvider.fetchBillById(authProvider.token!, widget.billId);
      setState(() {
        _bill = billProvider.selectedBill;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadPaymentProof() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih bukti pembayaran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Bukti Pembayaran'),
        content: const Text(
          'Pastikan bukti pembayaran yang Anda upload sudah benar. '
          'Bukti pembayaran yang tidak valid akan ditolak oleh admin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Upload'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final billProvider = Provider.of<BillProvider>(context, listen: false);

      final token = authProvider.token;
      if (token == null) {
        throw Exception('You are not logged in');
      }

      final success = await billProvider.uploadPaymentProof(
        token,
        widget.billId,
        _selectedImage!.path,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bukti pembayaran berhasil diupload. Menunggu verifikasi admin.'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Refresh bill data
          _fetchBillFromServer();
          
          setState(() {
            _selectedImage = null;
          });
        }
      } else {
        throw Exception(billProvider.errorMessage ?? 'Failed to upload');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal upload bukti pembayaran: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
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
          'Detail Tagihan',
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
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

          return _buildContent(bill);
        },
      ),
    );
  }

  Widget _buildContent(BillModel bill) {
    final canUploadProof = bill.status == BillStatus.unpaid || 
                           bill.status == BillStatus.rejected ||
                           bill.status == BillStatus.overdue;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Rem.rem1_5),
      child: Column(
        children: [
          // Status Card
          _buildStatusCard(bill),
          
          const SizedBox(height: Rem.rem1_5),
          
          // Bill Information
          _buildInfoCard(bill),
          
          const SizedBox(height: Rem.rem1_5),
          
          // Payment Proof Section
          if (canUploadProof) ...[
            // Transfer Channels Section
            _buildTransferChannelsCard(),
            const SizedBox(height: Rem.rem1_5),
            
            _buildUploadSection(bill),
            const SizedBox(height: Rem.rem1_5),
          ],
          
          // Existing Payment Proof
          if (bill.paymentProof != null) ...[
            _buildExistingProofCard(bill),
            const SizedBox(height: Rem.rem1_5),
          ],
          
          // Rejection Reason
          if (bill.status == BillStatus.rejected && bill.rejectionReason != null) ...[
            _buildRejectionCard(bill),
            const SizedBox(height: Rem.rem1_5),
          ],
          
          // Payment History
          _buildHistoryCard(bill),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BillModel bill) {
    final statusColor = _getStatusColor(bill.status);
    
    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          children: [
            Icon(
              bill.status == BillStatus.paid 
                  ? Icons.check_circle 
                  : bill.status == BillStatus.rejected
                      ? Icons.cancel
                      : bill.status == BillStatus.pending
                          ? Icons.hourglass_empty
                          : Icons.warning,
              color: statusColor,
              size: 48,
            ),
            const SizedBox(height: Rem.rem0_75),
            Text(
              bill.status.label,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            Text(
              _getStatusDescription(bill.status),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDescription(BillStatus status) {
    switch (status) {
      case BillStatus.unpaid:
        return 'Tagihan belum dibayar. Upload bukti pembayaran Anda.';
      case BillStatus.pending:
        return 'Bukti pembayaran sedang diverifikasi oleh admin.';
      case BillStatus.paid:
        return 'Pembayaran telah diverifikasi dan diterima.';
      case BillStatus.rejected:
        return 'Bukti pembayaran ditolak. Upload ulang dengan bukti yang benar.';
      case BillStatus.overdue:
        return 'Tagihan terlambat. Segera lakukan pembayaran.';
    }
  }

  Widget _buildInfoCard(BillModel bill) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Tagihan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            _buildInfoRow('Kode Tagihan', bill.code),
            _buildInfoRow('Jenis Iuran', bill.categoryDisplayName),
            _buildInfoRow('Periode', bill.formattedPeriod),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Tagihan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bill.formattedAmount,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferChannelsCard() {
    return Consumer<TransferChannelProvider>(
      builder: (context, channelProvider, _) {
        if (channelProvider.isLoading) {
          return Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(Rem.rem1_5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final channels = channelProvider.transferChannels;

        if (channels.isEmpty) {
          return Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(Rem.rem1_5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Transfer',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Rem.rem0_75),
                  Text(
                    'Belum ada metode transfer yang tersedia. Hubungi admin untuk informasi pembayaran.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Transfer Ke Rekening Berikut',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Rem.rem1),
                Text(
                  'Pilih salah satu rekening di bawah untuk transfer pembayaran:',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: Rem.rem1),
                
                ...channels.map((channel) => _buildChannelItem(channel)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelItem(TransferChannelListModel channel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  channel.type.label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No. Rekening: ${channel.accountNumber}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      channel.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'a.n. ${channel.ownerName}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: channel.accountNumber));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nomor rekening ${channel.accountNumber} disalin'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(Icons.copy, color: Colors.blue.shade700),
                tooltip: 'Salin nomor rekening',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection(BillModel bill) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Bukti Pembayaran',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: Rem.rem0_75),
            Text(
              'Upload foto struk transfer, screenshot m-banking, atau bukti pembayaran lainnya yang menunjukkan Anda telah melakukan pembayaran.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: Rem.rem1),
            
            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: Rem.rem1),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: _pickImage,
                      child: const Text('Pilih Ulang'),
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      onPressed: _isUploading ? null : _uploadPaymentProof,
                      child: _isUploading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Upload'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: _pickImage,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file),
                      SizedBox(width: 8),
                      Text('Pilih Bukti Pembayaran'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExistingProofCard(BillModel bill) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bukti Pembayaran Saat Ini',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            CustomImageDisplay(
              imageUrl: bill.paymentProof!,
              height: 200,
            ),
            const SizedBox(height: Rem.rem0_75),
            if (bill.paidAt != null)
              Text(
                'Diupload: ${DateFormat('dd/MM/yyyy HH:mm').format(bill.paidAt!)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectionCard(BillModel bill) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  'Alasan Penolakan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Rem.rem0_75),
            Text(
              bill.rejectionReason!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BillModel bill) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            
            _buildHistoryItem(
              date: DateFormat('dd/MM/yyyy HH:mm').format(bill.createdAt),
              title: 'Tagihan dibuat',
              color: Colors.blue,
            ),
            
            if (bill.paidAt != null)
              _buildHistoryItem(
                date: DateFormat('dd/MM/yyyy HH:mm').format(bill.paidAt!),
                title: 'Bukti pembayaran diupload',
                color: Colors.orange,
              ),
            
            if (bill.verifiedAt != null)
              _buildHistoryItem(
                date: DateFormat('dd/MM/yyyy HH:mm').format(bill.verifiedAt!),
                title: bill.status == BillStatus.paid 
                    ? 'Pembayaran disetujui' 
                    : 'Pembayaran ditolak',
                color: bill.status == BillStatus.paid ? Colors.green : Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String title,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
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

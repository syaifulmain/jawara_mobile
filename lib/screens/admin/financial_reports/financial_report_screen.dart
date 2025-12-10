import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/financial_report_provider.dart';
import '../../../services/report_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({Key? key}) : super(key: key);

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedType = 'semua';

  final List<String> _types = ['semua', 'pemasukan', 'pengeluaran'];

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _generateReport() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal mulai dan akhir')),
      );
      return;
    }

    if (_startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal mulai tidak boleh lebih dari tanggal akhir'),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final reportProvider = Provider.of<FinancialReportProvider>(
      context,
      listen: false,
    );

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Anda belum login')));
      return;
    }

    await reportProvider.fetchReport(
      token,
      startDate: _startDate!,
      endDate: _endDate!,
      type: _selectedType,
    );

    if (reportProvider.errorMessage != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(reportProvider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Laporan Keuangan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<FinancialReportProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterSection(),
                const SizedBox(height: Rem.rem1_5),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (provider.report != null)
                  _buildReportContent(provider.report!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Laporan',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            _buildDateField(
              label: 'Tanggal Mulai',
              date: _startDate,
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: Rem.rem1),
            _buildDateField(
              label: 'Tanggal Akhir',
              date: _endDate,
              onTap: () => _selectEndDate(context),
            ),
            const SizedBox(height: Rem.rem1),
            CustomDropdown<String>(
              labelText: "Jenis Transaksi",
              hintText: "-- PILIH JENIS --",
              initialSelection: _selectedType,
              items: _types.map((type) {
                return DropdownMenuEntry(
                  value: type,
                  label: type[0].toUpperCase() + type.substring(1),
                );
              }).toList(),
              onSelected: (value) {
                setState(() {
                  _selectedType = value ?? 'semua';
                });
              },
            ),
            const SizedBox(height: Rem.rem1_5),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: _generateReport,
                    child: Text(
                      'Tampilkan Laporan',
                      style: GoogleFonts.poppins(fontSize: Rem.rem1),
                    ),
                  ),
                ),
                if (false)...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        final authProvider = context.read<AuthProvider>();
                        final token = authProvider.token;

                        if (token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Anda belum login')),
                          );
                          return;
                        }

                        try {
                          await ReportService().downloadFinancialReportPdf(
                            token,
                            startDate: _startDate, // jika ada filter tanggal
                            endDate: _endDate,     // jika ada filter tanggal
                          );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PDF berhasil diunduh dan dibuka')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal mengunduh PDF: $e')),
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.download, size: Rem.rem1_25),
                          const SizedBox(width: Rem.rem0_5),
                          Text(
                            'Download PDF',
                            style: GoogleFonts.poppins(fontSize: Rem.rem1),
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Rem.rem1,
              vertical: Rem.rem0_875,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(Rem.rem0_5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date == null
                      ? 'Pilih tanggal'
                      : DateFormat('dd/MM/yyyy').format(date),
                  style: GoogleFonts.poppins(
                    color: date == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.calendar_today, size: Rem.rem1_25),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent(dynamic report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReportHeader(report),
        const SizedBox(height: Rem.rem1_5),
        _buildSummarySection(report.ringkasan),
        const SizedBox(height: Rem.rem1_5),
        _buildTransactionSection(report.transaksi),
        const SizedBox(height: Rem.rem1),
        Text(
          'Dicetak pada: ${report.dicetakPada}',
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildReportHeader(dynamic report) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.judul,
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            Text(
              report.periode.text,
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(dynamic ringkasan) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            _buildSummaryItem(
              'Total Pemasukan',
              ringkasan.formattedTotalPemasukan,
              Colors.green,
            ),
            const Divider(),
            _buildSummaryItem(
              'Total Pengeluaran',
              ringkasan.formattedTotalPengeluaran,
              Colors.red,
            ),
            const Divider(),
            _buildSummaryItem(
              'Saldo Akhir',
              ringkasan.formattedSaldoAkhir,
              ringkasan.saldoAkhir >= 0 ? Colors.green : Colors.red,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Rem.rem0_5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection(List<dynamic> transactions) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Transaksi',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionItem(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(dynamic transaction) {
    final isPemasukan = transaction.jenis == 'Pemasukan';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Rem.rem0_75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.deskripsi,
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_25),
                    Text(
                      transaction.kategori,
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                transaction.formattedJumlah,
                style: GoogleFonts.poppins(
                  fontSize: Rem.rem1,
                  fontWeight: FontWeight.w600,
                  color: isPemasukan ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: Rem.rem0_25),
          Text(
            transaction.tanggal,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem0_75,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

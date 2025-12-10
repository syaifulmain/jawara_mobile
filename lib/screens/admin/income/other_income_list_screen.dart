import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Ditambahkan untuk styling tombol
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/info_banner.dart';
import '../../../providers/income_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/income/income_list_model.dart';
import '../../../constants/color_constant.dart'; // Asumsi AppColors ada di sini
import '../../../constants/rem_constant.dart'; // Asumsi Rem ada di sini

class OtherIncomeListScreen extends StatefulWidget {
  const OtherIncomeListScreen({Key? key}) : super(key: key);

  @override
  State<OtherIncomeListScreen> createState() => _OtherIncomeListScreenState();
}

class _OtherIncomeListScreenState extends State<OtherIncomeListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIncomes();
    });
  }

  void _loadIncomes() {
    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeProvider>();

    if (authProvider.token != null) {
      incomeProvider.fetchIncomes(authProvider.token!);
    }
  }

  void _searchIncomes(String query) {
    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        incomeProvider.fetchIncomes(authProvider.token!);
      } else {
        incomeProvider.searchIncomes(authProvider.token!, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pemasukan Lain')),
      body: Column(
        children: [
          const InfoBanner(
            message: 'Daftar pemasukan selain iuran warga. Klik item untuk melihat detail atau mengedit. Gunakan pencarian untuk menemukan pemasukan tertentu.',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari pemasukan... ',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchIncomes('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchIncomes,
            ),
          ),
          Expanded(
            child: Consumer<IncomeProvider>(
              builder: (context, incomeProvider, child) {
                if (incomeProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (incomeProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${incomeProvider.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadIncomes,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (incomeProvider.incomes.isEmpty) {
                  return const Center(child: Text('Belum ada data pemasukan'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadIncomes(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: incomeProvider.incomes.length,
                    itemBuilder: (context, index) {
                      final income = incomeProvider.incomes[index];
                      return _IncomeCard(income: income);
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
    super.dispose();
  }
}

class _IncomeCard extends StatelessWidget {
  final IncomeListModel income;

  const _IncomeCard({required this.income});

  @override
  Widget build(BuildContext context) {
    // Fungsi navigasi yang akan digunakan oleh onTap Card dan Button
    void navigateToDetail() {
      context.pushNamed(
        'income_detail',
        pathParameters: {'id': income.id.toString()},
      );
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        // Menghapus onTap dari InkWell agar fokus pada tombol di dalam Card
        // onTap: navigateToDetail, // <--- Dihapus dari InkWell

        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                income.name ?? 'Tanpa Nama',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Tipe: ${income.incomeType ?? '-'}'),
              Text('Tanggal: ${income.date ?? '-'}'),
              Text('Jumlah: ${income.amount ?? '0'}'),
              if (income.verification != null) const SizedBox(height: 4),
              if (income.verification != null)
                Text(
                  'Verifikasi: ${income.verification} - ${income.dateVerification ?? '-'}',
                ),
              
              const SizedBox(height: 16), // Jarak sebelum tombol

              // --------------------------
              // ✅ TOMBOL LIHAT DETAIL BARU
              // --------------------------
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: navigateToDetail,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  label: Text(
                    'Lihat Detail',
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_875,
                      fontWeight: FontWeight.w600,
                    ),
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
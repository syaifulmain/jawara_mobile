import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengeluaran_provider.dart';
import '../../../../models/pengeluaran/pengeluaran_list_model.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_chip.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_select_calender.dart';
import '../../../../widgets/custom_text_form_field.dart';

class ExpenditureListScreen extends StatefulWidget {
  const ExpenditureListScreen({super.key});

  @override
  State<ExpenditureListScreen> createState() => _ExpenditureListScreenState();
}

class _ExpenditureListScreenState extends State<ExpenditureListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpenditures();
    });
  }

  void _loadExpenditures() {
    final auth = context.read<AuthProvider>();
    final expProvider = context.read<PengeluaranProvider>();
    if (auth.token != null) {
      expProvider.fetchPengeluaran(auth.token!);
    }
  }

  void _applyFilters() {
    final auth = context.read<AuthProvider>();
    final expProvider = context.read<PengeluaranProvider>();

    if (auth.token != null) {
      if (_selectedCategory == null && _selectedDate == null) {
        expProvider.clearFilter();
        expProvider.fetchPengeluaran(auth.token!);
      } else {
        expProvider.fetchPengeluaranByCategoryOrDate(
          auth.token!,
          category: _selectedCategory,
          date: _selectedDate,
        );
      }
    }
  }

  void _searchExpenditures(String query) {
    final auth = context.read<AuthProvider>();
    final expProvider = context.read<PengeluaranProvider>();
    if (auth.token != null) {
      if (query.isEmpty) {
        _applyFilters();
      } else {
        expProvider.searchPengeluaran(auth.token!, query);
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
        selectedCategory: _selectedCategory,
        selectedDate: _selectedDate,
        onApply: (category, date) {
          setState(() {
            _selectedCategory = category;
            _selectedDate = date;
          });
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = _selectedCategory != null || _selectedDate != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengeluaran')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _searchController,
                  hintText: 'Cari pengeluaran...',
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchExpenditures('');
                          },
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: _searchExpenditures,
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
                        hasActiveFilter ? 'Filter Aktif' : 'Filter Pengeluaran',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PengeluaranProvider>(
              builder: (context, expProvider, child) {
                if (expProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (expProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${expProvider.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadExpenditures,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (expProvider.pengeluaran.isEmpty) {
                  return const Center(child: Text('Belum ada pengeluaran'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadExpenditures(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: expProvider.pengeluaran.length,
                    itemBuilder: (context, index) {
                      final exp = expProvider.pengeluaran[index];
                      return _ExpenditureCard(pengeluaran: exp);
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

// ------------------ FILTER BOTTOM SHEET ------------------
class _FilterBottomSheet extends StatefulWidget {
  final String? selectedCategory;
  final DateTime? selectedDate;
  final Function(String?, DateTime?) onApply;

  const _FilterBottomSheet({
    required this.selectedCategory,
    required this.selectedDate,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _tempCategory;
  DateTime? _tempDate;

  @override
  void initState() {
    super.initState();
    _tempCategory = widget.selectedCategory;
    _tempDate = widget.selectedDate;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tempDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _tempDate = picked;
      });
    }
  }

  void _reset() {
    widget.onApply(null, null);
    Navigator.pop(context);
  }

  void _apply() {
    widget.onApply(_tempCategory, _tempDate);
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
                  'Filter',
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
              children: [
                CustomSelectCalendar(
                  labelText: 'Tanggal Pengeluaran',
                  hintText: 'Pilih Tanggal',
                  initialDate: _tempDate,
                  onDateSelected: (date) => setState(() => _tempDate = date),
                ),
                const SizedBox(height: 12),
                CustomDropdown<String>(
                  labelText: 'Kategori',
                  hintText: 'Pilih kategori',
                  items:
                      [
                            'Operasional RT/RW',
                            'Kegiatan Sosial',
                            'Pemeliharaan Fasilitas',
                            'Pembangunan',
                            'Kegiatan Warga',
                            'Keamanan & Kebersihan',
                            'Lain-lain',
                          ] // Contoh kategori
                          .map((e) => DropdownMenuEntry(value: e, label: e))
                          .toList(),
                  onSelected: (value) => setState(() => _tempCategory = value),
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

// ------------------ CARD ------------------
class _ExpenditureCard extends StatelessWidget {
  final PengeluaranListModel pengeluaran;
  const _ExpenditureCard({required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pushNamed(
            'expenditure_detail',
            pathParameters: {'id': pengeluaran.id.toString()},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pengeluaran.namaPengeluaran,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomChip(label: pengeluaran.kategori),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(dateFormat.format(DateTime.parse(pengeluaran.tanggal))),
                  const SizedBox(width: 16),
                  const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("Rp ${pengeluaran.nominal}"),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(
                      'expenditure_detail',
                      pathParameters: {'id': pengeluaran.id.toString()},
                    );
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
}

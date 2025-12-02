import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/income_categories_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';

class BillIncomeScreen extends StatefulWidget {
  const BillIncomeScreen({Key? key}) : super(key: key);

  @override
  State<BillIncomeScreen> createState() => _BillIncomeScreenState();
}

class _BillIncomeScreenState extends State<BillIncomeScreen> {
  String? _selectedCategoryId;
  DateTime? _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _loadCategories() {
    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeCategoriesProvider>();

    if (authProvider.token != null) {
      incomeProvider.fetchCategories(authProvider.token!);
    }
  }

  void _submitForm() async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon pilih kategori iuran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon pilih tanggal terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement bill creation logic here
      // final authProvider = context.read<AuthProvider>();
      // final success = await billService.createBill(
      //   authProvider.token!,
      //   categoryId: _selectedCategoryId!,
      //   dueDate: _selectedDate!,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final incomeProvider = context.read<IncomeCategoriesProvider>();
        final selectedCategory = incomeProvider.categories
            .firstWhere((cat) => cat.id.toString() == _selectedCategoryId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tagihan ${selectedCategory.name} berhasil dikirim ke semua keluarga aktif!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim tagihan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedCategoryId = null;
      _selectedDate = DateTime.now();
    });
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tanggal Jatuh Tempo",
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(), // Start from today
              lastDate: DateTime.now().add(const Duration(days: 365)), // Allow 1 year in future
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primaryColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
          borderRadius: BorderRadius.circular(Rem.rem0_5),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Rem.rem0_75,
              vertical: Rem.rem0_75,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Rem.rem0_5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: Rem.rem0_75),
                Text(
                  _selectedDate == null
                      ? "Pilih tanggal jatuh tempo"
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  style: GoogleFonts.poppins(
                    color: _selectedDate == null ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Tagih Iuran',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem1_5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.send,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Form Tagih Iuran',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                'Kirim tagihan ke semua keluarga aktif',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: Rem.rem1_5),
                    const Divider(),
                    const SizedBox(height: Rem.rem1),
                    
                    // Form fields
                    Consumer<IncomeCategoriesProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(Rem.rem1),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (provider.errorMessage != null) {
                          return Container(
                            padding: const EdgeInsets.all(Rem.rem1),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Error: ${provider.errorMessage}',
                                  style: GoogleFonts.poppins(color: Colors.red),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _loadCategories,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (provider.categories.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(Rem.rem1),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.orange.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.orange.shade600,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Belum ada kategori iuran',
                                  style: GoogleFonts.poppins(
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    context.pushNamed('add_income_category');
                                  },
                                  child: const Text('Tambah Kategori'),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            // Category Dropdown
                            CustomDropdown<String>(
                              labelText: "Kategori Iuran",
                              hintText: "Pilih kategori iuran",
                              initialSelection: _selectedCategoryId,
                              items: provider.categories.map((category) {
                                return DropdownMenuEntry(
                                  value: category.id.toString(),
                                  label: '${category.name} - ${category.formattedNominal}',
                                );
                              }).toList(),
                              onSelected: (String? value) {
                                setState(() {
                                  _selectedCategoryId = value;
                                });
                              },
                            ),
                            
                            const SizedBox(height: Rem.rem1_5),
                            
                            // Date Picker (Custom for future dates)
                            _buildDatePicker(),
                          ],
                        );
                      },
                    ),
                    
                    const SizedBox(height: Rem.rem1_5),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _isLoading ? null : _submitForm,
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Mengirim...',
                                        style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Tagih Iuran',
                                    style: GoogleFonts.poppins(
                                      fontSize: Rem.rem1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: CustomButton(
                            onPressed: _isLoading ? null : _resetForm,
                            isOutlined: true,
                            child: Text(
                              'Reset',
                              style: GoogleFonts.poppins(
                                fontSize: Rem.rem1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: Rem.rem1_5),
                    
                    // Info section
                    Container(
                      padding: const EdgeInsets.all(Rem.rem1),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.blue.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Informasi:',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tagihan akan dikirim ke semua keluarga yang terdaftar aktif di sistem. Pastikan kategori iuran dan tanggal jatuh tempo sudah benar sebelum mengirim tagihan.',
                            style: GoogleFonts.poppins(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
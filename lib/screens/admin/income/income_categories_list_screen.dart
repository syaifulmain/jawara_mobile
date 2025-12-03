import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../enums/income_type.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/income_categories_provider.dart';
import '../../../models/income/income_categories_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_select_calender.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/info_banner.dart';

class IncomeCategoriesListScreen extends StatefulWidget {
  const IncomeCategoriesListScreen({Key? key}) : super(key: key);

  @override
  State<IncomeCategoriesListScreen> createState() => _IncomeCategoriesListScreenState();
}

class _IncomeCategoriesListScreenState extends State<IncomeCategoriesListScreen> {
  IncomeType? _selectedType;
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

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

  void _applyFilters() {
    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeCategoriesProvider>();

    if (authProvider.token != null) {
      if (_selectedType == null && _selectedDate == null) {
        incomeProvider.clearFilter();
        incomeProvider.fetchCategories(authProvider.token!);
      } else {
        incomeProvider.fetchCategoriesByTypeOrDate(
          authProvider.token!,
          type: _selectedType,
          date: _selectedDate,
        );
      }
    }
  }

  void _searchCategories(String query) {
    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeCategoriesProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        _applyFilters();
      } else {
        incomeProvider.searchCategories(authProvider.token!, query);
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
        selectedType: _selectedType,
        selectedDate: _selectedDate,
        onApply: (type, date) {
          setState(() {
            _selectedType = type;
            _selectedDate = date;
          });
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = _selectedType != null || _selectedDate != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Jenis Iuran')),
      body: Column(
        children: [
          const InfoBanner(
            message: 'Daftar kategori iuran yang tersedia. Klik pada item untuk melihat detail atau edit. Gunakan tombol filter untuk menyaring berdasarkan tipe atau tanggal.',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _searchController,
                  hintText: 'Cari berdasarkan jenis iuran...',
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchCategories('');
                          },
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: _searchCategories,
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
                        hasActiveFilter ? 'Filter Aktif' : 'Filter Jenis Iuran',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<IncomeCategoriesProvider>(
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
                          onPressed: _loadCategories,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (incomeProvider.categories.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadCategories(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: incomeProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = incomeProvider.categories[index];
                      return _CategoryCard(category: category);
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

class _FilterBottomSheet extends StatefulWidget {
  final IncomeType? selectedType;
  final DateTime? selectedDate;
  final Function(IncomeType?, DateTime?) onApply;

  const _FilterBottomSheet({
    required this.selectedType,
    required this.selectedDate,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  IncomeType? _tempType;
  DateTime? _tempDate;

  @override
  void initState() {
    super.initState();
    _tempType = widget.selectedType;
    _tempDate = widget.selectedDate;
  }

  void _reset() {
    // Reset form and data
    widget.onApply(null, null);
    Navigator.pop(context);
  }

  void _apply() {
    widget.onApply(_tempType, _tempDate);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                CustomSelectCalendar(
                  labelText: 'Created Date',
                  hintText: 'Select Date',
                  initialDate: _tempDate,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      _tempDate = date;
                    });
                  },
                ),
                const SizedBox(height: 12),
                CustomDropdown<IncomeType>(
                  labelText: 'Type',
                  hintText: 'Select type',
                  items: IncomeType.values.map((type) {
                    return DropdownMenuEntry(
                      value: type,
                      label: type.label,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      _tempType = value;
                    });
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
                    child: const Text('Apply'),
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

class _CategoryCard extends StatelessWidget {
  final IncomeCategories category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (category.id != null) {
            context.pushNamed(
              'income_category_detail',
              pathParameters: {'id': category.id.toString()},
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomChip(
                    label: category.type.label,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    category.formattedNominal,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      dateFormat.format(category.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Created by: ${category.createdByDisplayName}',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (category.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    category.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (category.id != null) {
                      context.pushNamed(
                        'income_category_detail',
                        pathParameters: {'id': category.id.toString()},
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
}

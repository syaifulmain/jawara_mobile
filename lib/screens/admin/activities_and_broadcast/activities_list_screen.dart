import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../enums/activity_category.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/activity_provider.dart';
import '../../../models/activity_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_select_calender.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/info_banner.dart';

class ActivitiesListScreen extends StatefulWidget {
  const ActivitiesListScreen({Key? key}) : super(key: key);

  @override
  State<ActivitiesListScreen> createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState extends State<ActivitiesListScreen> {
  ActivityCategory? _selectedCategory;
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivities();
    });
  }

  void _loadActivities() {
    final authProvider = context.read<AuthProvider>();
    final activityProvider = context.read<ActivityProvider>();

    if (authProvider.token != null) {
      activityProvider.fetchActivities(authProvider.token!);
    }
  }

  void _applyFilters() {
    final authProvider = context.read<AuthProvider>();
    final activityProvider = context.read<ActivityProvider>();

    if (authProvider.token != null) {
      if (_selectedCategory == null && _selectedDate == null) {
        activityProvider.clearFilter();
        activityProvider.fetchActivities(authProvider.token!);
      } else {
        activityProvider.fetchActivitiesByCategoryOrDate(
          authProvider.token!,
          category: _selectedCategory,
          date: _selectedDate,
        );
      }
    }
  }

  void _searchActivities(String query) {
    final authProvider = context.read<AuthProvider>();
    final activityProvider = context.read<ActivityProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        _applyFilters();
      } else {
        activityProvider.searchActivities(authProvider.token!, query);
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
      appBar: AppBar(title: const Text('Daftar Kegiatan')),
      body: Column(
        children: [
          const InfoBanner(
            message:
                'Daftar kegiatan yang telah terjadwal. Gunakan filter untuk menyaring berdasarkan kategori atau tanggal. Klik item untuk melihat detail kegiatan.',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _searchController,
                  hintText: 'Cari kegiatan...',
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchActivities('');
                          },
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: _searchActivities,
                ),
                const SizedBox(height: 12),
                if (false) ...[
                  CustomButton(
                    onPressed: _showFilterBottomSheet,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.filter_list),
                        const SizedBox(width: 8),
                        Text(
                          hasActiveFilter ? 'Filter Aktif' : 'Filter Kegiatan',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Consumer<ActivityProvider>(
              builder: (context, activityProvider, child) {
                if (activityProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (activityProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${activityProvider.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadActivities,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (activityProvider.activities.isEmpty) {
                  return const Center(child: Text('Belum ada kegiatan'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadActivities(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: activityProvider.activities.length,
                    itemBuilder: (context, index) {
                      final activity = activityProvider.activities[index];
                      return _ActivityCard(activity: activity);
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
  final ActivityCategory? selectedCategory;
  final DateTime? selectedDate;
  final Function(ActivityCategory?, DateTime?) onApply;

  const _FilterBottomSheet({
    required this.selectedCategory,
    required this.selectedDate,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  ActivityCategory? _tempCategory;
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
    // setState(() {
    //   _tempCategory = null;
    //   _tempDate = null;
    // });

    // Reset form dan data
    widget.onApply(null, null);
    Navigator.pop(context);
  }

  void _apply() {
    widget.onApply(_tempCategory, _tempDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

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
                  labelText: 'Tanggal Pelaksanaan',
                  hintText: 'Pilih Tanggal',
                  initialDate: _tempDate,
                  onDateSelected: (DateTime p1) {
                    setState(() {
                      _tempDate = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                CustomDropdown<ActivityCategory>(
                  labelText: 'Kategori',
                  hintText: 'Pilih kategori',
                  items: ActivityCategory.values.map((category) {
                    return DropdownMenuEntry(
                      value: category,
                      label: category.label,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      _tempCategory = value;
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
                    isOutlined: true, // <-- PENTING: Untuk gaya Outline
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
// ... (Kode sebelumnya)

class _ActivityCard extends StatelessWidget {
  final Activity activity;

  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (activity.id != null) {
            context.pushNamed(
              'activity_detail',
              pathParameters: {'id': activity.id.toString()},
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
                      activity.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomChip(label: activity.category.label),
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
                  Text(
                    dateFormat.format(activity.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      activity.location,
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
                      'PJ: ${activity.personInCharge}',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // Indikator Pengeluaran
              if (activity.isPengeluaran)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Termasuk Pengeluaran',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        if (activity.nominal != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(activity.nominal)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              // Deskripsi singkat
              if (activity.description != null &&
                  activity.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    activity.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (activity.id != null) {
                      context.pushNamed(
                        'activity_detail',
                        pathParameters: {'id': activity.id.toString()},
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

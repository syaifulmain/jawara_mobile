import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/activity_model.dart';
import '../../../providers/activity_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _personInChargeController = TextEditingController();
  ActivityCategory? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _personInChargeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori kegiatan')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal kegiatan')),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih waktu kegiatan')),
      );
      return;
    }

    final activityDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final activity = Activity(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory!,
      date: activityDateTime,
      location: _locationController.text,
      personInCharge: _personInChargeController.text,
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum login')),
      );
      return;
    }

    final success = await activityProvider.createActivity(token, activity);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kegiatan berhasil ditambahkan')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              activityProvider.errorMessage ?? 'Gagal menambahkan kegiatan',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Tambah Kegiatan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Rem.rem1_5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Rem.rem0_75),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: Rem.rem0_625,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _nameController,
                          labelText: "Nama Kegiatan",
                          hintText: "Masukkan nama kegiatan",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama kegiatan harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Rem.rem1),
                        CustomTextFormField(
                          controller: _descriptionController,
                          labelText: "Deskripsi",
                          hintText: "Masukkan deskripsi kegiatan",
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Deskripsi harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Rem.rem1),
                        CustomDropdown<ActivityCategory>(
                          labelText: "Kategori Kegiatan",
                          hintText: "-- PILIH KATEGORI --",
                          items: ActivityCategory.values.map((category) {
                            return DropdownMenuEntry(
                              value: category,
                              label: category.label,
                            );
                          }).toList(),
                          onSelected: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(height: Rem.rem1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tanggal Kegiatan",
                              style: GoogleFonts.poppins(
                                fontSize: Rem.rem1,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: Rem.rem0_5),
                            InkWell(
                              onTap: () => _selectDate(context),
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
                                      _selectedDate == null
                                          ? 'Pilih tanggal'
                                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                      style: GoogleFonts.poppins(
                                        color: _selectedDate == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today, size: Rem.rem1_25),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Rem.rem1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Waktu Kegiatan",
                              style: GoogleFonts.poppins(
                                fontSize: Rem.rem1,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: Rem.rem0_5),
                            InkWell(
                              onTap: () => _selectTime(context),
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
                                      _selectedTime == null
                                          ? 'Pilih waktu'
                                          : _selectedTime!.format(context),
                                      style: GoogleFonts.poppins(
                                        color: _selectedTime == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    const Icon(Icons.access_time, size: Rem.rem1_25),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Rem.rem1),
                        CustomTextFormField(
                          controller: _locationController,
                          labelText: "Lokasi",
                          hintText: "Masukkan lokasi kegiatan",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lokasi harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Rem.rem1),
                        CustomTextFormField(
                          controller: _personInChargeController,
                          labelText: "Penanggung Jawab",
                          hintText: "Masukkan nama penanggung jawab",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Penanggung jawab harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Rem.rem1_5),
                        CustomButton(
                          onPressed: provider.isLoading ? null : _submitForm,
                          child: provider.isLoading
                              ? const SizedBox(
                            height: Rem.rem1_25,
                            width: Rem.rem1_25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Simpan Kegiatan',
                            style: GoogleFonts.poppins(fontSize: Rem.rem1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

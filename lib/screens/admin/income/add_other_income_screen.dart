import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/income_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../enums/income_enum.dart';
import '../../../models/income/income_request_model.dart';

class AddOtherIncomeScreen extends StatefulWidget {
  const AddOtherIncomeScreen({Key? key}) : super(key: key);

  @override
  State<AddOtherIncomeScreen> createState() => _AddOtherIncomeScreenState();
}

class _AddOtherIncomeScreenState extends State<AddOtherIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  IncomeType? _selectedIncomeType;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedIncomeType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tipe pemasukan')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeProvider>();

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Anda belum login')));
      return;
    }

    final amount =
        num.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

    final request = IncomeRequestModel(
      name: _nameController.text.trim(),
      incomeType: _selectedIncomeType!.value,
      date:
          _selectedDate?.toIso8601String().split('T')[0] ??
          DateTime.now().toIso8601String().split('T')[0],
      amount: amount,
    );

    final success = await incomeProvider.createIncome(token, request);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemasukan berhasil ditambahkan')),
        );
        Navigator.of(context).pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              incomeProvider.errorMessage ?? 'Gagal menambahkan pemasukan',
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
          'Tambah Pemasukan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<IncomeProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Pemasukan',
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem1_25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Nama Pemasukan',
                    hintText: 'Masukkan nama pemasukan',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Nama harus diisi';
                      if (value.length > 150)
                        return 'Nama maksimal 150 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<IncomeType>(
                    labelText: 'Tipe Pemasukan',
                    hintText: '-- PILIH TIPE --',
                    initialSelection: _selectedIncomeType,
                    items: IncomeType.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedIncomeType = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Pemasukan',
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
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Pilih tanggal pemasukan'
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_selectedDate!),
                                style: GoogleFonts.poppins(
                                  color: _selectedDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: Rem.rem1_25,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _amountController,
                    labelText: 'Jumlah',
                    hintText: 'Masukkan jumlah (angka)',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Jumlah harus diisi';
                      final parsed = num.tryParse(value.replaceAll(',', ''));
                      if (parsed == null) return 'Masukkan angka yang valid';
                      if (parsed <= 0) return 'Jumlah harus lebih dari 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem2),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: provider.isLoading ? null : _submit,
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
                              'Simpan',
                              style: GoogleFonts.poppins(fontSize: Rem.rem1),
                            ),
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

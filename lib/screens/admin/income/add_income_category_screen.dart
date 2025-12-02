import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../enums/income_type.dart';
import '../../../models/income/income_categories_model.dart';
import '../../../providers/income_categories_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';

class AddIncomeCategoryScreen extends StatefulWidget {
  const AddIncomeCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddIncomeCategoryScreen> createState() => _AddIncomeCategoryScreenState();
}

class _AddIncomeCategoryScreenState extends State<AddIncomeCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nominalController = TextEditingController();
  final _descriptionController = TextEditingController();
  IncomeType? _selectedType;

  @override
  void dispose() {
    _nameController.dispose();
    _nominalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category type')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = int.tryParse(authProvider.currentUser?.id ?? '1') ?? 1; // Convert String ID to int
    
    final category = IncomeCategories(
      name: _nameController.text,
      type: _selectedType!,
      nominal: double.tryParse(_nominalController.text) ?? 0.0,
      description: _descriptionController.text,
      createdBy: userId,
      createdByName: authProvider.currentUser?.name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final incomeProvider = Provider.of<IncomeCategoriesProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not logged in')),
      );
      return;
    }

    final success = await incomeProvider.createCategory(token, category);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category successfully created')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              incomeProvider.errorMessage ?? 'Failed to create category',
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
          'Tambah Jenis Iuran',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<IncomeCategoriesProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
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
                                  Icons.add_circle,
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
                                      'Add New Category',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    Text(
                                      'Create a new income category',
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
                          CustomTextFormField(
                            controller: _nameController,
                            labelText: "Category Name",
                            hintText: "Enter category name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter category name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Rem.rem1),
                          CustomDropdown<IncomeType>(
                            labelText: "Category Type",
                            hintText: "-- SELECT TYPE --",
                            items: IncomeType.values.map((type) {
                              return DropdownMenuEntry(
                                value: type,
                                label: type.label,
                              );
                            }).toList(),
                            onSelected: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                          const SizedBox(height: Rem.rem1),
                          CustomTextFormField(
                            controller: _nominalController,
                            labelText: "Nominal Amount",
                            hintText: "Enter nominal amount",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter nominal amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Rem.rem1),
                          CustomTextFormField(
                            controller: _descriptionController,
                            labelText: "Description",
                            hintText: "Enter category description",
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Rem.rem1_5),
                          CustomButton(
                            onPressed: provider.isLoading ? null : _submitForm,
                            child: provider.isLoading
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
                                        'Creating...',
                                        style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Create Category',
                                    style: GoogleFonts.poppins(fontSize: Rem.rem1),
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
        },
      ),
    );
  }
}

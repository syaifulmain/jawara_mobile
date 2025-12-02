import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../enums/income_type.dart';
import '../../../models/income/income_categories_model.dart';
import '../../../providers/income_categories_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';

class IncomeCategoryDetailScreen extends StatefulWidget {
  final String categoryId;

  const IncomeCategoryDetailScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<IncomeCategoryDetailScreen> createState() => _IncomeCategoryDetailScreenState();
}

class _IncomeCategoryDetailScreenState extends State<IncomeCategoryDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nominalController = TextEditingController();
  final _descriptionController = TextEditingController();
  IncomeType? _selectedType;
  bool _isEditMode = false;
  IncomeCategories? _category;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_category == null) {
      _loadCategory();
    }
  }

  void _loadCategory() {
    final incomeProvider = context.read<IncomeCategoriesProvider>();

    try {
      _category = incomeProvider.categories.firstWhere(
        (c) => c.id.toString() == widget.categoryId,
      );

      if (_category != null) {
        _nameController.text = _category!.name;
        _nominalController.text = _category!.nominal;
        _descriptionController.text = _category!.description;
        _selectedType = _category!.type;
      }
    } catch (e) {
      // Category not found in current list, try to fetch from server
      _fetchCategoryFromServer();
    }
  }

  void _fetchCategoryFromServer() async {
    final authProvider = context.read<AuthProvider>();
    final incomeProvider = context.read<IncomeCategoriesProvider>();
    
    if (authProvider.token != null) {
      await incomeProvider.fetchCategoryById(authProvider.token!, widget.categoryId);
      _category = incomeProvider.selectedCategories;
      
      if (_category != null) {
        setState(() {
          _nameController.text = _category!.name;
          _nominalController.text = _category!.nominal;
          _descriptionController.text = _category!.description;
          _selectedType = _category!.type;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nominalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _loadCategory();
      }
    });
  }

  Future<void> _updateCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category type')),
      );
      return;
    }

    final updatedCategory = IncomeCategories(
      id: _category!.id,
      name: _nameController.text,
      type: _selectedType!,
      nominal: _nominalController.text,
      description: _descriptionController.text,
      createdBy: _category!.createdBy,
      createdAt: _category!.createdAt,
      updatedAt: DateTime.now(),
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final incomeProvider = Provider.of<IncomeCategoriesProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not logged in')),
      );
      return;
    }

    final success = await incomeProvider.updateCategories(
      token,
      widget.categoryId,
      updatedCategory,
    );

    if (success) {
      if (mounted) {
        // Refresh data from server to ensure synchronization
        await incomeProvider.fetchCategories(authProvider.token!);
        
        // Update selectedCategories if it matches
        if (incomeProvider.selectedCategories?.id == widget.categoryId) {
          await incomeProvider.fetchCategoryById(authProvider.token!, widget.categoryId);
          _category = incomeProvider.selectedCategories;
        }
        
        setState(() {
          _isEditMode = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category successfully updated')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              incomeProvider.errorMessage ?? 'Failed to update category',
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final incomeProvider = Provider.of<IncomeCategoriesProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not logged in')),
      );
      return;
    }

    final success = await incomeProvider.deleteCategories(token, widget.categoryId);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category successfully deleted')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              incomeProvider.errorMessage ?? 'Failed to delete category',
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
          _isEditMode ? 'Edit Category' : 'Category Detail',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: 'Edit',
            ),
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteCategory,
              tooltip: 'Delete',
            ),
        ],
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
                                  Icons.category,
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
                                      _isEditMode ? 'Edit Category' : 'Category Information',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    Text(
                                      _isEditMode ? 'Update category details' : 'View category information',
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
                            readOnly: !_isEditMode,
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
                            initialSelection: _selectedType,
                            items: IncomeType.values.map((type) {
                              return DropdownMenuEntry(
                                value: type,
                                label: type.label,
                              );
                            }).toList(),
                            onSelected: _isEditMode ? (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            } : null,
                          ),
                          const SizedBox(height: Rem.rem1),
                          CustomTextFormField(
                            controller: _nominalController,
                            labelText: "Nominal Amount",
                            hintText: "Enter nominal amount",
                            readOnly: !_isEditMode,
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
                            readOnly: !_isEditMode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),
                          
                          if (!_isEditMode && _category != null) ...[
                            const SizedBox(height: Rem.rem1),
                            const Divider(),
                            const SizedBox(height: Rem.rem1),
                            _buildDetailRow('Created By', _category!.createdByDisplayName, Icons.person),
                            const SizedBox(height: Rem.rem0_5),
                            _buildDetailRow('Created At', DateFormat('dd MMMM yyyy, HH:mm').format(_category!.createdAt), Icons.calendar_today),
                            const SizedBox(height: Rem.rem0_5),
                            _buildDetailRow('Updated At', DateFormat('dd MMMM yyyy, HH:mm').format(_category!.updatedAt), Icons.update),
                          ],

                          if (_isEditMode) ...[
                            const SizedBox(height: Rem.rem1_5),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    onPressed: provider.isLoading ? null : _updateCategory,
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
                                                'Updating...',
                                                style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'Update Category',
                                            style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: Rem.rem1),
                                Expanded(
                                  child: CustomButton(
                                    onPressed: _toggleEditMode,
                                    isOutlined: true,
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: Rem.rem0_75),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: Rem.rem0_875,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: Rem.rem1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

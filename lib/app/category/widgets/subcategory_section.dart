import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SubcategorySection extends StatefulWidget {
  const SubcategorySection(
    this.subcategory, {
    super.key,
    required this.category,
  });

  final SubcategoryModel subcategory;
  final CategoryModel category;

  @override
  State<SubcategorySection> createState() => _SubcategorySectionState();
}

class _SubcategorySectionState extends State<SubcategorySection> {
  late final TextEditingController _nameController;
  var _fields = <String>[];
  bool _isBook = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subcategory.name);
    _fields = widget.subcategory.fields;
    _isBook = widget.subcategory.isBook;
  }

  void _onSaveTap() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Get.find<CategoryController>().onSaveSubcategory(
      subcategory: widget.subcategory.copyWith(
        name: _nameController.text,
        fields: _fields,
        isBook: _isBook,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GetBuilder<CategoryController>(
        id: CategoryScreen.updateId,
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                controller.onSubcategoryTap(null);
              },
              icon: const Icon(Icons.close),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subcategory: ${widget.subcategory.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InputField(
                        controller: _nameController,
                        label: 'Subcategory Name',
                        validator: AppValidators.userName,
                      ),
                      SwitchListTile.adaptive(
                        value: _isBook,
                        onChanged: (value) => setState(() => _isBook = value),
                        title: const Text('Is this a book category?'),
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'All Available Options',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...widget.category.configurations.indexed.map(
                        (e) {
                          final i = e.$1;
                          final configuration = widget.category.configurations[i];
                          final isSelected = _fields.contains(configuration.value);
                          return ListTile(
                            title: Text(
                              configuration.text,
                              style: TextStyle(
                                color: isSelected ? AppColors.primary : AppColors.black,
                              ),
                            ),
                            tileColor: isSelected ? AppColors.onPrimary : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _fields.remove(configuration.value);
                                } else {
                                  _fields.add(configuration.value);
                                }
                              });
                            },
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppButton(
              onTap: _onSaveTap,
              label: 'Save',
            )
          ],
        ),
      );
}

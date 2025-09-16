import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SubcategoryDialog extends StatefulWidget {
  const SubcategoryDialog(
    this.category, {
    super.key,
  });

  final CategoryModel category;

  @override
  State<SubcategoryDialog> createState() => _SubcategoryDialogState();
}

class _SubcategoryDialogState extends State<SubcategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _fields = [];
  bool _isBook = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _onSaveTap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_fields.isEmpty) {
      return;
    }
    final value = _nameController.text.trim().camelCase ?? _nameController.text.trim();
    final didSaved = await Get.find<CategoryController>().onSaveSubcategory(
      isNew: true,
      subcategory: SubcategoryModel(
        id: '',
        categoryId: widget.category.id,
        name: _nameController.text,
        value: value,
        isBook: _isBook,
        fields: widget.category.configurations
            .where((e) => _fields.contains(e.text))
            .map(
              (e) => e.value,
            )
            .toList(),
      ),
    );
    if (didSaved) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text(
                'Add Subcategory',
                style: TextStyle(
                  fontSize: 16,
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
                'Select Fields',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                children: widget.category.configurations.map(
                  (configuration) {
                    final isSelected = _fields.contains(configuration.text);
                    return TapHandler(
                      onTap: () {
                        if (isSelected) {
                          _fields.remove(configuration.text);
                        } else {
                          _fields.add(configuration.text);
                        }
                        setState(() {});
                      },
                      radius: 8,
                      child: Chip(
                        label: Text(
                          configuration.text,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        backgroundColor: isSelected ? AppColors.primary : null,
                      ),
                    );
                  },
                ).toList(),
              ),
              AppButton(
                onTap: _onSaveTap,
                label: 'Save',
              ),
            ],
          ),
        ),
      );
}

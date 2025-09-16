import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({
    super.key,
    this.category,
  });

  final CategoryModel? category;

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();

  bool get isNew => widget.category == null;

  late final TextEditingController _nameController;

  bool _showBooks = false;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _showBooks = widget.category?.showBooks ?? false;
    _isActive = widget.category?.isActive ?? false;
  }

  Future<void> _onSaveTap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final value = _nameController.text.trim().camelCase ?? _nameController.text.trim();
    final didSaved = await Get.find<CategoryController>().onSaveCategory(
      isNew: isNew,
      category: CategoryModel(
        id: widget.category?.id ?? '',
        name: _nameController.text,
        value: value,
        showBooks: _showBooks,
        isActive: _isActive,
      ),
    );
    if (didSaved) {
      Get.back();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
              Text(
                isNew ? 'Add Category' : 'Edit Category',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InputField(
                controller: _nameController,
                label: 'Category Name',
                validator: AppValidators.userName,
              ),
              SwitchListTile(
                hoverColor: Colors.transparent,
                tileColor: Colors.transparent,
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                title: const Text('Active'),
              ),
              Column(
                children: [
                  SwitchListTile(
                    hoverColor: Colors.transparent,
                    tileColor: Colors.transparent,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    value: _showBooks,
                    onChanged: (value) {
                      setState(() {
                        _showBooks = value;
                      });
                    },
                    title: const Text('Show Books'),
                  ),
                  Text(
                    'Enabling showBooks will show Notebook and Alphabet books to the user for this category',
                    style: context.labelSmall,
                  ),
                ],
              ),
              AppButton(
                onTap: _onSaveTap,
                label: isNew ? 'Save' : 'Update',
              ),
            ],
          ),
        ),
      );
}

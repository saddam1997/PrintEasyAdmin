import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CollectionDialog extends StatefulWidget {
  const CollectionDialog({
    super.key,
    this.collection,
    required this.section,
  });

  final CollectionModel? collection;
  final int section;

  @override
  State<CollectionDialog> createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<CollectionDialog> {
  final _labelTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var bannerImage = '';
  var bannerImageData = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _labelTEC.text = widget.collection?.name ?? '';
    _descriptionTEC.text = widget.collection?.description ?? '';
    bannerImage = widget.collection?.image ?? '';
  }

  void pickBannerImage() async {
    final image = await ImageService.i.pickImage();
    if (image == null) {
      return;
    }

    bannerImageData = image;
    setState(() {});
  }

  Future<void> onSaveTap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.collection == null && bannerImageData.isEmpty) {
      Utility.openSnackbar('Banner image is required');
      return;
    }

    final collection = CollectionModel(
      id: widget.collection?.id ?? '',
      categoryId: widget.collection?.categoryId ?? '',
      name: _labelTEC.text.trim(),
      description: _descriptionTEC.text.trim(),
      image: bannerImage,
      section: widget.section,
    );

    final didSaved = await Get.find<CategoryController>().onSaveCollection(
      collection: collection,
      imageData: bannerImageData,
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
              Text(
                widget.collection == null ? 'New Collection' : 'Collection: ${widget.collection!.name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InputField(
                controller: _labelTEC,
                label: 'Collection Name',
                hintText: 'Super Hero',
                validator: AppValidators.userName,
              ),
              InputField(
                controller: _descriptionTEC,
                label: 'Description',
                hintText: 'Super Hero Collection',
                validator: AppValidators.userName,
                maxLines: 3,
              ),
              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (bannerImageData.isNotEmpty) ...[
                Image.memory(
                  bannerImageData,
                  height: 100,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ] else if (bannerImage.isNotEmpty) ...[
                AppImage(
                  bannerImage,
                  height: 100,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ] else ...[
                const Text(
                  'No banner image selected',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              AppButton.small(
                onTap: pickBannerImage,
                label: 'Pick Banner Image',
                backgroundColor: AppColors.background,
                borderColor: AppColors.primary,
                foregroundColor: AppColors.primary,
              ),
              const SizedBox(height: 24),
              AppButton(
                onTap: onSaveTap,
                label: widget.collection == null ? 'Add Collection' : 'Save Collection',
              ),
            ],
          ),
        ),
      );
}

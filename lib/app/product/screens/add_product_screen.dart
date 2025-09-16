import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({
    super.key,
    this.product,
  });

  final ProductModel? product;

  static const String route = AppRoutes.addProduct;

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        initState: (_) {
          final controller = Get.find<ProductController>();
          controller.initProduct(product);
        },
        builder: (controller) => Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: Get.back,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 40,
                      runSpacing: 16,
                      children: [
                        if (product != null) ...[
                          ProductSwitch(
                            label: 'Is Active?',
                            value: controller.isActive,
                            onChanged: controller.onChangeIsActive,
                          ),
                        ],
                        ProductSwitch(
                          label: 'Is Featured?',
                          value: controller.isFeatured,
                          onChanged: controller.onChangeIsFeatured,
                        ),
                        ProductSwitch(
                          label: 'Is Best Seller?',
                          value: controller.isBestSeller,
                          onChanged: controller.onChangeIsBestSeller,
                        ),
                        ProductSwitch(
                          label: 'Is New Arrival?',
                          value: controller.isNewArrival,
                          onChanged: controller.onChangeIsNewArrival,
                        ),
                        ProductSwitch(
                          label: 'Is Top Choice?',
                          value: controller.isTopChoice,
                          onChanged: controller.onChangeIsTopChoice,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          child: DropDown<CategoryModel>(
                            label: 'Category',
                            value: controller.selectedCategory,
                            items: controller.categories,
                            itemBuilder: (_, category) => Text(category.name),
                            validator: (value) => value == null ? 'Required' : null,
                            onChanged: (selectedCategory) {
                              if (selectedCategory != null) {
                                controller.selectCategory(selectedCategory);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                            child: DropDown<SubcategoryModel>(
                          label: 'Sub-Category',
                          value: controller.selectedSubCategory,
                          items: controller.subCategories,
                          itemBuilder: (_, subCategory) => Text(subCategory.name),
                          validator: (value) => value == null ? 'Required' : null,
                          onChanged: (subCategory) {
                            if (subCategory != null) {
                              controller.selectSubCategory(subCategory);
                            }
                          },
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ResponsiveBuilder(
                      mobile: Column(
                        children: [
                          InputField(
                            label: 'Product Name',
                            controller: controller.productNameController,
                            validator: AppValidators.userName,
                          ),
                          const SizedBox(height: 16),
                          InputField(
                            label: 'SKU',
                            hintText: 'TSHIRT001',
                            controller: controller.skuController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              UpperCaseTextFormatter(),
                            ],
                          ),
                        ],
                      ),
                      desktop: Row(
                        children: [
                          Expanded(
                            child: InputField(
                              label: 'Product Name',
                              controller: controller.productNameController,
                              validator: AppValidators.userName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputField(
                              label: 'SKU',
                              hintText: 'TSHIRT001',
                              controller: controller.skuController,
                              validator: AppValidators.userName,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                                UpperCaseTextFormatter(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Product Description',
                      controller: controller.descriptionController,
                      minLines: 2,
                      maxLines: 3,
                      validator: AppValidators.userName,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Product Care',
                      controller: controller.careController,
                      validator: AppValidators.userName,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ResponsiveBuilder(
                      mobile: Column(
                        children: [
                          InputField(
                            label: 'Subtitle',
                            hintText: 'Comfortable cotton t-shirt for everyday wear',
                            controller: controller.subtitleController,
                            validator: AppValidators.userName,
                          ),
                          const SizedBox(height: 16),
                          InputField(
                            label: 'Tags - comma separated (Eg. apparel, customizable, t-shirt)',
                            hintText: 'apparel, customizable, t-shirt',
                            controller: controller.tagsController,
                            validator: AppValidators.userName,
                          ),
                        ],
                      ),
                      desktop: Row(
                        children: [
                          Expanded(
                            child: InputField(
                              label: 'Subtitle',
                              hintText: 'Comfortable cotton t-shirt for everyday wear',
                              controller: controller.subtitleController,
                              validator: AppValidators.userName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputField(
                              label: 'Tags - comma separated (Eg. apparel, customizable, t-shirt)',
                              hintText: 'apparel, customizable, t-shirt',
                              controller: controller.tagsController,
                              validator: AppValidators.userName,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            label: 'Base Price',
                            textInputType: TextInputType.number,
                            controller: controller.basePriceController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InputField(
                            label: 'Discounted Price',
                            textInputType: TextInputType.number,
                            controller: controller.discountedPriceController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Dimensions'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            label: 'Height (in cm)',
                            textInputType: TextInputType.number,
                            controller: controller.heightController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InputField(
                            label: 'Width (in cm)',
                            textInputType: TextInputType.number,
                            controller: controller.widthController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            label: 'Length (in cm)',
                            textInputType: TextInputType.number,
                            controller: controller.lengthController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InputField(
                            label: 'Weight (in kg)',
                            textInputType: TextInputType.number,
                            controller: controller.weightController,
                            validator: AppValidators.userName,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const ChipsInputField(),
                    const SizedBox(height: 16),
                    Column(
                      children: controller.configurations.indexed.map(
                        (e) {
                          final option = e.$2;
                          final index = e.$1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  option.label ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: option.options.map(
                                      (opt) {
                                        var isSelected = controller.selectedOptions[index].options.any((e) => e.value == opt.value);
                                        return FilterChip(
                                          label: Text(opt.text),
                                          selected: isSelected,
                                          labelStyle: TextStyle(color: isSelected ? AppColors.white : AppColors.black),
                                          showCheckmark: false,
                                          selectedColor: AppColors.primary,
                                          onSelected: (selected) {
                                            controller.toggleOptionSelection(option.value, opt, selected);
                                          },
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 16),
                    if (controller.selectedOptions.isNotEmpty) ...[
                      OptionsWidget(
                        optionsList: controller.selectedOptions.first.options,
                        product: product,
                      ),
                    ],
                    const SizedBox(height: 16),
                    const _SizeChartImage(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Is Customizable?',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        Obx(
                          () => Switch(
                            activeTrackColor: AppColors.primary,
                            value: controller.isCustomizable,
                            onChanged: controller.onChangeIsCustomizable,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (controller.isCustomizable) ...[
                      const SizedBox(height: 16),
                      InputField(
                        label: 'Preset Text',
                        controller: controller.presetTextController,
                      ),
                      const SizedBox(height: 16),
                      const ColorOptions(),
                      const SizedBox(height: 16),
                      const FontOptions(),
                      const SizedBox(height: 16),
                      const FontSizeOptions(),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: IllustrationSize.values.map(
                          (e) {
                            final isSelected = controller.selectedIllustrationSize == e;
                            return TapHandler(
                              radius: 0,
                              onTap: () {
                                controller.selectedIllustrationSize = e;
                                controller.update();
                              },
                              child: Chip(
                                label: Text(
                                  e.label,
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          AppButton.small(
                            onTap: controller.selectedCategory == null
                                ? null
                                : () {
                                    Get.dialog(
                                      DialogWrapper(
                                        child: SelectIllustrationDialog(
                                          illustrations: controller.selectedCategory!.illustrations,
                                        ),
                                      ),
                                    );
                                  },
                            label: 'Pick Illustration',
                            backgroundColor: AppColors.background,
                            borderColor: AppColors.primary,
                            foregroundColor: AppColors.primary,
                          ),
                          const SizedBox(width: 16),
                          Obx(
                            () => controller.selectedIllustration.isEmpty
                                ? const Text('No illustration selected')
                                : AppImage(
                                    controller.selectedIllustration,
                                    height: 100,
                                    width: 100,
                                  ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    ResponsiveBuilder(
                      mobile: Column(
                        children: [
                          const _ProductImages(),
                          if (controller.isCustomizable) ...[
                            const SizedBox(height: 16),
                            const _CanvasImage(),
                          ],
                        ],
                      ),
                      desktop: Row(
                        children: [
                          const Expanded(
                            child: _ProductImages(),
                          ),
                          if (controller.isCustomizable) ...[
                            const SizedBox(width: 16),
                            const Expanded(
                              child: _CanvasImage(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      onTap: () => controller.addProduct(product),
                      label: product != null && product!.id.isNotEmpty ? 'Update Product' : 'Add Product',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _SizeChartImage extends StatelessWidget {
  const _SizeChartImage();

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Builder(
                builder: (_) {
                  if (controller.sizeChartPickedImage != null) {
                    return Stack(
                      children: [
                        Image.memory(
                          controller.sizeChartPickedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform.scale(
                            scale: 0.6,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              icon: const Icon(Icons.close),
                              color: AppColors.white,
                              onPressed: controller.removeSizeChartImage,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (controller.existingSizeChartImage != null && controller.existingSizeChartImage!.isNotEmpty) {
                    return Stack(
                      children: [
                        AppImage(
                          controller.existingSizeChartImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform.scale(
                            scale: 0.6,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              icon: const Icon(Icons.close),
                              color: AppColors.white,
                              onPressed: controller.removeSizeChartImage,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('No size chart image selected');
                },
              ),
            ),
            const SizedBox(height: 16),
            AppButton.small(
              onTap: controller.pickSizeChartImage,
              label: 'Pick Size Chart Image',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            ),
          ],
        ),
      );
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({super.key, required this.optionsList, this.product});

  final List<OptionsModel> optionsList;
  final ProductModel? product;

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.getChipTexts().isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: optionsList.length,
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              var option = optionsList[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    option.label ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.getChipTexts().length,
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final chip = controller.getChipTexts()[index];
                          final key = '${option.value},$chip';
                          return InputField(
                            label: '$chip value',
                            hintText: 'Enter $chip value',
                            textInputType: TextInputType.number,
                            controller: controller.getController(key),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
}

class ChipsInputField extends StatelessWidget {
  const ChipsInputField({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              controller: controller.extraConfigurationController,
              label: "Enter Extra Configuration and press ',' to add (Eg. Chest Size,)",
              onChanged: (value) {
                if (value.endsWith(',')) {
                  controller.addChip(value.replaceAll(',', ''));
                }
              },
              onFieldSubmit: (value) {
                controller.addChip(value);
              },
            ),
            const SizedBox(height: 16),
            Obx(
              () => Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.chips
                    .map(
                      (chipText) => Chip(
                        label: Text(chipText),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => controller.removeChip(chipText),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
}

class _CanvasImage extends StatelessWidget {
  const _CanvasImage();

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: Builder(
                  builder: (_) {
                    if (controller.canvasPickedImage != null) {
                      return Stack(
                        children: [
                          Image.memory(
                            controller.canvasPickedImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Transform.scale(
                              scale: 0.6,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                icon: const Icon(Icons.close),
                                color: AppColors.white,
                                onPressed: controller.removeCanvasImage,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (controller.existingCanvasImage != null) {
                      return Stack(
                        children: [
                          AppImage(
                            controller.existingCanvasImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Transform.scale(
                              scale: 0.6,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                icon: const Icon(Icons.close),
                                color: AppColors.white,
                                onPressed: controller.removeCanvasImage,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const Text('No canvas image selected');
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton.small(
              onTap: controller.pickCanvasImage,
              label: 'Pick Canvas Image',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            ),
          ],
        ),
      );
}

class _ProductImages extends StatelessWidget {
  const _ProductImages();

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.productPickedImages.isEmpty && controller.existingProductImages.isEmpty) ...[
              const Center(
                child: Text('No product images selected'),
              ),
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Show existing images
                  ...controller.existingProductImages.indexed.map(
                    (e) => Stack(
                      children: [
                        AppImage(
                          e.$2,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform.scale(
                            scale: 0.6,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              icon: const Icon(Icons.close),
                              color: AppColors.white,
                              onPressed: () => controller.removeProductImage(
                                controller.productPickedImages.length + e.$1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Show newly picked images
                  ...controller.productPickedImages.indexed.map(
                    (e) => Stack(
                      children: [
                        Image.memory(
                          e.$2,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform.scale(
                            scale: 0.6,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              icon: const Icon(Icons.close),
                              color: AppColors.white,
                              onPressed: () => controller.removeProductImage(e.$1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            AppButton.small(
              onTap: controller.pickProductImages,
              label: 'Pick Product Image',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            ),
          ],
        ),
      );
}

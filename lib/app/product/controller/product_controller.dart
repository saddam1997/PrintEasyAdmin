import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ProductController extends GetxController {
  ProductController(this._viewModel);
  final ProductViewModel _viewModel;

  final formKey = GlobalKey<FormState>();

  var productNameController = TextEditingController();
  var subtitleController = TextEditingController();
  var descriptionController = TextEditingController();
  var careController = TextEditingController();
  var tagsController = TextEditingController();
  var heightController = TextEditingController();
  var widthController = TextEditingController();
  var lengthController = TextEditingController();
  var weightController = TextEditingController();
  var presetTextController = TextEditingController();
  var skuController = TextEditingController();

  var basePriceController = TextEditingController();
  var discountedPriceController = TextEditingController();

  var extraTextFieldPairs = <String, TextEditingController>{};

  var chips = <String>[].obs;
  final extraConfigurationController = TextEditingController();

  final RxBool _isCustomizable = true.obs;
  bool get isCustomizable => _isCustomizable.value;
  set isCustomizable(bool value) => _isCustomizable.value = value;

  final RxBool _isActive = true.obs;
  bool get isActive => _isActive.value;
  set isActive(bool value) => _isActive.value = value;

  final RxBool _isFeatured = false.obs;
  bool get isFeatured => _isFeatured.value;
  set isFeatured(bool value) => _isFeatured.value = value;

  final RxBool _isBestSeller = false.obs;
  bool get isBestSeller => _isBestSeller.value;
  set isBestSeller(bool value) => _isBestSeller.value = value;

  final RxBool _isNewArrival = false.obs;
  bool get isNewArrival => _isNewArrival.value;
  set isNewArrival(bool value) => _isNewArrival.value = value;

  final RxBool _isTopChoice = false.obs;
  bool get isTopChoice => _isTopChoice.value;
  set isTopChoice(bool value) => _isTopChoice.value = value;

  final Rx<CategoryStructure> _productStructure = Rx<CategoryStructure>({});
  CategoryStructure get productStructure => _productStructure.value;
  set productStructure(CategoryStructure value) => _productStructure.value = value;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> value) => _categories.value = value;

  List<SubcategoryModel> get subCategories => selectedCategory?.subCategories ?? [];

  List<OptionsModel> get configurations => selectedCategory != null && selectedSubCategory != null
      ? selectedCategory!.configurations.where((e) => selectedSubCategory!.fields.contains(e.value)).toList()
      : [];

  TextEditingController getController(String key) {
    if (!extraTextFieldPairs.containsKey(key)) {
      extraTextFieldPairs[key] = TextEditingController();
    }
    return extraTextFieldPairs[key]!;
  }

  PrintEasyFonts selectedFont = PrintEasyFonts.beachBikini;

  PrintEasyColors selectedColor = PrintEasyColors.black;

  double selectedFontSize = 30.0;

  void removeNewPair(String optionLabel) {
    for (var chip in chips) {
      var key = '$optionLabel,$chip';
      if (extraTextFieldPairs.containsKey(key)) {
        extraTextFieldPairs[key]!.dispose();
        extraTextFieldPairs.remove(key);
      }
    }
  }

  void addChip(String text) {
    if (text.isNotEmpty) {
      chips.add(text.trim());
      extraConfigurationController.clear();
      update();
    }
  }

  void removeChip(String text) {
    chips.remove(text);
    update();
  }

  List<String> getChipTexts() => chips.toList();

  List<IllustrationModel> get illustrations => selectedCategory?.illustrations ?? [];

  RxList<Uint8List> productPickedImages = RxList.empty();
  RxList<String> removedProductImages = RxList.empty();
  RxList<String> existingProductImages = RxList.empty();
  String? existingCanvasImage;
  String? existingSizeChartImage;

  final Rx<Uint8List?> _canvasPickedImage = Rx<Uint8List?>(null);
  Uint8List? get canvasPickedImage => _canvasPickedImage.value;
  set canvasPickedImage(Uint8List? value) => _canvasPickedImage.value = value;

  final Rx<Uint8List?> _sizeChartPickedImage = Rx<Uint8List?>(null);
  Uint8List? get sizeChartPickedImage => _sizeChartPickedImage.value;
  set sizeChartPickedImage(Uint8List? value) => _sizeChartPickedImage.value = value;

  final Rx<CategoryModel?> _selectedCategory = Rx<CategoryModel?>(null);
  CategoryModel? get selectedCategory => _selectedCategory.value;
  set selectedCategory(CategoryModel? value) => _selectedCategory.value = value;

  final Rx<SubcategoryModel?> _selectedSubCategory = Rx<SubcategoryModel?>(null);
  SubcategoryModel? get selectedSubCategory => _selectedSubCategory.value;
  set selectedSubCategory(SubcategoryModel? value) => _selectedSubCategory.value = value;

  final RxList<OptionsModel> _selectedOptions = RxList.empty();
  List<OptionsModel> get selectedOptions => _selectedOptions;
  set selectedOptions(List<OptionsModel> value) => _selectedOptions.value = value;

  final RxString _selectedIllustration = ''.obs;
  String get selectedIllustration => _selectedIllustration.value;
  set selectedIllustration(String value) {
    _selectedIllustration.value = value;
  }

  final Rx<CustomizationOption> _selectedIllustrationOptions = CustomizationOption.withIllustration.obs;
  CustomizationOption get selectedIllustrationOptions => _selectedIllustrationOptions.value;
  set selectedIllustrationOptions(CustomizationOption value) => _selectedIllustrationOptions.value = value;
  final Rx<IllustrationSize> _selectedIllustrationSize = IllustrationSize.large.obs;
  IllustrationSize get selectedIllustrationSize => _selectedIllustrationSize.value;
  set selectedIllustrationSize(IllustrationSize value) {
    _selectedIllustrationSize.value = value;
  }

  final Rx<ProductModel?> _selectedProduct = Rx<ProductModel?>(null);
  ProductModel? get selectedProduct => _selectedProduct.value;
  set selectedProduct(ProductModel? value) => _selectedProduct.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData({
    bool fetchCategories = true,
  }) async {
    try {
      final data = await Future.wait([
        if (fetchCategories) ...[
          _viewModel.getAllCategories(),
        ] else ...[
          Future.value([...categories]),
        ],
        _viewModel.getAllProducts(),
      ]);

      categories = data[0] as List<CategoryModel>? ?? [];
      final products = data[1] as List<ProductModel>? ?? [];

      // Create product structure grouped by category and subcategory
      final structure = <CategoryModel, Map<SubcategoryModel, List<ProductModel>>>{};
      for (final category in categories) {
        final categoryProducts = products.where((p) => p.categoryId == category.id).toList();
        final subcategoryGroups = <SubcategoryModel, List<ProductModel>>{};

        for (final subcategory in category.subCategories) {
          final subcategoryProducts = categoryProducts.where((p) => p.subcategoryId == subcategory.id).toList();
          if (subcategoryProducts.isNotEmpty) {
            subcategoryGroups[subcategory] = subcategoryProducts;
          }
        }

        structure[category] = subcategoryGroups;
      }
      productStructure = structure;

      update();
    } catch (e) {
      Utility.openSnackbar(e.toString(), Colors.red);
    }
  }

  void initProduct(ProductModel? product) async {
    while (categories.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Clear previous state
    productPickedImages.clear();
    existingProductImages.clear();
    removedProductImages.clear();
    canvasPickedImage = null;
    existingCanvasImage = null;
    sizeChartPickedImage = null;
    existingSizeChartImage = null;
    chips.clear();
    extraConfigurationController.clear();
    extraTextFieldPairs.clear();

    if (product == null) {
      selectedCategory = null;
      selectedSubCategory = null;
      productNameController.clear();
      skuController.clear();
      descriptionController.clear();
      careController.clear();
      tagsController.clear();
      subtitleController.clear();
      basePriceController.clear();
      discountedPriceController.clear();
      heightController.clear();
      widthController.clear();
      lengthController.clear();
      weightController.clear();
      selectedOptions.clear();
      isCustomizable = true;
      presetTextController.clear();
      selectedIllustration = '';
      selectedIllustrationSize = IllustrationSize.large;
      selectedFont = PrintEasyFonts.beachBikini;
      selectedColor = PrintEasyColors.black;
      selectedFontSize = 30.0;
      isActive = true;
      isFeatured = false;
      isBestSeller = false;
      isNewArrival = false;
      isTopChoice = false;
    } else {
      selectedCategory = categories.cast<CategoryModel?>().firstWhere(
            (e) => product.categoryId == e?.id,
            orElse: () => null,
          );
      selectedSubCategory = selectedCategory?.subCategories.cast<SubcategoryModel?>().firstWhere(
            (e) => e?.id == product.subcategoryId,
            orElse: () => null,
          );
      productNameController.text = product.name.trim();
      skuController.text = product.sku.trim();
      descriptionController.text = product.description.trim();
      careController.text = product.care.trim();
      tagsController.text = product.tags.join(',');
      subtitleController.text = product.subtitle.trim();
      basePriceController.text = product.basePrice.toString();
      discountedPriceController.text = product.discountedPrice.toString();
      heightController.text = product.dimension.height.toString();
      widthController.text = product.dimension.width.toString();
      lengthController.text = product.dimension.length.toString();
      weightController.text = product.dimension.weight.toString();
      selectedOptions = product.configuration;

      isActive = product.isActive;
      isFeatured = product.isFeatured;
      isBestSeller = product.isBestSeller;
      isNewArrival = product.isNewArrival;
      isTopChoice = product.isTopChoice;

      isCustomizable = product.isCustomizable;
      presetTextController.text = product.presetText;
      selectedIllustration = product.illustrationImage;
      selectedIllustrationSize = product.illustrationSize;
      existingProductImages.value = product.productImages;
      existingCanvasImage = product.canvasImage.isEmpty ? null : product.canvasImage;
      existingSizeChartImage = product.sizeChart;
      selectedFont = product.fontFamily;
      selectedColor = product.fontColor;
      selectedFontSize = product.fontSize;
      var chipValue = <String>{};
      for (var oneD in product.configuration) {
        if (oneD.options.isNotEmpty) {
          for (var twoD in oneD.options) {
            //toggleOptionSelection(oneD.value, twoD, true);
            if (twoD.options.isNotEmpty) {
              for (var threeD in twoD.options) {
                var key = '${twoD.value},${threeD.label}';
                if (!extraTextFieldPairs.containsKey(key)) {
                  extraTextFieldPairs[key] = TextEditingController(text: threeD.value);
                }
                chipValue.add(threeD.label ?? '');
              }
            }
          }
        }
      }

      chips.value = chipValue.toList();
    }
    Utility.updateLater(update);
  }

  void selectCategory(CategoryModel category) {
    selectedCategory = category;
    selectedSubCategory = null;
    selectedOptions = [];
    update();
  }

  void selectSubCategory(SubcategoryModel subcategory) {
    selectedSubCategory = subcategory;
    selectedOptions = configurations
        .map(
          (e) => e.copyWith(
            options: [],
          ),
        )
        .toList();
    update();
  }

  void addExtraConfiguration() {
    for (var current in selectedOptions) {
      extraTextFieldPairs.forEach((key, controller) {
        var matchingValue = key.split(',')[0];
        var label = key.split(',')[1];
        var value = controller.text;
        for (var option in current.options) {
          if (matchingValue == option.value) {
            if (!option.options.any((e) => e.value == value && e.label == label)) {
              option.options.add(OptionsModel(value: value, label: label));
            }
          }
        }
      });
    }
  }

  void toggleOptionSelection(String configurationValue, OptionsModel option, bool isSelected) {
    final outerIndex = selectedOptions.indexWhere((e) => e.value == configurationValue);
    if (outerIndex == -1) {
      return;
    }
    // print(
    //     "Outer Index : ${outerIndex}, Configuration Value : ${configurationValue}, Option : ${option} isSelected : $isSelected");

    final options = selectedOptions[outerIndex].options;

    if (isSelected) {
      options.add(option);
    } else {
      options.remove(option);
      removeNewPair(option.value);
    }

    selectedOptions[outerIndex] = selectedOptions[outerIndex].copyWith(
      options: options,
    );
    update();
  }

  void onChangeFont(PrintEasyFonts value) {
    selectedFont = value;
    update();
  }

  void onChangeFontSize(double value) {
    selectedFontSize = value;
    update();
  }

  void onChangeColor(PrintEasyColors value) {
    selectedColor = value;
    update();
  }

  void onChangeIsCustomizable(bool value) {
    isCustomizable = value;
    selectedIllustration = '';
    canvasPickedImage = null;
    update();
  }

  void onChangeIsActive(bool value) {
    isActive = value;
    update();
  }

  void onChangeIsFeatured(bool value) {
    isFeatured = value;
    update();
  }

  void onChangeIsBestSeller(bool value) {
    isBestSeller = value;
    update();
  }

  void onChangeIsNewArrival(bool value) {
    isNewArrival = value;
    update();
  }

  void onChangeIsTopChoice(bool value) {
    isTopChoice = value;
    update();
  }

  Future<void> pickProductImages() async {
    final images = await ImageService.i.pickMultipleImages();
    productPickedImages.addAll(images);
    update();
  }

  Future<void> pickCanvasImage() async {
    final image = await ImageService.i.pickImage();
    canvasPickedImage = image;
    update();
  }

  Future<void> pickSizeChartImage() async {
    final image = await ImageService.i.pickImage();
    sizeChartPickedImage = image;
    update();
  }

  void removeProductImage(int index) {
    if (index < productPickedImages.length) {
      productPickedImages.removeAt(index);
    } else {
      final existingIndex = index - productPickedImages.length;
      if (existingIndex < existingProductImages.length) {
        final removedImage = existingProductImages[existingIndex];
        removedProductImages.add(removedImage);
        existingProductImages.removeAt(existingIndex);
      }
    }
    update();
  }

  void removeCanvasImage() {
    if (canvasPickedImage != null) {
      canvasPickedImage = null;
    } else if (existingCanvasImage != null) {
      removedProductImages.add(existingCanvasImage!);
      existingCanvasImage = null;
    }
    update();
  }

  void removeSizeChartImage() {
    if (sizeChartPickedImage != null) {
      sizeChartPickedImage = null;
    } else if (existingSizeChartImage != null) {
      removedProductImages.add(existingSizeChartImage!);
      existingSizeChartImage = null;
    }
    update();
  }

  void addProduct([ProductModel? oldProduct]) async {
    try {
      var hasEmptyFields = false;

      if (!formKey.currentState!.validate()) {
        return;
      }

      if (selectedCategory == null || selectedSubCategory == null) {
        Utility.openSnackbar(
          'All fields are required.',
          Colors.red,
        );
        return;
      }

      if (selectedOptions.any((e) => e.options.isEmpty)) {
        Utility.openSnackbar(
          'Atleast one value of each configuration is required.',
          Colors.red,
        );
        return;
      }

      extraTextFieldPairs.forEach((key, controller) {
        if (controller.text.trim().isEmpty) {
          hasEmptyFields = true;
        }
      });

      if (hasEmptyFields) {
        Utility.openSnackbar(
          'Configuration is required.',
          Colors.red,
        );
        return;
      }

      if (isCustomizable) {
        if (selectedIllustration.isEmpty) {
          Utility.openSnackbar(
            'Please select an illustration.',
            Colors.red,
          );
          return;
        }
        if (oldProduct == null && canvasPickedImage == null) {
          Utility.openSnackbar(
            'Please select a canvas image.  ${oldProduct!.id}',
            Colors.red,
          );
          return;
        }
      }

      Utility.showLoader('Uploading images');

      // Delete removed images from storage
      for (final imageUrl in removedProductImages) {
        unawaited(ImageService.i.deleteImage(imageUrl));
      }

      var productImagesFuture = <Future<String?>>[];

      // Upload new canvas image if picked
      var canvasImage = existingCanvasImage;
      var sizeChartImage = existingSizeChartImage;

      if (canvasPickedImage != null) {
        final extension = canvasPickedImage!.fileExtension;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
        final future = ImageService.i.uploadImage(
          file: canvasPickedImage!,
          fileName: fileName,
          directory: 'canvas/${selectedCategory?.id}/${selectedSubCategory?.id}',
        );
        productImagesFuture.add(future);
      }

      if (sizeChartPickedImage != null) {
        final extension = sizeChartPickedImage!.fileExtension;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
        final future = ImageService.i.uploadImage(
          file: sizeChartPickedImage!,
          fileName: fileName,
          directory: 'size-chart/${selectedCategory?.id}/${selectedSubCategory?.id}',
        );
        productImagesFuture.add(future);
      }

      for (final image in productPickedImages) {
        final extension = image.fileExtension;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
        final future = ImageService.i.uploadImage(
          file: image,
          fileName: fileName,
          directory: 'product/${selectedCategory?.id}/${selectedSubCategory?.id}',
        );
        productImagesFuture.add(future);
      }

      var uploadedImages = await Future.wait(productImagesFuture);
      if (canvasPickedImage != null) {
        canvasImage = uploadedImages.first;
        uploadedImages.removeAt(0);
      }
      if (sizeChartPickedImage != null) {
        sizeChartImage = uploadedImages.first;
        uploadedImages.removeAt(0);
      }
      uploadedImages.removeWhere((e) => e == null);

      // Combine existing and new images
      final allProductImages = [
        ...existingProductImages,
        ...uploadedImages.map((e) => e!),
      ];

      Utility.closeLoader();

      // Create product with all images
      final name = productNameController.text.trim();

      final stamp = DateTime.now().millisecondsSinceEpoch.toString();
      final last = stamp.substring(stamp.length - 6);
      final slug = [
        ...name.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ').replaceAll('  ', ' ').split(' ').take(3),
        last,
      ].join(' ').kebabCaseValue;
      addExtraConfiguration();

      final product = ProductModel(
        id: oldProduct?.id ?? '',
        categoryId: selectedCategory!.id,
        subcategoryId: selectedSubCategory!.id,
        name: name,
        subtitle: subtitleController.text.trim(),
        description: descriptionController.text.trim(),
        care: careController.text.trim(),
        productImages: allProductImages,
        canvasImage: canvasImage ?? '',
        illustrationImage: selectedIllustration,
        isCustomizable: isCustomizable,
        sku: skuController.text.trim(),
        slug: slug,
        tags: tagsController.text.split(',').map((e) => e.trim().toLowerCase()).toList(),
        dimension: DimensionModel(
          height: heightController.text.trim().doubleValue,
          width: widthController.text.trim().doubleValue,
          length: lengthController.text.trim().doubleValue,
          weight: weightController.text.trim().doubleValue,
        ),
        configuration: selectedOptions,
        illustrationOption: selectedIllustrationOptions,
        illustrationSize: selectedIllustrationSize,
        presetText: isCustomizable ? presetTextController.text.trim() : '',
        basePrice: basePriceController.text.trim().doubleValue,
        discountedPrice: discountedPriceController.text.trim().doubleValue,
        sizeChart: sizeChartImage ?? '',
        isActive: isActive,
        fontFamily: selectedFont,
        fontColor: selectedColor,
        fontSize: selectedFontSize,
        isBestSeller: isBestSeller,
        isFeatured: isFeatured,
        isNewArrival: isNewArrival,
        isTopChoice: isTopChoice,
      );

      var success = false;

      if (oldProduct != null && oldProduct.id.isNotEmpty) {
        success = await _viewModel.updateProduct(product);
      } else {
        success = await _viewModel.createProduct(product);
      }

      if (success) {
        Utility.openSnackbar('Product added successfully.', Colors.green);
        fetchData(fetchCategories: false);
      } else {
        Utility.openSnackbar('Failed to add product.', Colors.red);
      }
    } catch (e) {
      Utility.openSnackbar(e.toString(), Colors.red);
    }
  }
}

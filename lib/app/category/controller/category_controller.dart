import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CategoryController extends GetxController {
  CategoryController({
    required CategoryViewModel categoryViewModel,
    required ProductViewModel productViewModel,
  })  : _viewModel = categoryViewModel,
        _productViewModel = productViewModel;

  final CategoryViewModel _viewModel;

  final ProductViewModel _productViewModel;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> value) => _categories.value = value;

  var _categoryProductsPage = 1;
  var loadingProducts = false;

  final _throttle = Throttler();

  CategoryModel? selectedCategory;

  SubcategoryModel? selectedSubcategory;

  CollectionModel? selectedCollection;

  List<SubcategoryModel> get subCategories => selectedCategory?.subCategories ?? [];

  List<CollectionModel> get section1Collections => selectedCategory?.collections.where((e) => e.section == 1).toList() ?? [];
  List<CollectionModel> get section2Collections => selectedCategory?.collections.where((e) => e.section == 2).toList() ?? [];
  List<CollectionModel> get section3Collections => selectedCategory?.collections.where((e) => e.section == 3).toList() ?? [];

  List<ProductModel> collectionProducts = [];
  List<ProductModel> categoryProducts = [];

  bool fetchingProducts = false;

  @override
  void onReady() {
    super.onReady();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    categories = await _productViewModel.getAllCategories();
    selectedCategory = categories.firstWhereOrNull(
      (e) => e.id == selectedCategory?.id,
    );
    update([CategoryScreen.updateId]);
  }

  void onCategoryTap(CategoryModel? category) {
    selectedCategory = category;
    onSubcategoryTap(null);
    onCollectionTap(null);
    update([CategoryScreen.updateId]);
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex >= categories.length || newIndex > categories.length) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);

    update([CategoryScreen.updateId]);

    _updateCategoryOrder();
  }

  Future<void> _updateCategoryOrder() async {
    final isUpdated = await _viewModel.updateCategoryOrder(
      categories: categories,
    );

    if (isUpdated) {
      unawaited(getAllCategories());
    }

    update([CategoryScreen.updateId]);
  }

  void onSubcategoryTap(SubcategoryModel? subcategory) {
    selectedSubcategory = subcategory;
    update([CategoryScreen.updateId]);
  }

  void onCollectionTap(CollectionModel? collection) {
    selectedCollection = collection;
    getProductsByCollection();
    update([CategoryScreen.updateId]);
  }

  Future<bool> onSaveCategory({
    required CategoryModel category,
    bool isNew = false,
  }) async {
    var didSaved = false;
    if (isNew) {
      didSaved = await _viewModel.createCategory(
        category: category,
      );
    } else {
      didSaved = await _viewModel.updateCategory(
        categoryId: category.id,
        category: category,
      );
    }
    if (didSaved) {
      unawaited(getAllCategories());
    }
    update([CategoryScreen.updateId]);
    return didSaved;
  }

  Future<bool> onSaveSubcategory({
    required SubcategoryModel subcategory,
    bool isNew = false,
  }) async {
    var didSaved = false;
    if (isNew) {
      didSaved = await _viewModel.createSubcategory(
        categoryId: selectedCategory!.id,
        subcategory: subcategory,
      );
    } else {
      didSaved = await _viewModel.updateSubcategory(
        categoryId: selectedCategory!.id,
        subcategoryId: selectedSubcategory!.id,
        subcategory: subcategory,
      );
    }
    if (didSaved) {
      unawaited(getAllCategories().then((e) {
        final tempCategory = categories.cast<CategoryModel?>().firstWhere(
              (element) => element?.id == selectedCategory!.id,
              orElse: () => selectedCategory,
            );
        onCategoryTap(tempCategory);
        final tempSubcategory = tempCategory?.subCategories.cast<SubcategoryModel?>().firstWhere(
              (element) => element?.id == subcategory.id,
              orElse: () => subcategory,
            );
        onSubcategoryTap(tempSubcategory);
      }));
    }
    update([CategoryScreen.updateId]);
    return didSaved;
  }

  Future<bool> onSaveCollection({
    required CollectionModel collection,
    required Uint8List imageData,
  }) async {
    if (selectedCategory == null) {
      return false;
    }
    var imageUrl = collection.image;

    if (imageData.isNotEmpty) {
      Utility.showLoader();

      final extension = imageData.fileExtension;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final downloadUrl = await ImageService.i.uploadImage(
        file: imageData,
        fileName: fileName,
        directory: 'collections',
      );

      Utility.closeLoader();

      if (downloadUrl == null) {
        Utility.openSnackbar('Failed to upload image');
        return false;
      }

      imageUrl = downloadUrl;
    }

    if (imageUrl.isEmpty) {
      Utility.openSnackbar('Image not found');
      return false;
    }

    final stamp = DateTime.now().millisecondsSinceEpoch.toString();
    final last = stamp.substring(stamp.length - 6);
    final slug = [
      ...collection.name.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ').replaceAll('  ', ' ').split(' ').take(3),
      last,
    ].join(' ').kebabCaseValue;

    collection = collection.copyWith(
      categoryId: selectedCategory!.id,
      slug: slug,
      image: imageUrl,
    );

    var didSaved = false;

    if (collection.id.isNotEmpty) {
      didSaved = await _viewModel.updateCollection(
        collection: collection,
      );
    } else {
      didSaved = await _viewModel.createCollection(
        collection: collection,
      );
    }

    if (didSaved) {
      unawaited(getAllCategories().then((e) {
        final tempCategory = categories.cast<CategoryModel?>().firstWhere(
              (element) => element?.id == selectedCategory!.id,
              orElse: () => selectedCategory,
            );
        onCategoryTap(tempCategory);
      }));
    }
    update([CategoryScreen.updateId]);
    return didSaved;
  }

  void onChangeIsActive({
    required String collectionId,
    required bool value,
  }) async {
    if (selectedCategory == null) {
      return;
    }
    final collection = CollectionModel(
      id: collectionId,
      categoryId: selectedCategory!.id,
      isActive: value,
    );
    final isUpdated = await _viewModel.updateCollection(
      collection: collection,
    );
    if (isUpdated) {
      unawaited(getAllCategories().then((e) {
        final tempCategory = categories.cast<CategoryModel?>().firstWhere(
              (element) => element?.id == selectedCategory!.id,
              orElse: () => selectedCategory,
            );
        onCategoryTap(tempCategory);
      }));
    }
  }

  Future<bool> onSaveConfiguration({
    required OptionsModel configuration,
    required List<String> options,
    bool isNew = false,
  }) async {
    final newOptions = options.map((e) => OptionsModel(label: e, value: e.camelCase ?? '')).toList();
    configuration = configuration.copyWith(
      options: [
        ...configuration.options,
        ...newOptions,
      ],
    );
    var didUpdated = false;
    if (isNew) {
      configuration = configuration.copyWith(
        value: configuration.text.camelCase ?? configuration.text.toLowerCase(),
      );
      didUpdated = await _viewModel.createConfiguration(
        categoryId: selectedCategory!.id,
        configuration: configuration,
      );
    } else {
      didUpdated = await _viewModel.updateConfiguration(
        categoryId: selectedCategory!.id,
        configuration: configuration,
      );
    }
    if (didUpdated) {
      unawaited(getAllCategories());
    }
    update([CategoryScreen.updateId]);
    return didUpdated;
  }

  Future<bool> onRemoveConfigurationOption(OptionsModel configuration, String option) async {
    final didDeleted = await _viewModel.deleteConfigurationOption(
      categoryId: selectedCategory!.id,
      configurationId: configuration.id,
      option: option,
    );
    if (didDeleted) {
      unawaited(getAllCategories());
    }
    update([CategoryScreen.updateId]);
    return didDeleted;
  }

  Future<bool> onAddIllustration() async {
    try {
      final images = await ImageService.i.pickMultipleImages();

      if (images.isEmpty) {
        return false;
      }

      Utility.showLoader();

      var uploadFuture = <Future<String?>>[];

      for (final image in images) {
        final extension = image.fileExtension;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
        final future = ImageService.i.uploadImage(
          file: image,
          fileName: fileName,
          directory: 'illustrations',
        );
        uploadFuture.add(future);
      }

      final downloadUrls = (await Future.wait(uploadFuture)).where((e) => e != null && e.isNotEmpty).toList();

      if (downloadUrls.isEmpty) {
        Utility.closeLoader();
        return false;
      }

      var addFuture = <Future<bool>>[];
      for (final url in downloadUrls) {
        if (url == null || url.trim().isEmpty) {
          continue;
        }
        final future = _viewModel.addIllustration(
          categoryId: selectedCategory!.id,
          imageUrl: url,
        );
        addFuture.add(future);
      }

      final isAdded = (await Future.wait(addFuture)).any((e) => e);

      Utility.closeLoader();

      if (isAdded) {
        unawaited(getAllCategories());
      }
      update([CategoryScreen.updateId]);
      return isAdded;
    } catch (e) {
      debugPrint('$e');
      Utility.closeLoader();
      return false;
    }
  }

  void getProductsByCollection() async {
    if (selectedCollection == null) {
      return;
    }
    fetchingProducts = true;
    update([CategoryScreen.updateId]);

    collectionProducts = await _productViewModel.getProductsByCollection(
      categoryId: selectedCategory!.id,
      collectionId: selectedCollection!.id,
    );
    fetchingProducts = false;
    update([CategoryScreen.updateId]);
  }

  void getProductsByCategory({
    bool forPagination = false,
    bool forceFetch = false,
  }) async {
    _throttle.run(
      () => _getProductsByCategory(
        forPagination: forPagination,
        forceFetch: forceFetch,
      ),
    );
  }

  void _getProductsByCategory({
    bool forPagination = false,
    bool forceFetch = false,
  }) async {
    if (selectedCategory == null) {
      return;
    }

    if (forceFetch) {
      loadingProducts = false;
      _categoryProductsPage = 1;
    }

    if (loadingProducts) {
      return;
    }

    loadingProducts = true;

    if (_categoryProductsPage == -1) {
      return;
    }

    if (!forPagination) {
      _categoryProductsPage = 1;
    }

    var products = await _productViewModel.getProductsByCategory(
      categoryId: selectedCategory!.id,
      page: _categoryProductsPage,
    );

    if (products.isEmpty) {
      loadingProducts = false;
      _categoryProductsPage = -1;
      return;
    }

    _categoryProductsPage++;
    final productIds = collectionProducts.map((e) => e.id).toList();
    products = products.where((e) => !productIds.contains(e.id)).toList();
    categoryProducts.addAll(products);

    loadingProducts = false;
    update([CategoryScreen.updateId]);
  }

  Future<void> onAddProductsTap(List<String> productIds) async {
    if (selectedCollection == null) {
      return;
    }
    final didAdded = await _productViewModel.addProductsToCollection(
      categoryId: selectedCategory!.id,
      collectionId: selectedCollection!.id,
      productIds: productIds,
    );
    if (didAdded) {
      getProductsByCollection();
    }
    update([CategoryScreen.updateId]);
  }

  Future<void> onRemoveProductsTap(List<String> productIds) async {
    if (selectedCollection == null) {
      return;
    }
    final didRemoved = await _productViewModel.removeProductFromCollection(
      categoryId: selectedCategory!.id,
      collectionId: selectedCollection!.id,
      productIds: productIds,
    );
    if (didRemoved) {
      getProductsByCollection();
    }
    update([CategoryScreen.updateId]);
  }
}

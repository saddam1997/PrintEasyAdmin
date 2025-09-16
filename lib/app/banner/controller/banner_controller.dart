import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class BannerController extends GetxController {
  BannerController(this._viewModel);
  final BannerViewmodel _viewModel;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> value) => _categories.value = value;

  final Rx<CategoryModel?> _selectedCategory = Rx<CategoryModel?>(null);
  CategoryModel? get selectedCategory => _selectedCategory.value;
  set selectedCategory(CategoryModel? value) => _selectedCategory.value = value;

  final RxList<BannerModel> _banners = RxList<BannerModel>.empty();
  List<BannerModel> get banners => _banners;
  set banners(List<BannerModel> value) => _banners.value = value;

  var imagesMap = <String, RxList<String>>{}.obs;

  final Rx<Uint8List> _bannerImage = Rx<Uint8List>(Uint8List(0));
  Uint8List get bannerImage => _bannerImage.value;
  set bannerImage(Uint8List value) => _bannerImage.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      categories = await _viewModel.getAllCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    }
    update([BannerScreen.updateId]);
  }

  void selectCategory(CategoryModel category) {
    selectedCategory = category;
    banners = [...category.banners];
    update([BannerScreen.updateId]);
  }

  void reorderBanners(int oldIndex, int newIndex) {
    if (oldIndex >= banners.length || newIndex > banners.length) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = banners.removeAt(oldIndex);
    banners.insert(newIndex, item);

    update([BannerScreen.updateId]);

    _updateBannerOrder();
  }

  Future<void> _updateBannerOrder() async {
    final isUpdated = await _viewModel.updateBannerOrder(
      banners: banners,
    );

    if (isUpdated) {
      unawaited(fetchCategories());
    }

    update([BannerScreen.updateId]);
  }

  void pickBannerImage() async {
    final image = await ImageService.i.pickImage();
    if (image == null) {
      return;
    }

    bannerImage = image;
    update([BannerScreen.updateId]);
  }

  Future<void> uploadBannerImage() async {
    final image = bannerImage;

    if (image.isEmpty) {
      return;
    }

    Utility.showLoader();

    final extension = image.fileExtension;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final downloadUrl = await ImageService.i.uploadImage(
      file: image,
      fileName: fileName,
      directory: 'banners',
    );

    Utility.closeLoader();

    if (downloadUrl == null) {
      return;
    }

    final banner = BannerModel(
      id: '',
      imageUrl: downloadUrl,
      categoryId: selectedCategory?.id ?? '',
      order: banners.length,
    );

    final isAdded = await _viewModel.addBanner(banner: banner);

    if (isAdded) {
      await fetchCategories();
      final category = categories.firstWhere((element) => element.id == banner.categoryId);
      selectCategory(category);
    }
    update([BannerScreen.updateId]);
  }

  void onChangeIsActive({
    required String categoryId,
    required String bannerId,
    required bool value,
  }) async {
    final isUpdated = await _viewModel.updateBanner(
      bannerId: bannerId,
      categoryId: categoryId,
      value: value,
    );
    if (isUpdated) {
      await fetchCategories();
      final category = categories.firstWhere((element) => element.id == categoryId);
      selectCategory(category);
    }
  }
}

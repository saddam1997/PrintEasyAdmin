import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CategoryViewModel {
  CategoryViewModel(this._repository);

  final CategoryRepository _repository;

  Future<bool> createCategory({
    required CategoryModel category,
  }) async {
    try {
      final payload = category.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.createCategory(
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateCategory({
    required String categoryId,
    required CategoryModel category,
  }) async {
    try {
      final payload = category.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.updateCategory(
        categoryId: categoryId,
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateCategoryOrder({
    required List<CategoryModel> categories,
  }) async {
    try {
      final payload = categories.indexed
          .map(
            (e) => {
              'id': e.$2.id,
              'order': e.$1 + 1,
            },
          )
          .toList();

      final res = await _repository.updateCategoryOrder(
        payload: {
          'categories': payload,
        },
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> createSubcategory({
    required String categoryId,
    required SubcategoryModel subcategory,
  }) async {
    try {
      final payload = subcategory.toAPIMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.createSubcategory(
        categoryId: categoryId,
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateSubcategory({
    required String categoryId,
    required String subcategoryId,
    required SubcategoryModel subcategory,
  }) async {
    try {
      final payload = subcategory.toAPIMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.updateSubcategory(
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> createConfiguration({
    required String categoryId,
    required OptionsModel configuration,
  }) async {
    try {
      final payload = configuration.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.createConfiguration(
        categoryId: categoryId,
        payload: payload,
      );

      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateConfiguration({
    required String categoryId,
    required OptionsModel configuration,
  }) async {
    try {
      final payload = configuration.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.updateConfiguration(
        categoryId: categoryId,
        configurationId: configuration.id,
        payload: payload,
      );

      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> deleteConfigurationOption({
    required String categoryId,
    required String configurationId,
    required String option,
  }) async {
    try {
      final res = await _repository.deleteConfigurationOption(
        categoryId: categoryId,
        configurationId: configurationId,
        payload: {'option': option},
      );

      if (res.hasError) {
        return false;
      }
      return true;
    } catch (e, st) {
      debugPrint('$e\n$st');
      return false;
    }
  }

  Future<bool> addIllustration({
    required String categoryId,
    required String imageUrl,
  }) async {
    try {
      final res = await _repository.addIllustration(
        categoryId: categoryId,
        payload: {
          'imageUrl': imageUrl,
        },
      );
      return !res.hasError;
    } catch (e, st) {
      debugPrint('$e\n$st');
      return false;
    }
  }

  Future<bool> createCollection({
    required CollectionModel collection,
  }) async {
    try {
      final payload = collection.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.createCollection(
        categoryId: collection.categoryId,
        payload: payload,
      );
      return !res.hasError;
    } catch (e, st) {
      debugPrint('$e\n$st');
      return false;
    }
  }

  Future<bool> updateCollection({
    required CollectionModel collection,
  }) async {
    try {
      final payload = collection.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.updateCollection(
        categoryId: collection.categoryId,
        collectionId: collection.id,
        payload: payload,
      );
      return !res.hasError;
    } catch (e, st) {
      debugPrint('$e\n$st');
      return false;
    }
  }
}

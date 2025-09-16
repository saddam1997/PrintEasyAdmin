import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ProductViewModel {
  ProductViewModel(this._repository);

  final ProductRepository _repository;

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final res = await _repository.getAllCategories();
      if (res.hasError) {
        return [];
      }
      return res.bodyList.map((e) => CategoryModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return [];
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final res = await _repository.getAllProducts();
      if (res.hasError) {
        return [];
      }
      return res.bodyList.map((e) => ProductModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
      };
      final res = await _repository.getProductsByCategory(
        categoryId: categoryId,
        query: query,
      );
      if (res.hasError) {
        return [];
      }
      return res.bodyList.map((e) => ProductModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCollection({
    required String categoryId,
    required String collectionId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _repository.getProductsByCollection(
        payload: {
          'categoryId': categoryId,
          'identifier': collectionId,
          'page': page,
          'limit': limit,
        },
      );
      if (res.hasError) {
        return [];
      }
      return res.bodyList.map((e) => ProductModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      debugPrint('$e\n$st');
      return [];
    }
  }

  Future<bool> createProduct(
    ProductModel product,
  ) async {
    try {
      final payload = product.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.createProduct(
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateProduct(
    ProductModel product,
  ) async {
    try {
      final payload = product.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );

      final res = await _repository.updateProduct(
        id: product.id,
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> addProductsToCollection({
    required String categoryId,
    required String collectionId,
    required List<String> productIds,
  }) async {
    try {
      final res = await _repository.addProductsToCollection(
        categoryId: categoryId,
        collectionId: collectionId,
        payload: {
          'productIds': productIds,
        },
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> removeProductFromCollection({
    required String categoryId,
    required String collectionId,
    required List<String> productIds,
  }) async {
    try {
      final res = await _repository.removeProductFromCollection(
        categoryId: categoryId,
        collectionId: collectionId,
        payload: {
          'productIds': productIds,
        },
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }
}

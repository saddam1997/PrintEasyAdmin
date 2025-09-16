import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class BannerViewmodel {
  BannerViewmodel(this._repository);

  final BannerRepository _repository;

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

  Future<List<BannerModel>> getBannerImageByCategory({required String categoryId}) async {
    try {
      final res = await _repository.getBannerImageByCategory(categoryId: categoryId);
      if (res.hasError) {
        return [];
      }
      return res.bodyList.map((e) => BannerModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return [];
    }
  }

  Future<bool> addBanner({
    required BannerModel banner,
  }) async {
    try {
      final payload = banner.toMap().removeNullValues(
            removeEmptyStrings: true,
            removeEmptyLists: true,
          );
      final res = await _repository.addBanner(
        payload: payload,
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateBannerOrder({
    required List<BannerModel> banners,
  }) async {
    try {
      final payload = banners.indexed
          .map(
            (e) => {
              'id': e.$2.id,
              'order': e.$1 + 1,
            },
          )
          .toList();

      final res = await _repository.updateBannerOrder(
        payload: {
          'banners': payload,
        },
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }

  Future<bool> updateBanner({
    required String categoryId,
    required String bannerId,
    required bool value,
  }) async {
    try {
      final res = await _repository.updateBanner(
        bannerId: bannerId,
        categoryId: categoryId,
        payload: {
          'isActive': value,
        },
      );
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }
}

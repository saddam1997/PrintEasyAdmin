import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_repository.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// 🧠 ViewModel for managing promo headlines logic (API layer)
class PromoHeadlinesViewModel {
  PromoHeadlinesViewModel(this._repository);

  final PromoHeadlinesRepository _repository;

  /// 📥 Fetch all promo headlines from backend
  Future<List<PromoHeadlineModel>> fetchAllHeadlines() async {
    try {
      final res = await _repository.fetchAllHeadlines();
      if (res.hasError) return [];
      return res.bodyList
          .map((e) => PromoHeadlineModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      debugPrint('fetchAllHeadlines error: $e\n$stack');
      return [];
    }
  }

  /// 🔍 Fetch single headline by [id]
  Future<PromoHeadlineModel?> fetchHeadlineById(String id) async {
    try {
      final res = await _repository.fetchHeadlineById(id);
      if (res.hasError) return null;
      return PromoHeadlineModel.fromMap(res.body);
    } catch (e, stack) {
      debugPrint('fetchHeadlineById error: $e\n$stack');
      return null;
    }
  }

  /// ➕ Create a new promo headline
  Future<PromoHeadlineModel?> createHeadline(PromoHeadlineModel headline) async {
    try {
      final payload = headline.toMap().removeNullValues(
        removeEmptyStrings: true,
        removeEmptyLists: true,
      );
      final res = await _repository.createHeadline(payload: payload);
      if (res.hasError) return null;
      return PromoHeadlineModel.fromMap(res.body);
    } catch (e, stack) {
      debugPrint('createHeadline error: $e\n$stack');
      return null;
    }
  }

  /// 🔁 Update existing promo headline
  Future<PromoHeadlineModel?> updateHeadline(PromoHeadlineModel headline) async {
    try {
      final payload = headline.toMap().removeNullValues(
        removeEmptyStrings: true,
        removeEmptyLists: true,
      );
      final res = await _repository.updateHeadline(
        id: headline.id!,
        payload: payload,
      );
      if (res.hasError) return null;
      return PromoHeadlineModel.fromMap(res.body);
    } catch (e, stack) {
      debugPrint('updateHeadline error: $e\n$stack');
      return null;
    }
  }

  /// 🗑️ Delete headline by [id]
  Future<bool> deleteHeadline(String id) async {
    try {
      final res = await _repository.deleteHeadline(id);
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('deleteHeadline error: $e\n$stack');
      return false;
    }
  }
}

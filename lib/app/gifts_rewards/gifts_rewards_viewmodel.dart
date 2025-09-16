import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/gifts_rewards/gifts_rewards_repository.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// 🧠 ViewModel layer for managing Gift Reward operations.
/// Handles communication between UI and [GiftRewardRepository].
class GiftRewardsViewModel {
  GiftRewardsViewModel(this._repository);

  final GiftRewardRepository _repository;

  /// 📥 Fetch all gift rewards from the API.
  /// Returns a list of [GiftRewardModel] or empty list on error.
  Future<List<GiftRewardModel>> fetchAllRewards() async {
    try {
      final res = await _repository.fetchAllRewards();
      if (res.hasError) return [];
      return res.bodyList
          .map((e) => GiftRewardModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return [];
    }
  }

  /// 🔍 Fetch a specific gift reward by its [id].
  /// Returns a single [GiftRewardModel] or null on error.
  Future<GiftRewardModel?> fetchRewardById(String id) async {
    try {
      final res = await _repository.fetchRewardById(id);
      if (res.hasError) return null;
      return GiftRewardModel.fromMap(res.body);
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return null;
    }
  }

  /// ➕ Create a new gift reward using provided [reward] data.
  /// Returns the created [GiftRewardModel] or null on error.
  Future<GiftRewardModel?> createReward(GiftRewardModel reward) async {
    try {
      final payload = reward.toMap().removeNullValues(
        removeEmptyStrings: true,
        removeEmptyLists: true,
      );

      final res = await _repository.createReward(payload: payload);
      if (res.hasError) return null;
      return GiftRewardModel.fromMap(res.body);
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return null;
    }
  }

  /// ♻️ Update an existing gift reward using provided [reward] data.
  /// Returns the updated [GiftRewardModel] or null on error.
  Future<GiftRewardModel?> updateReward(GiftRewardModel reward) async {
    try {
      final payload = reward.toMap().removeNullValues(
        removeEmptyStrings: true,
        removeEmptyLists: true,
      );
      final res = await _repository.updateReward(
        id: reward.id!,
        payload: payload,
      );
      if (res.hasError) return null;
      return GiftRewardModel.fromMap(res.body);
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return null;
    }
  }

  /// ❌ Delete a gift reward by its [id].
  /// Returns `true` if successfully deleted, otherwise `false`.
  Future<bool> deleteReward(String id) async {
    try {
      final res = await _repository.deleteReward(id);
      return !res.hasError;
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return false;
    }
  }
}

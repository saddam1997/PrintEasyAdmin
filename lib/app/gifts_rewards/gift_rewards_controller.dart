import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/gifts_rewards/gifts_rewards_viewmodel.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// 🎁 GiftRewardsController
/// Handles:
///  - Gift reward form (create/update)
///  - Local list updates (create, update, delete)
///  - UI reactivity via observables
///  - Uses GetX for state + controller management

class GiftRewardsController extends GetxController {
  GiftRewardsController(this._viewModel);

  final GiftRewardsViewModel _viewModel;

  // 📋 Form Controls
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final minOrderController = TextEditingController();
  final discountPercentageController = TextEditingController();
  final discountAmountController = TextEditingController();
  final productIdController = TextEditingController();

  // 🔒 Private state
  GiftType? _giftType;
  bool _isActive = true;
  final RxList<GiftRewardModel> _rewards = <GiftRewardModel>[].obs;
  final Rx<GiftRewardModel?> _selectedReward = Rx<GiftRewardModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isSaving = false.obs;

  // 📤 Public Getters
  List<GiftRewardModel> get rewards => _rewards;

  GiftRewardModel? get selectedReward => _selectedReward.value;

  bool get isLoading => _isLoading.value;

  bool get isSaving => _isSaving.value;

  GiftType? get giftType => _giftType;

  bool get isActive => _isActive;

  // 👀 UI Visibility helpers
  bool get isDiscount => _giftType == GiftType.discount;

  bool get isProductGift => _giftType == GiftType.product;

  bool get isFreeDelivery => _giftType == GiftType.freeDelivery;

  // 🔄 Field change setters
  void setGiftType(GiftType? type) {
    _giftType = type;
    update();
  }

  void setIsActive(bool value) {
    _isActive = value;
    update();
  }

  /// Prefill form from model or clear form
  void initGiftReward(GiftRewardModel? model) {
    if (model != null) {
      _selectedReward.value = model;
      titleController.text = model.title;
      minOrderController.text = model.minOrderAmount.toStringAsFixed(0);
      discountPercentageController.text =
          model.discountPercentage?.toStringAsFixed(1) ?? '';
      discountAmountController.text =
          model.discountAmount?.toStringAsFixed(1) ?? '';
      productIdController.text = model.productId ?? '';
      _giftType = model.giftType;
      _isActive = model.isActive;
    } else {
      reset();
    }
    update();
  }

  /// 🚀 Create or Update reward (and update local list)
  Future<void> submitGiftReward() async {
    if (!formKey.currentState!.validate()) return;
    _isSaving.value = true;
    final model = _buildModelFromForm();

    if (_selectedReward.value != null) {
      // 🔁 Update
      final updatedModel = _selectedReward.value!.copyWith(
        title: model.title,
        minOrderAmount: model.minOrderAmount,
        discountPercentage: model.discountPercentage,
        discountAmount: model.discountAmount,
        productId: model.productId,
        giftType: model.giftType,
        isActive: model.isActive,
      );
      final rcvd = await _viewModel.updateReward(updatedModel);
      if (rcvd != null) {
        final index = _rewards.indexWhere((r) => r.id == rcvd.id);
        if (index != -1) _rewards[index] = rcvd;
        reset();
        Get.back();
        Utility.openSnackbar('Reward updated successfully');
      }
    } else {
      // ➕ Create
      final rcvd = await _viewModel.createReward(model);
      if (rcvd != null) {
        _rewards.insert(0, rcvd);
        reset();
        Get.back();
        Utility.openSnackbar('Reward created successfully');
      }
    }
    _isSaving.value = false;
  }

  /// 🏗️ Build model from form
  GiftRewardModel _buildModelFromForm() => GiftRewardModel(
        title: titleController.text.trim(),
        minOrderAmount: double.tryParse(minOrderController.text.trim()) ?? 0,
        discountPercentage: isDiscount
            ? double.tryParse(discountPercentageController.text.trim())
            : null,
        discountAmount: isDiscount
            ? double.tryParse(discountAmountController.text.trim())
            : null,
        productId: isProductGift ? productIdController.text.trim() : null,
        giftType: _giftType ?? GiftType.other,
        isActive: _isActive,
        createdAt: _selectedReward.value?.createdAt ?? DateTime.now(),
      );

  /// 📦 Fetch rewards (on init only)
  Future<void> loadAllRewards() async {
    _isLoading.value = true;
    final result = await _viewModel.fetchAllRewards();
    _rewards.assignAll(result);
    _isLoading.value = false;
  }

  /// 🔍 Load reward (optional detail screen)
  Future<void> loadRewardById(String id) async {
    _isLoading.value = true;
    final reward = await _viewModel.fetchRewardById(id);
    _selectedReward.value = reward;
    _isLoading.value = false;
  }

  /// 🗑️ Delete reward and update list
  Future<void> deleteReward(String id) async {
    _isLoading.value = true;
    final success = await _viewModel.deleteReward(id);
    if (success) {
      _rewards.removeWhere((r) => r.id == id);
      if (_selectedReward.value?.id == id) {
        reset(); // 🧹 reset if selected was deleted
      }
      Utility.openSnackbar('Reward deleted successfully');
    }
    _isLoading.value = false;
    update();
  }

  /// 🧹 Cleanup
  @override
  void onClose() {
    titleController.dispose();
    minOrderController.dispose();
    discountAmountController.dispose();
    discountPercentageController.dispose();
    productIdController.dispose();
    super.onClose();
  }

  /// 🔄 Reset controller state
  void reset() {
    titleController.clear();
    minOrderController.clear();
    discountPercentageController.clear();
    discountAmountController.clear();
    productIdController.clear();

    _giftType = null;
    _isActive = true;
    _selectedReward.value = null;
    _isSaving.value = false;
    update();
  }
}

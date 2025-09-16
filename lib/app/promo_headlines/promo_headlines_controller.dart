import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_viewmodel.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// 📰 PromoHeadlinesController
/// Handles:
///  - Create/Update/Delete of promo headlines
///  - Local state management (no refetch after CRUD)
///  - Form binding & UI state (loading, saving)
///  - GetX-based state controller
class PromoHeadlinesController extends GetxController {
  PromoHeadlinesController(this._viewModel);

  final PromoHeadlinesViewModel _viewModel;

  // 🔐 Private Observables
  final RxList<PromoHeadlineModel> _headlineList = <PromoHeadlineModel>[].obs;
  final Rx<PromoHeadlineModel?> _selectedHeadline =
      Rx<PromoHeadlineModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isSaving = false.obs;
  final RxBool _isActive = true.obs;

  // 🔓 Public Getters
  List<PromoHeadlineModel> get headlines => _headlineList;

  PromoHeadlineModel? get selectedHeadline => _selectedHeadline.value;

  set selectedHeadline(PromoHeadlineModel? value) =>
      _selectedHeadline.value = value;

  bool get isLoading => _isLoading.value;

  bool get isSaving => _isSaving.value;

  bool get isActive => _isActive.value;

  // 📋 Form Controls
  final formKey = GlobalKey<FormState>();
  final TextEditingController headlineController = TextEditingController();

  /// 🎯 Initialize form (used for edit mode)
  void initializeForm(PromoHeadlineModel? model) {
    if (model != null) {
      headlineController.text = model.headline;
      _isActive.value = model.isActive;
      selectedHeadline = model;
    }
  }

  /// 🔄 Active status toggle
  void toggleActiveStatus(bool value) {
    _isActive.value = value;
    update();
  }

  /// 🚀 Submit (create or update based on context)
  void submitHeadline() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final text = headlineController.text.trim();

    if (_selectedHeadline.value != null) {
      final updated = _selectedHeadline.value!.copyWith(
        headline: text,
        isActive: _isActive.value,
      );
      _updateHeadline(updated);
    } else {
      final newHeadline = PromoHeadlineModel(
        headline: text,
        isActive: _isActive.value,
        createdAt: DateTime.now(),
      );
      _createHeadline(newHeadline);
    }
  }

  /// ➕ Create headline and update local list
  Future<void> _createHeadline(PromoHeadlineModel model) async {
    _isSaving.value = true;
    final created = await _viewModel.createHeadline(model);
    if (created != null) {
      _headlineList.insert(0, created);
      clearForm();
      Get.back();
      Utility.openSnackbar('Promo headline created successfully');
    }
    _isSaving.value = false;
  }

  /// 🔁 Update headline and reflect in list
  Future<void> _updateHeadline(PromoHeadlineModel model) async {
    _isSaving.value = true;
    final updated = await _viewModel.updateHeadline(model);
    if (updated != null) {
      final index = _headlineList.indexWhere((e) => e.id == updated.id);
      if (index != -1) _headlineList[index] = updated;
      clearForm();
      Get.back();
      Utility.openSnackbar('Promo headline updated successfully');
    }
    _isSaving.value = false;
  }

  /// 🗑️ Delete headline and update local list
  Future<void> deleteHeadlineById(String id) async {
    _isLoading.value = true;
    final success = await _viewModel.deleteHeadline(id);
    if (success) {
      _headlineList.removeWhere((e) => e.id == id);

      // 🧹 Reset only if the deleted one was selected
      if (_selectedHeadline.value?.id == id) {
        clearForm(); // no need to reset full state
      }

      update();
      Utility.openSnackbar('Promo headline deleted successfully');
    }
    _isLoading.value = false;
  }

  /// 📦 Load all headlines
  Future<void> fetchAllHeadlines() async {
    _isLoading.value = true;
    final result = await _viewModel.fetchAllHeadlines();
    _headlineList.assignAll(result);
    _isLoading.value = false;
  }

  /// 🔍 Load single headline (used for detail/edit screen)
  Future<void> fetchHeadlineById(String id) async {
    _isLoading.value = true;
    final model = await _viewModel.fetchHeadlineById(id);
    _selectedHeadline.value = model;
    _isLoading.value = false;
  }

  /// 🧹 Reset form
  void clearForm() {
    headlineController.clear();
    _isActive.value = true;
    _selectedHeadline.value = null;
  }

  /// 🔚 Dispose
  @override
  void onClose() {
    headlineController.dispose();
    super.onClose();
  }

// /// 🔁 Reset entire controller state (optional for refresh or on logout)
void reset() {
  clearForm(); // already resets headlineController, _isActive & selectedHeadline
  _isLoading.value = false;
  _isSaving.value = false;
  update();
}
}

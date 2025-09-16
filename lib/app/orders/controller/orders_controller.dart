import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrdersController extends GetxController {
  OrdersController({
    required OrdersViewModel ordersViewModel,
    required ProductViewModel productViewModel,
  })  : _viewModel = ordersViewModel,
        _productViewModel = productViewModel;

  final OrdersViewModel _viewModel;
  final ProductViewModel _productViewModel;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> value) => _categories.value = value;

  final Rx<OrderStatus> _selectedStatus = OrderStatus.confirmed.obs;
  OrderStatus get selectedStatus => _selectedStatus.value;
  set selectedStatus(OrderStatus value) {
    if (value == selectedStatus) {
      return;
    }
    _selectedStatus.value = value;
  }

  CategoryModel? selectedCategory;

  final Map<OrderStatus, List<List<OrderModel>>?> _allOrders = {};

  List<List<OrderModel>> orders(OrderStatus status) => _allOrders[status] ?? [];

  @override
  void onReady() {
    super.onReady();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final data = await Future.wait([
      _productViewModel.getAllCategories(),
      DBWrapper.i.getSecuredValue(AppKeys.selectedCategoryId),
    ]);
    categories = data[0] as List<CategoryModel>;
    final categoryId = data[1] as String;
    final category = categories.firstWhere(
      (e) => e.id == categoryId,
      orElse: () => categories.first,
    );
    onSubcategoryChanged(category);
  }

  void onSubcategoryChanged(
    CategoryModel? category, {
    bool isRefresh = true,
  }) async {
    selectedCategory = category;
    unawaited(
      DBWrapper.i.saveValueSecurely(
        AppKeys.selectedCategoryId,
        category?.id ?? '',
      ),
    );
    if (isRefresh) {
      _allOrders.clear();
    }
    update();
    fetchOrders(selectedStatus, isRefresh: isRefresh);
  }

  void onStatusTap(OrderStatus status) {
    selectedStatus = status;
    if (_allOrders[status] == null) {
      fetchOrders(status);
    }
  }

  void fetchOrders(
    OrderStatus status, {
    bool isRefresh = true,
  }) async {
    if (isRefresh) {
      Utility.updateLater(() => Utility.showLoader('Fetching ${status.label} orders'));
    }
    final data = await _viewModel.getAllOrders(
      categoryId: selectedCategory?.id,
      status: status,
    );
    if (isRefresh) {
      Utility.updateLater(Utility.closeLoader);
    }
    _allOrders.update(
      status,
      (value) => data.clubByDate(isRefresh ? null : value?.flatten()),
      // (orders) => <OrderModel>{...(orders ?? []).flatten(), ...data}.toList().clubByDate(),
      ifAbsent: data.clubByDate,
    );
    update([status.name]);
  }

  void onStatusChange(OrderModel order) async {
    final nextStatus = order.status.nextStatus;
    Utility.showLoader('Changing status to ${order.status.name}');
    final isUpdated = await OrderService.i.changeStatus(order, nextStatus);
    Utility.closeLoader();
    if (isUpdated) {
      fetchOrders(order.status);
      fetchOrders(nextStatus);
    }
  }

  Future<void> _downloadPdf(BuildContext context, OrderModel order) => PdfManager(order).generatePdf(context);

  void downloadSinglePdf(BuildContext context, OrderModel order) {
    Utility.openSnackbar('Pdf is downloading in the background.');
    _downloadPdf(context, order);
  }

  void downloadMultiplePdf(BuildContext context, List<OrderModel> orders) {
    Utility.openSnackbar('${orders.length} pdf(s) are downloading in the background.');
    Future.wait(orders.map((e) => _downloadPdf(context, e)));
  }
}

import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrdersViewModel {
  OrdersViewModel(this._repository);

  final OrdersRepository _repository;

  Future<List<OrderModel>> getAllOrders({
    String? categoryId,
    OrderStatus? status,
  }) async {
    try {
      final payload = {
        'categoryId': categoryId,
        'status': status?.name,
      };
      final res = await _repository.getAllOrders(
        payload.removeNullValues(),
      );
      if (res.hasError) {
        return [];
      }
      return res.bodyList.map((e) => OrderModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      debugPrint('$e\n$stack');
      return [];
    }
  }
}

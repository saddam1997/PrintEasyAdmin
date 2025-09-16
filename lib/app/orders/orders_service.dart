import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrderService {
  const OrderService._();

  static const OrderService _service = OrderService._();

  static OrderService get i => _service;

  Future<List<SubcategoryConfigModel>> getSubcategories() async {
    try {
      final snapshot = await CollectionInterface.subcategories.get();
      final subcategories = snapshot.docs.map((e) => e.data()).toList();

      return subcategories;
    } catch (_) {
      return [];
    }
  }

  Future<bool> changeStatus(OrderModel order, OrderStatus nextStatus) async {
    try {
      final orderDocRef = CollectionInterface.orders.doc(order.orderId);
      await orderDocRef.update({'status': nextStatus.name});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

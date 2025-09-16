import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/app/gifts_rewards/gift_rewards_bindings.dart';
import 'package:printeasy_admin/app/gifts_rewards/screens/gifts_rewards_screen.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_bindings.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_controller.dart';
import 'package:printeasy_admin/app/promo_headlines/screens/promo_headlines_screen.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

extension NavExtension on NavItem {
  Widget get screen {
    switch (this) {
      case NavItem.orders:
        if (!Get.isRegistered<OrdersController>()) {
          OrdersBinding().dependencies();
        }
        return const OrdersScreen();
      case NavItem.categories:
        if (!Get.isRegistered<CategoryController>()) {
          CategoryBinding().dependencies();
        }
        return const CategoryScreen();

      case NavItem.products:
        if (!Get.isRegistered<ProductController>()) {
          ProductBinding().dependencies();
        }
        return const ProductScreen();

      case NavItem.banners:
        if (!Get.isRegistered<BannerController>()) {
          BannerBinding().dependencies();
        }
        return const BannerScreen();

      case NavItem.franchises:
        if (!Get.isRegistered<FranchiseController>()) {
          FranchiseBinding().dependencies();
        }
        return const FranchiseScreen();

      case NavItem.promoHeadlines:
        if (!Get.isRegistered<PromoHeadlinesController>()) {
          PromoHeadlinesBindings().dependencies();
        }
        return const PromoHeadlinesScreen();

      case NavItem.giftRewards:
        if (!Get.isRegistered<FranchiseController>()) {
          GiftRewardsBindings().dependencies();
        }
        return const GiftsRewardsScreen();
      // case NavItem.upload:
      //   if (!Get.isRegistered<UploadController>()) {
      //     UploadBinding().dependencies();
      //   }
      //   return const UploadScreen();
    }
  }
}

extension OrderModelListExtensions on List<OrderModel> {
  List<List<OrderModel>> clubByDate([List<OrderModel>? orders]) {
    final ordersByDate = <DateTime, List<OrderModel>>{};

    final data = [...this, ...?orders];

    for (final order in data) {
      final orderDate = order.orderDate?.toLocal() ?? DateTime.now();
      final dateKey = DateTime(orderDate.year, orderDate.month, orderDate.day);

      if (!ordersByDate.containsKey(dateKey)) {
        ordersByDate[dateKey] = [];
      }

      ordersByDate[dateKey]!.add(order);
    }

    return ordersByDate.values.toList();
  }
}

extension OrderModelListListExtensions on List<List<OrderModel>> {
  List<OrderModel> flatten() => expand((orderList) => orderList).toList();
}

extension StringExtension on String {
  Map<String, String> get header => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $this',
        'x-api-key': AppUtility.apiKey,
      };
}

extension MiscStringExtensions on String {
  String get camelCaseValue =>
      split(' ').map((e) => e.capitalizeFirst ?? '').join('');

  String get snakeCaseValue => split(' ').map((e) => e.toLowerCase()).join('_');

  String get kebabCaseValue => split(' ').map((e) => e.toLowerCase()).join('-');

  double get doubleValue => double.tryParse(replaceAll(',', '')) ?? 0.0;
}

extension Uint8ListExtensions on Uint8List {
  String get hexString =>
      map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');

  String get fileExtension => switch (hexString) {
        '89504e47' => 'png',
        'ffd8ffe0' || 'ffd8ffe1' || 'ffd8ffe2' => 'jpg',
        '47494638' => 'gif',
        _ => 'png',
      };
}

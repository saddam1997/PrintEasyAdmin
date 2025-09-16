// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class DashboardController extends GetxController {
  final Rx<NavItem> _selectedItem = NavItem.categories.obs;
  NavItem get selectedItem => _selectedItem.value;
  set selectedItem(NavItem value) {
    if (value == selectedItem) {
      return;
    }
    _selectedItem.value = value;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();

    html.window.onPopState.listen((event) {
      final currentUrl = html.window.location.href;
      final uri = Uri.parse(currentUrl);
      final path = uri.path;
      selectedItem = NavItem.fromPath(path.replaceAll('/', ''));
      update();
    });

    checkRoute();
  }

  //  ---------- Functions ------------

  void checkRoute() {
    final currentUrl = html.window.location.href;
    final uri = Uri.parse(currentUrl);
    final path = uri.path;

    Utility.updateLater(() {
      selectedItem = NavItem.fromPath(path.replaceAll('/', ''));

      // onNavTap(selectedItem);

      final initialState = {
        'serialCount': 0,
        'page': selectedItem.name,
      };

      html.window.history.replaceState(
        initialState,
        '',
        '/${selectedItem.name}',
      );
    });
  }

  void onNavTap(NavItem item) {
    selectedItem = item;

    final newUrl = '/${item.name}';
    final currentState = html.window.history.state as Map? ?? {};
    final currentCount = currentState['serialCount'] as int? ?? 0;

    html.window.history.pushState(
      {
        'page': item.name,
        'serialCount': currentCount + 1,
      },
      '',
      newUrl,
    );
    update();
  }

  void onRefresh(NavItem item) {
    switch (item) {
      case NavItem.orders:
        var controller = Get.find<OrdersController>();
        controller.fetchOrders(controller.selectedStatus, isRefresh: true);
        break;
      case NavItem.categories:
        break;
      case NavItem.products:
        break;
      case NavItem.banners:
        break;
      case NavItem.franchises:
        break;
      case NavItem.promoHeadlines:
        break;
      case NavItem.giftRewards:
        break;
    }
  }
}
